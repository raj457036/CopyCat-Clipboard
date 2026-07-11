import 'dart:async';

import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/app_lock_cubit/app_lock_cubit.dart';
import 'package:clipboard/base/bloc/review_prompt_cubit/review_prompt_cubit.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/data/services/clipboard_service.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/di/di.dart';
import 'package:clipboard/utils/clipboard_actions.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/debounce.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/in_background_state.dart';
import 'package:clipboard/widgets/multi_paste/multi_paste_transformer.dart';
import 'package:flutter/material.dart';
import 'package:focus_window/focus_window.dart';
import 'package:window_manager/window_manager.dart';
import 'package:synchronized/extension.dart';

class WindowFocusManager extends StatefulWidget {
  final Widget child;
  final FocusWindow focusWindow;
  final ClipboardService clipboardService;

  const WindowFocusManager({
    super.key,
    required this.focusWindow,
    required this.child,
    required this.clipboardService,
  });

  static Widget forPlatform({required Widget child}) {
    if (isMobilePlatform) {
      return child;
    }
    return WindowFocusManager(
      focusWindow: sl(),
      clipboardService: sl(),
      child: child,
    );
  }

  static WindowFocusManagerState? of(BuildContext context) {
    return context.findAncestorStateOfType<WindowFocusManagerState>();
  }

  @override
  State<WindowFocusManager> createState() => WindowFocusManagerState();
}

class WindowFocusManagerState extends State<WindowFocusManager>
    with WindowListener {
  bool isWindowInBackground = false;

  int? lastWindowId;
  StreamSubscription? subscription;
  final debounce = Debouncer(milliseconds: 100);

  late final AppConfigCubit appConfigCubit;
  late final AppLockCubit appLockCubit;
  late final ReviewPromptCubit reviewPromptCubit;

  void _setWindowInBackground(bool value) {
    if (isWindowInBackground == value) return;
    setState(() {
      isWindowInBackground = value;
    });
  }

  Future<void> toggleAndPaste(ClipboardItem item) async {
    final unfocused = await toggleWindow();
    await wait(Durations.short1.inMilliseconds);
    if (unfocused == true) {
      await pasteOnFocusedWindow();
    }
  }

  Future<void> pasteMultiple(
    List<ClipboardItem> items, {
    bool restoreFocusAfterPaste = false,
    String? textMergeSeparator,
    Duration? waitBetweenPastes,
  }) async {
    if (items.isEmpty) return;

    final pasteable = items
        .where((item) => item.inCache && !item.encrypted)
        .toList(growable: false);

    if (pasteable.isEmpty) return;

    final transformed = MultiPasteTransformer.mergeConsecutiveTextClips(
      pasteable,
      separator: textMergeSeparator,
    );
    if (transformed.isEmpty) return;

    final waitDuration = waitBetweenPastes ?? Durations.short1;

    final unfocused = await toggleWindow();
    await wait(Durations.short1.inMilliseconds);
    if (unfocused != true) return;

    await widget.clipboardService.runWithCaptureSuppressed(() async {
      for (int i = 0; i < transformed.length; i++) {
        final item = transformed[i];
        if (!mounted) break;
        await synchronized(() async {
          await copyToClipboard(context, item, noAck: true);
          await wait(Durations.short1.inMilliseconds);
          await pasteOnFocusedWindow();
          if (i < transformed.length - 1 && waitDuration > Duration.zero) {
            await wait(waitDuration.inMilliseconds);
          }
        });
      }
    });

    if (restoreFocusAfterPaste) {
      await toggleWindow();
    }
  }

  Future<void> restore() async {
    if (lastWindowId != null) {
      final windowId = lastWindowId;
      context.windowAction?.hide();
      await widget.focusWindow.setActiveWindowId(windowId!);
    }
    _setWindowInBackground(true);
  }

  Future<void> pasteOnFocusedWindow() async {
    await widget.focusWindow.pasteContent();
  }

  /// returns true when unfocused and false when focused
  Future<bool> toggleWindow() async {
    final windowAction = context.windowAction;
    final bool focused = windowAction?.isFocused ?? false;

    // if (Platform.isLinux) {
    //   focused = await windowManager.isVisible();
    // } else {
    //   focused = await windowManager.isFocused();
    // }
    if (focused) {
      await windowAction?.hide();
      await restore();
      return true;
    } else {
      await record();
      await windowAction?.show();
      return false;
    }
  }

  Future<void> record() async {
    lastWindowId = await widget.focusWindow.getActiveWindowId();
    appConfigCubit.setLastFocusedWindowId(lastWindowId);
    await wait(Durations.short2.inMilliseconds);
  }

  @override
  Future<void> onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose && mounted) {
      context.windowAction?.hide();
    }
  }

  @override
  void onWindowFocus() {
    _setWindowInBackground(false);
    context.windowAction?.isFocused = true;
    appLockCubit.onAppForeground();
    _maybeTrackWindowForeground();
  }

  Future<void> _maybeTrackWindowForeground() async {
    try {
      await reviewPromptCubit.trackAppEntry();
    } catch (e) {
      logger.e(() => "Error tracking app entry for review prompt. $e");
    }
  }

  Future<void> onResized() async {
    if (context.location == RouteConstants.pasteStack) return;

    final appConfig = sl<AppConfigCubit>();
    final size = await windowManager.getSize();
    logger.i(() => "Window Resized: $size");

    appConfig.changeWindowSize(width: size.width, height: size.height);
  }

  @override
  void onWindowResize() {
    if (context.windowAction?.isFocused ?? false) {
      debounce(onResized);
    }
  }

  @override
  Future<void> onWindowBlur() async {
    _setWindowInBackground(true);
    final authInProgress =
        appLockCubit.state is AppLockAuthenticating ||
        appLockCubit.isSensitiveAuthInProgress;

    if (!authInProgress) appLockCubit.onAppBackground();

    final appConfig = sl<AppConfigCubit>();

    if (!appConfig.isPinned) {
      if (context.location == RouteConstants.pasteStack) return;
      if (authInProgress) return;
      context.windowAction?.hide();
    }
  }

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    windowManager.setPreventClose(true);
    appConfigCubit = sl<AppConfigCubit>();
    appLockCubit = sl<AppLockCubit>();
    reviewPromptCubit = sl<ReviewPromptCubit>();
  }

  @override
  void dispose() {
    subscription?.cancel();
    widget.focusWindow.stopObserver();
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InBackgroundState(
      inBackground: isWindowInBackground,
      child: widget.child,
    );
  }
}
