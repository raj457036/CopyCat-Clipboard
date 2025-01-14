import 'dart:async';
import 'dart:ui' as ui;

import 'package:animate_do/animate_do.dart';
import 'package:clipboard/utils/applink_listener.dart';
import 'package:clipboard/utils/share_listener.dart';
import 'package:clipboard/widgets/in_background_state.dart';
import 'package:copycat_base/bloc/android_bg_clipboard_cubit/android_bg_clipboard_cubit.dart';
import 'package:copycat_base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:copycat_base/bloc/window_action_cubit/window_action_cubit.dart';
import 'package:copycat_base/common/logging.dart';
import 'package:copycat_base/constants/numbers/breakpoints.dart';
import 'package:copycat_base/utils/debounce.dart';
import 'package:copycat_base/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universal_io/io.dart';

class StateInitializer extends StatefulWidget {
  final Widget child;
  const StateInitializer({
    super.key,
    required this.child,
  });

  @override
  State<StateInitializer> createState() => _StateInitializerState();
}

class _StateInitializerState extends State<StateInitializer>
    with WidgetsBindingObserver {
  final appLinkListener = ApplinkListener();
  final shareListener = ShareListener();
  final powerSaverDebounce = Debouncer(milliseconds: 180000); // 3 minutes
  ui.FlutterView? _view;
  bool renderingDisabled = false;

  Future<void> setupWindow() async {
    final appConfigCubit = context.read<AppConfigCubit>();
    final windowCubit = context.read<WindowActionCubit>();
    await Future.delayed(Durations.extralong4);
    final appConfig = appConfigCubit.state.config;
    windowCubit.setup(appConfig.view, appConfig.windowSize);
  }

  Future<void> syncAndroidBgClipboardStates() async {
    if (!Platform.isAndroid) return;
    final cubit = context.read<AndroidBgClipboardCubit>();
    await Future.delayed(Durations.extralong4);
    cubit.syncStates();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    appLinkListener.init();
    shareListener.init();
    setupWindow();
  }

  void disableRendering(bool disable) {
    if (!isDesktopPlatform) return;
    if (disable) logger.i("CopyCat switching to power saving mode.");
    setState(() => renderingDisabled = disable);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      syncAndroidBgClipboardStates();
      disableRendering(false);
    } else {
      powerSaverDebounce(() => disableRendering(true));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _view = View.maybeOf(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    appLinkListener.dispose();
    shareListener.dispose();
    _view = null;
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final ui.Display? display = _view?.display;
    if (display == null) {
      return;
    }

    if (display.size.width / display.devicePixelRatio < Breakpoints.xs) {
      SystemChrome.setPreferredOrientations(<DeviceOrientation>[
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
      SystemChrome.setPreferredOrientations(<DeviceOrientation>[]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final windowInBackground =
        (InBackgroundState.of(context)?.inBackground ?? false);
    final isPowerSaverActive = windowInBackground && renderingDisabled;

    if (isPowerSaverActive) return const SizedBox.shrink();

    return FadeIn(
      duration: Durations.medium3,
      child: widget.child,
    );
  }
}
