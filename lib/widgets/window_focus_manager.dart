import 'dart:async';

import 'package:clipboard/di/di.dart';
import 'package:clipboard/utils/clipboard_actions.dart';
import 'package:clipboard/widgets/in_background_state.dart';
import 'package:copycat_base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:copycat_base/common/logging.dart';
import 'package:copycat_base/db/app_config/appconfig.dart';
import 'package:copycat_base/db/clipboard_item/clipboard_item.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:copycat_base/utils/debounce.dart';
import 'package:copycat_base/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_window/focus_window.dart';
import 'package:window_manager/window_manager.dart';

class WindowFocusManager extends StatefulWidget {
  final Widget child;
  final FocusWindow focusWindow;

  const WindowFocusManager({
    super.key,
    required this.focusWindow,
    required this.child,
  });

  static Widget forPlatform({required Widget child}) {
    if (isMobilePlatform) {
      return child;
    }
    return WindowFocusManager(
      focusWindow: sl(),
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
  final debounce = Debouncer(milliseconds: 650);

  late final AppConfigCubit appConfigCubit;

  Future<void> toggleAndPaste(ClipboardItem item) async {
    await copyToClipboard(context, item, noAck: true);
    final unfocused = await toggleWindow();
    await Future.delayed(Durations.short1);
    if (unfocused == true) {
      await pasteOnFocusedWindow();
    }
  }

  Future<void> restore() async {
    if (lastWindowId != null) {
      final windowId = lastWindowId;
      context.windowAction?.hide();
      await widget.focusWindow.setActiveWindowId(windowId!);
    }
    setState(() {
      isWindowInBackground = true;
    });
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
    await Future.delayed(Durations.short2);
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
    // Make sure to call once.
    setState(() {
      isWindowInBackground = false;
    });
    context.windowAction?.isFocused = true;
  }

  Future<void> onResized() async {
    final appConfig = context.read<AppConfigCubit>();
    final size = await windowManager.getSize();
    logger.d("Resized: $size");

    appConfig.changeWindowSize(
      width: size.width,
      height: size.height,
    );
  }

  @override
  void onWindowResize() {
    if (context.windowAction?.isFocused ?? false) {
      debounce(onResized);
    }
  }

  @override
  Future<void> onWindowBlur() async {
    final isDocked = appConfigCubit.state.config.view != AppView.windowed;
    if (!appConfigCubit.isPinned && isDocked) {
      context.windowAction?.hide();
    }
    lastWindowId = null;
    appConfigCubit.setLastFocusedWindowId(lastWindowId);
  }

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    windowManager.setPreventClose(true);
    appConfigCubit = context.read();
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
