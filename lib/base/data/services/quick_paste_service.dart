import 'package:clipboard/base/bloc/clipboard_cubit/clipboard_cubit.dart';
import 'package:clipboard/base/bloc/offline_persistance_cubit/offline_persistance_cubit.dart';
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/services/application_meta_resolver.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:flutter/material.dart';
import 'package:focus_window/focus_window.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:quick_paste_popup/quick_paste_popup.dart';

/// Service to manage quick paste popup functionality
/// Uses the top-level ClipboardCubit to access clipboard items
@singleton
class QuickPasteService {
  final AppConfigCubit appConfigCubit;
  final ClipboardCubit clipboardCubit;
  final OfflinePersistenceCubit offlinePersistenceCubit;
  final ApplicationMetaResolver applicationMetaResolver;
  final FocusWindow focusWindow;
  final QuickPastePopup _quickPastePopup = QuickPastePopup();

  QuickPasteService(
    this.appConfigCubit,
    this.clipboardCubit,
    this.offlinePersistenceCubit,
    this.applicationMetaResolver,
    this.focusWindow,
  );

  /// Get the top 10 clipboard items for quick paste from the cubit
  Future<List<ClipboardItemDto>> getTopItems({int limit = 10}) async {
    try {
      // If clipboard is still loading, return empty list and let caller handle it
      final allItems = clipboardCubit.state.items;

      if (allItems.isEmpty) {
        return [];
      }

      final items = allItems.take(limit).toList();

      debugPrint(
        '[QuickPasteService] Retrieved ${items.length} items from ClipboardCubit for quick paste',
      );

      return await Future.wait(items.map(_convertToDto));
    } catch (e) {
      return [];
    }
  }

  /// Show the quick paste popup with the top items
  /// Returns the result of the user interaction
  Future<QuickPasteResult?> showQuickPastePopup() async {
    try {
      // Capture the caret position FIRST, while the target app still has
      // focus. Once any async work runs CopyCat may become the frontmost
      // app and the AX query would target CopyCat instead of the editor.
      await _quickPastePopup.captureCaretContext();

      final targetWindowId = await focusWindow.getActiveWindowId();
      var items = await getTopItems();
      debugPrint(
        '[QuickPasteService] Fetched ${items.length} items for quick paste popup',
      );

      // Ensure quick paste still works when the user triggers the hotkey
      // before the initial clipboard fetch has completed.
      if (items.isEmpty) {
        await clipboardCubit.fetch(fromTop: true);
        items = await getTopItems();
      }

      debugPrint(
        '[QuickPasteService] Opening quick paste popup with ${items.length} items',
      );

      final selectionColor = _resolvedQuickPasteSelectionColor().toARGB32();
      await _quickPastePopup.setTheme(selectionColor: selectionColor);
      final result = await _quickPastePopup.showQuickPastePopup(items: items);

      debugPrint(
        '[QuickPasteService] Popup result selected=${result.selectedItemId} dismissed=${result.dismissed} error=${result.error}',
      );

      if (!result.dismissed && result.selectedItemId != null) {
        final pasteError = await _pasteSelectedItem(
          result.selectedItemId!,
          targetWindowId: targetWindowId,
        );
        if (pasteError != null) {
          return QuickPasteResult(
            selectedItemId: result.selectedItemId,
            dismissed: result.dismissed,
            error: pasteError,
          );
        }
      }

      return result;
    } catch (e) {
      debugPrint('[QuickPasteService] Failed to show quick paste popup: $e');
      return null;
    }
  }

  /// Convert ClipboardItem to ClipboardItemDto for the plugin
  Future<ClipboardItemDto> _convertToDto(ClipboardItem item) async {
    final displayText = _displayTextForItem(item);
    final appIconPath = await _appIconPathForItem(item);
    final isImage = item.fileMimeType?.startsWith('image') ?? false;

    return ClipboardItemDto(
      id: item.id?.toString() ?? '',
      text: displayText.isEmpty ? 'Untitled' : displayText,
      appIconPath: appIconPath,
      previewImagePath: isImage ? item.localPath : null,
      isImage: isImage,
      imageBase64: null,
      copiedAt: item.created,
    );
  }

