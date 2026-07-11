import 'dart:async';
import 'dart:ui' as ui;

import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/app_lock_cubit/app_lock_cubit.dart';
import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/bloc/clipboard_cubit/clipboard_cubit.dart';
import 'package:clipboard/base/bloc/monetization_cubit/monetization_cubit.dart';
import 'package:clipboard/base/bloc/offline_persistance_cubit/offline_persistance_cubit.dart';
import 'package:clipboard/base/bloc/review_prompt_cubit/review_prompt_cubit.dart';
import 'package:clipboard/base/bloc/sync_status_cubit/sync_status_cubit.dart';
import 'package:clipboard/base/bloc/window_action_cubit/window_action_cubit.dart';
import 'package:clipboard/base/constants/numbers/values.dart';
import 'package:clipboard/base/constants/numbers/breakpoints.dart';
import 'package:clipboard/base/sync/sync_orchestrator.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/di/di.dart';
import 'package:clipboard/utils/applink_listener.dart';
import 'package:clipboard/utils/debounce.dart';
import 'package:clipboard/utils/share_listener.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/custom_thumbnailer_generations.dart';
import 'package:clipboard/widgets/dialogs/in_app_review_dialog.dart';
import 'package:clipboard/widgets/in_background_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thumbnailer/thumbnailer.dart';

class StateInitializer extends StatefulWidget {
  final Widget child;
  const StateInitializer({super.key, required this.child});

  @override
  State<StateInitializer> createState() => _StateInitializerState();
}

class _StateInitializerState extends State<StateInitializer>
    with WidgetsBindingObserver {
  final appLinkListener = ApplinkListener();
  final shareListener = ShareListener();
  final powerSaverDebounce = Debouncer(milliseconds: 180000); // 3 minutes
  final backgroundStateDebounce = Debouncer(milliseconds: 60000); // 1 minute

  late final AppConfigCubit appConfigCubit;
  late final AuthCubit authCubit;
  late final AppLockCubit appLockCubit;
  late final MonetizationCubit monetizationCubit;
  late final SyncStatusCubit syncStatusCubit;
  late final SyncOrchestrator syncOrchestrator;
  late final ReviewPromptCubit reviewPromptCubit;
  ui.FlutterView? _view;
  bool renderingDisabled = false;
  bool _isAppLifecycleBackgrounded = false;
  bool _isWindowBackgrounded = false;
  bool? _lastClipboardBackgroundState;
  bool _resumeSyncInProgress = false;

  // We consider the app backgrounded if either Flutter lifecycle is paused/
  // inactive OR the desktop window manager reports the window in background
  // while the app is not pinned.
  bool get _isEffectivelyBackgrounded =>
      !appConfigCubit.state.config.pinned &&
      (_isAppLifecycleBackgrounded || _isWindowBackgrounded);

  Future<void> setupWindow() async {
    final windowCubit = context.read<WindowActionCubit?>();
    await wait(Durations.extralong4.inMilliseconds);
    final appConfig = appConfigCubit.state.config;
    windowCubit?.setup(appConfig.view, appConfig.windowSize);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    appConfigCubit = context.read<AppConfigCubit>();
    authCubit = context.read<AuthCubit>();
    appLockCubit = context.read<AppLockCubit>();
    monetizationCubit = context.read<MonetizationCubit>();
    syncStatusCubit = context.read<SyncStatusCubit>();
    syncOrchestrator = sl<SyncOrchestrator>();
    reviewPromptCubit = context.read<ReviewPromptCubit>();
    appLinkListener.init();
    shareListener.init();
    setupWindow();
    if (isMobilePlatform) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _trackMobileAppLaunch(),
      );
    }

    Thumbnailer.addCustomGenerationStrategies(customGenerationStrategies);
  }

  Future<void> _trackMobileAppLaunch() async {
    if (!mounted) return;
    try {
      await reviewPromptCubit.trackAppEntry();
    } catch (e) {
      logger.e("Error tracking app launch for review prompt. $e");
    }
  }

  void disableRendering(bool disable) {
    if (!isDesktopPlatform) return;
    if (disable) logger.i("CopyCat switching to power saving mode.");
    setState(() => renderingDisabled = disable);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed || AppLifecycleState.inactive:
        disableRendering(false);
        _isAppLifecycleBackgrounded = false;
        if (state == AppLifecycleState.resumed) {
          appLockCubit.onAppForeground();
          unawaited(_runResumeSyncCatchUp());
        }
      case _:
        powerSaverDebounce(() => disableRendering(true));
        _isAppLifecycleBackgrounded = true;
        appLockCubit.onAppBackground();
    }
    _syncClipboardBackgroundState();
  }

  bool _isSyncEligibleAuthState() {
    final authState = authCubit.state;
    return switch (authState) {
      AuthenticatedAuthState(:final isOnboardingCompleted) =>
        isOnboardingCompleted,
      LocalAuthenticatedAuthState() =>
        appConfigCubit.state.config.onBoardComplete,
      _ => false,
    };
  }

  Future<void> _runResumeSyncCatchUp() async {
    if (!mounted || _resumeSyncInProgress) return;
    if (isDesktopPlatform) return;
    if (!appConfigCubit.isSyncEnabled || !_isSyncEligibleAuthState()) return;

    final intervalSeconds =
        monetizationCubit.active?.syncInterval ?? defaultBestEffortSyncInterval;

    _resumeSyncInProgress = true;
    final wasRunning = syncOrchestrator.isRunning;
    final syncSpeed = appConfigCubit.state.config.syncSpeed;

    try {
      if (wasRunning) {
        syncOrchestrator.stop();
      }

      await syncStatusCubit.syncAll(const SyncAllParams(force: true));
    } catch (e) {
      logger.e("Resume catch-up sync failed: $e");
    } finally {
      if (wasRunning &&
          appConfigCubit.isSyncEnabled &&
          _isSyncEligibleAuthState()) {
        syncOrchestrator.start(
          syncSpeed: syncSpeed,
          intervalSeconds: intervalSeconds,
        );
      }
      _resumeSyncInProgress = false;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _view = View.maybeOf(context);
    final inBackground = InBackgroundState.of(context)?.inBackground ?? false;
    if (_isWindowBackgrounded != inBackground) {
      _isWindowBackgrounded = inBackground;
      _syncClipboardBackgroundState();
    }
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
    _view ??= View.maybeOf(context);

    ui.Display? display;
    try {
      display = _view?.display;
    } on AssertionError {
      // Can happen briefly during desktop window hide/show transitions.
      return;
    }

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
    final isPowerSaverActive = _isEffectivelyBackgrounded && renderingDisabled;

    if (isPowerSaverActive) return const SizedBox.shrink();

    return BlocListener<ReviewPromptCubit, int>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) async {
        await showInAppReviewDialog(cubit: context.read<ReviewPromptCubit>());
      },
      child: widget.child,
    );
  }

  void _syncClipboardBackgroundState() {
    if (!mounted) return;

    final isBackgrounded = _isEffectivelyBackgrounded;

    if (_lastClipboardBackgroundState == isBackgrounded) return;
    _lastClipboardBackgroundState = isBackgrounded;

    if (isBackgrounded) {
      FocusManager.instance.primaryFocus?.unfocus();
    }

    if (isBackgrounded) {
      backgroundStateDebounce(
        () => context.read<ClipboardCubit?>()?.setBackgrounded(isBackgrounded),
      );
      context.read<OfflinePersistenceCubit?>()?.clearTransientState();
    } else {
      backgroundStateDebounce.cancel();
      context.read<ClipboardCubit?>()?.setBackgrounded(false);
    }
  }
}
