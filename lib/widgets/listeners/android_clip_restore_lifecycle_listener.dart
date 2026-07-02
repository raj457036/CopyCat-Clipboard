import 'dart:async';

import 'package:clipboard/base/bloc/android_bg_clipboard_cubit/android_bg_clipboard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';

class AndroidClipRestoreLifecycleListener extends StatefulWidget {
  final AndroidBgClipboardCubit androidBgClipboardCubit;
  final Widget child;

  const AndroidClipRestoreLifecycleListener({
    super.key,
    required this.androidBgClipboardCubit,
    required this.child,
  });

  @override
  State<AndroidClipRestoreLifecycleListener> createState() =>
      _AndroidClipRestoreLifecycleListenerState();
}

class _AndroidClipRestoreLifecycleListenerState
    extends State<AndroidClipRestoreLifecycleListener>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      syncAndroidBgClipboardStates();
    }
  }

  Future<void> syncAndroidBgClipboardStates() async {
    if (!Platform.isAndroid) return;
    unawaited(widget.androidBgClipboardCubit.syncStates());
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
