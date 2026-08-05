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
    extends State<AndroidClipRestoreLifecycleListener> {
  late final AppLifecycleListener _appLifecycleListner;

  @override
  void initState() {
    super.initState();
    _syncStates();
    _appLifecycleListner = AppLifecycleListener(
      onResume: _syncStates,
      onShow: _syncStates,
    );
  }

  void _syncStates() {
    if (Platform.isAndroid) {
      unawaited(widget.androidBgClipboardCubit.syncStates());
    }
  }

  @override
  void dispose() {
    _appLifecycleListner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