  Future<String?> _pasteSelectedItem(
    String selectedItemId, {
    required int? targetWindowId,
  }) async {
    final selectedItem = _findItemById(selectedItemId);
    if (selectedItem == null) {
      return 'Selected item no longer exists';
    }

    if (selectedItem.encrypted || !selectedItem.inCache) {
      return 'Selected item is not available for paste';
    }

    if (_shouldUseDirectInsert(selectedItem)) {
      if (targetWindowId == null) {
        return 'Unable to restore the target application';
      }

      await focusWindow.setActiveWindowId(targetWindowId);
      await Future.delayed(const Duration(milliseconds: 80));

      final text = _plainTextValue(selectedItem);
      if (text.isNotEmpty) {
        final inserted = await _quickPastePopup.insertTextDirect(text);
        if (inserted) {
          return null;
        }
      }
    }

    final copied = await offlinePersistenceCubit.copyToClipboard([
      selectedItem,
    ]);
    if (!copied) {
      return 'Failed to prepare clipboard data for paste';
    }

    if (targetWindowId == null) {
      return 'Unable to restore the target application';
    }

    await focusWindow.setActiveWindowId(targetWindowId);
    await Future.delayed(const Duration(milliseconds: 80));
    await focusWindow.pasteContent();
    return null;
  }

  ClipboardItem? _findItemById(String selectedItemId) {
    for (final item in clipboardCubit.state.items) {
      if (item.id?.toString() == selectedItemId) {
        return item;
      }
    }
    return null;
  }

  bool _shouldUseDirectInsert(ClipboardItem item) {
    if (!item.isTextType) {
      return false;
    }

    if (item.type == ClipItemType.text &&
        item.richData?.trim().isNotEmpty == true) {
      return false;
    }

    return _plainTextValue(item).isNotEmpty;
  }

  String _plainTextValue(ClipboardItem item) {
    if (item.type == ClipItemType.url) {
      return item.url?.trim() ?? '';
    }
    return item.text?.trim() ?? '';
  }

  String _displayTextForItem(ClipboardItem item) {
    if (item.localPath != null) {
      final filePath = item.localPath!.trim();
      if (filePath.isNotEmpty) {
        final baseName = p.basename(filePath).trim();
        if (baseName.isNotEmpty) {
          return baseName;
        }
      }

      final fileName = item.fileName?.trim();
      if (fileName != null && fileName.isNotEmpty) {
        return fileName;
      }

      final fileMimeType = item.fileMimeType?.trim();
      if (fileMimeType != null && fileMimeType.isNotEmpty) {
        return fileMimeType;
      }
    }

    if (item.type == ClipItemType.url) {
      final url = item.url?.trim();
      if (url != null && url.isNotEmpty) {
        return url;
      }
    }

    final normalizedText = (item.text ?? '')
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n')
        .trim();
    if (normalizedText.isEmpty) {
      return '';
    }

    final compact = normalizedText
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .take(2)
        .join('\n');

    return compact.length > 140
        ? '${compact.substring(0, 140).trim()}...'
        : compact;
  }

  Future<String?> _appIconPathForItem(ClipboardItem item) async {
    final sourceId = item.sourceId?.trim() ?? item.sourceApp?.trim();
    if (sourceId == null || sourceId.isEmpty) {
      return null;
    }
    return await applicationMetaResolver.getIconPathBySourceId(sourceId);
  }

  Color _resolvedQuickPasteSelectionColor() {
    final config = appConfigCubit.state.config;
    final themeMode = config.themeMode;

    final scheme = switch (themeMode) {
      ThemeMode.dark => config.darkThemeColorScheme,
      ThemeMode.light => config.lightThemeColorScheme,
      ThemeMode.system =>
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark
            ? config.darkThemeColorScheme
            : config.lightThemeColorScheme,
    };

    return scheme.primary;
  }

  /// Get cursor position (for testing or other use cases)
  Future<Map<String, double>?> getCursorPosition() async {
    try {
      return await _quickPastePopup.getCursorPosition();
    } catch (e) {
      return null;
    }
  }

  /// Get focused application (for testing or other use cases)
  Future<Map<String, String>?> getFocusedApp() async {
    try {
      return await _quickPastePopup.getFocusedApp();
    } catch (e) {
      return null;
    }
  }
}
