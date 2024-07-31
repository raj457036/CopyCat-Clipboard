import 'package:clipboard/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/di/di.dart';
import 'package:clipboard/utils/clipboard_actions.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:copycat_base/db/clipboard_item/clipboard_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_window/focus_window.dart';
import 'package:universal_io/io.dart';
import 'package:window_manager/window_manager.dart';

class WindowFocusManager extends StatefulWidget {
  final Widget child;
  final FocusWindow focusWindow;

  const WindowFocusManager({
    super.key,
    required this.focusWindow,
    required this.child,
  });

  static Widget fromPlatform({required Widget child}) {
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
  int? lastWindowId;

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
      await widget.focusWindow.setActiveWindowId(lastWindowId!);
      onWindowBlur();
    }
  }

  Future<void> pasteOnFocusedWindow() async {
    await widget.focusWindow.pasteContent();
  }

  /// returns true when unfocused and false when focused
  Future<bool> toggleWindow() async {
    late final bool focused;
    if (Platform.isLinux) {
      focused = await windowManager.isVisible();
    } else {
      focused = await windowManager.isFocused();
    }
    if (focused) {
      await restore();
      await Future.delayed(Durations.short1);
      await windowManager.hide();
      return true;
    } else {
      await record();
      await windowManager.show();
      await Future.delayed(Durations.short1);
      await windowManager.focus();
      return false;
    }
  }

  Future<void> record() async {
    lastWindowId = await widget.focusWindow.getActiveWindowId();
    appConfigCubit.setLastFocusedWindowId(lastWindowId);
    await Future.delayed(Durations.short2);
  }

  @override
  void onWindowFocus() {
    // Make sure to call once.
    setState(() {});
  }

  @override
  void onWindowBlur() {
    lastWindowId = null;
    appConfigCubit.setLastFocusedWindowId(lastWindowId);
  }

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    appConfigCubit = context.read();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
