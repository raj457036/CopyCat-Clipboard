import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'quick_paste_popup_platform_interface.dart';
import 'models/models.dart';

/// An implementation of [QuickPastePopupPlatform] that uses method channels.
class MethodChannelQuickPastePopup extends QuickPastePopupPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('quick_paste_popup');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<QuickPasteResult> showQuickPastePopup({
    required List<ClipboardItemDto> items,
  }) async {
    try {
      final result = await methodChannel.invokeMethod<Map<dynamic, dynamic>>(
        'showQuickPastePopup',
        {'items': items.map((item) => item.toJson()).toList()},
      );

      if (result != null) {
        return QuickPasteResult.fromJson(Map<String, dynamic>.from(result));
      }
      return QuickPasteResult(dismissed: true);
    } catch (e) {
      return QuickPasteResult(error: e.toString());
    }
  }

  @override
  Future<bool> setTheme({int? selectionColor}) async {
    try {
      return await methodChannel.invokeMethod<bool>('setTheme', {
            'selectionColor': selectionColor,
          }) ??
          false;
    } catch (e) {
      debugPrint('Error setting quick paste theme: $e');
      return false;
    }
  }

  @override
  Future<Map<String, double>?> getCursorPosition() async {
    try {
      final result = await methodChannel.invokeMethod<Map<dynamic, dynamic>>(
        'getCursorPosition',
      );

      if (result != null) {
        return {
          'x': (result['x'] as num).toDouble(),
          'y': (result['y'] as num).toDouble(),
        };
      }
      return null;
    } catch (e) {
      debugPrint('Error getting cursor position: $e');
      return null;
    }
  }

  @override
  Future<Map<String, String>?> getFocusedApp() async {
    try {
      final result = await methodChannel.invokeMethod<Map<dynamic, dynamic>>(
        'getFocusedApp',
      );

      if (result != null) {
        return {
          'name': result['name'] as String? ?? '',
          'bundleId': result['bundleId'] as String? ?? '',
        };
      }
      return null;
    } catch (e) {
      debugPrint('Error getting focused app: $e');
      return null;
    }
  }

  @override
  Future<bool> insertTextDirect(String text) async {
    try {
      return await methodChannel.invokeMethod<bool>('insertTextDirect', {
            'text': text,
          }) ??
          false;
    } catch (e) {
      debugPrint('Error inserting text directly: $e');
      return false;
    }
  }
}
