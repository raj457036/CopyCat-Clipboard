// service
import 'dart:async';
import 'dart:convert' show base64;
import 'dart:io';

import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';
import 'package:focus_window/platform/activity_info.dart';
import 'package:focus_window/platform/utils.dart';
import 'package:focus_window/platform/windows_paste_simulator.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:win32/win32.dart';

import 'platform_activity_observer_interface.dart';

final _cache = <String, String>{};
ActivityInfo? _lastActivity;
bool cached = false;

class WindowsActivityObserver implements PlatformActivityObserverInterface {
  const WindowsActivityObserver();

  Future<void> cacheAll() async {
    final futures = <Future>[];

    if (!_cache.containsKey('GetActivity')) {
      futures.add(
        rootBundle
            .loadString('packages/focus_window/window_utils/GetActivity.ps1')
            .then((value) => _cache['GetActivity'] = value),
      );
    }
    if (!_cache.containsKey('GetIcon')) {
      futures.add(
        rootBundle
            .loadString('packages/focus_window/window_utils/GetIcon.ps1')
            .then((value) async {
          final tempDir = await getTemporaryDirectory();
          final file = File(p.join(tempDir.path, '._gi.ps1'));
          await file.writeAsString(value);
          _cache['GetIcon'] = file.path;
        }),
      );
    }
    if (!_cache.containsKey('GetUrl')) {
      //! BUG: Causing keyboard keys to be pressed automatically
      // futures.add(
      //   rootBundle
      //       .loadString('packages/focus_window/window_utils/GetUrl.ps1')
      //       .then((value) async {
      //     final tempDir = await getTemporaryDirectory();
      //     final file = File(p.join(tempDir.path, '._gu.ps1'));
      //     await file.writeAsString(value);
      //     _cache['GetUrl'] = file.path;
      //   }),
      // );
    }

    await Future.wait(futures);
    cached = true;
  }

  @override
  Future<Uint8List?> getIcon(String applicationPath) async {
    final result = await runInPowershell([
      '-File',
      _cache['GetIcon']!,
      '-ApplicationPath',
      applicationPath,
    ]);
    return base64.decode(result.trim());
  }

  @override
  Future<Uint8List?> getIconByIdentifier(String identifier) async {
    if (!cached) await cacheAll();

    final current = _lastActivity ?? await getActivity(withIcon: false);
    if (current.identifier == identifier) {
      return getIcon(current.appFilePath);
    }

    return null;
  }

  Future<String?> getUrl(String app, String windowTitle) async {
    final result = await runInPowershell(
      [
        _cache['GetUrl']!,
        '-app',
        app,
        '-windowTitle',
        "'$windowTitle'",
      ],
    );
    return result;
  }

  @override
  Future<ActivityInfo> getActivity({bool withIcon = false}) async {
    if (!cached) await cacheAll();
    final result = await runInPowershell([
      _cache['GetActivity']!,
    ]);

    var activity = ActivityInfo.fromJson(result);

    // TODO(raj): try to find another way to fetch browser url
    // if (activity.title != _lastActivity?.title) {
    //   final url = await getUrl(activity.appFileName, activity.title);
    //   activity = activity.copyWith(url: url);
    // }

    _lastActivity = activity;

    if (withIcon) {
      final icon = await getIcon(_lastActivity!.appFilePath);
      _lastActivity = _lastActivity!.copyWith(icon: icon);
    }
    return _lastActivity!;
  }

  @override
  Future<bool> isAccessibilityPermissionGranted() async {
    return true;
  }

  @override
  Future<bool> requestAccessibilityPermission() async {
    return true;
  }

  @override
  Stream get events => throw UnimplementedError();

  @override
  Future<bool> get isObserving => throw UnimplementedError();

  @override
  Future<void> startObserver() {
    throw UnimplementedError();
  }

  @override
  Future<void> stopObserver() {
    throw UnimplementedError();
  }

  @override
  Future<int?> getActiveWindowId() async {
    final id = GetForegroundWindow();
    return id;
  }

  @override
  Future<void> setActiveWindowId(int windowId) async {
    SetForegroundWindow(windowId);
  }

  @override
  Future<void> pasteContent() async {
    simulateWindowsPasteShortcut();
  }

  void _setClipboardDwordFlag(String formatName, int value) {
    final formatNamePtr = formatName.toNativeUtf16();
    final formatId = RegisterClipboardFormat(formatNamePtr);
    calloc.free(formatNamePtr);

    if (formatId != 0) {
      const gMemFlags = 0x0042;
      final hMem = GlobalAlloc(gMemFlags, sizeOf<DWORD>());
      if (hMem != nullptr) {
        final pMem = GlobalLock(hMem);
        pMem.cast<DWORD>().value = value;
        GlobalUnlock(hMem);
        SetClipboardData(formatId, hMem.address);
      }
    }
  }

  void _writeSensitiveToClipboard(String text) {
    if (OpenClipboard(NULL) == FALSE) return;
    try {
      EmptyClipboard();

      _setClipboardDwordFlag('CanIncludeInClipboardHistory', 0);
      _setClipboardDwordFlag('CanUploadToCloudClipboard', 0);
      _setClipboardDwordFlag('Clipboard Viewer Ignore', 0);

      const cfUnicodeText = 13;
      const gmemMoveable = 0x0002;
      final textUnits = text.toNativeUtf16();
      final textBytes = (text.length + 1) * 2;
      final hTextMem = GlobalAlloc(gmemMoveable, textBytes);
      if (hTextMem != nullptr) {
        final pTextMem = GlobalLock(hTextMem);
        pTextMem.cast<Uint8>().asTypedList(textBytes).setAll(
              0,
              textUnits.cast<Uint8>().asTypedList(textBytes),
            );
        GlobalUnlock(hTextMem);
        SetClipboardData(cfUnicodeText, hTextMem.address);
      }
      calloc.free(textUnits);
    } finally {
      CloseClipboard();
    }
  }

  @override
  Future<void> writeSensitiveContent(String content) async {
    _writeSensitiveToClipboard(content);
  }

  @override
  Future<void> pasteSensitiveContent(String content) async {
    _writeSensitiveToClipboard(content);
    await pasteContent();
    await Future<void>.delayed(const Duration(milliseconds: 150));
    if (OpenClipboard(NULL) != FALSE) {
      try {
        EmptyClipboard();
      } finally {
        CloseClipboard();
      }
    }
  }

  @override
  Future<void> openAccessibilityPermissionSetting() async {
    return;
  }
}
