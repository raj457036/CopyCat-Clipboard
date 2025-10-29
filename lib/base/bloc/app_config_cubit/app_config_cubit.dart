import 'dart:async';
import 'dart:convert' show jsonEncode;
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:clipboard/base/db/app_config/appconfig.dart';
import 'package:clipboard/base/db/exclusion_rules/exclusion_checker.dart';
import 'package:clipboard/base/db/exclusion_rules/exclusion_rules.dart';
import 'package:clipboard/base/db/subscription/subscription.dart';
import 'package:clipboard/base/domain/repositories/app_config.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:focus_window/focus_window.dart';
import 'package:focus_window/platform/activity_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:injectable/injectable.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:ntp/ntp.dart';
import 'package:universal_io/io.dart';

part 'app_config_cubit.freezed.dart';
part 'app_config_state.dart';

ExclusionChecker? exclusionChecker;
DateTime? currentInternetTime;

@singleton
class AppConfigCubit extends Cubit<AppConfigState> {
  ActivityInfo? lastActivity;
  final AppConfigRepository repo;
  final FocusWindow focusWindow = FocusWindow();

  AppConfigCubit(this.repo)
      : super(
          AppConfigState.loaded(
            isLoading: true,
            config: AppConfig(),
          ),
        );

  @override
  void emit(AppConfigState state) {
    if (isClosed) return;
    super.emit(state);
  }

  void initializeExclusionChecker() {
    if (exclusionRules.enable && isDesktopPlatform) {
      exclusionChecker = ExclusionChecker(exclusionRules);
    } else {
      exclusionChecker = null;
    }
  }

  Future<bool?> syncClocks() async {
    try {
      final timeServers = [
        'time.google.com',
        'pool.ntp.org',
        'time.apple.com',
        'time.windows.com',
        'time.cloudflare.com',
        'time.facebook.com',
      ];
      String timeServer = timeServers[Random()
          .nextInt(timeServers.length)]; // Randomly select a time server

      currentInternetTime ??= await NTP.now(lookUpAddress: timeServer);
      final currentTime = DateTime.now();

      final notInSameMoment =
          currentInternetTime!.difference(currentTime).inSeconds.abs() > 5;
      if (notInSameMoment) {
        emit(
          state.copyWith(
            config: state.config.copyWith(clockUnSynced: true)
              ..applyId(state.config),
          ),
        );
        return false;
      } else {
        emit(
          state.copyWith(
            config: state.config.copyWith(clockUnSynced: false)
              ..applyId(state.config),
          ),
        );
      }
      return true;
    } catch (e) {
      logger.e(e);
      return null;
    }
  }

  Future<void> reset() async {
    final config = AppConfig(
      onBoardComplete: false,
      syncSpeed: SyncSpeed.balanced,
    )..id = 1;
    emit(AppConfigState.loaded(config: config));
    await repo.update(config);
  }

  (AppConfig, bool) applyForSubscription(
    AppConfig config,
    Subscription subscription,
  ) {
    if (subscription.isFree || !subscription.isActive) {
      config = config.copyWith(
        syncSpeed: SyncSpeed.balanced,
        enableDragNDrop: false,
      )..applyId(config);
      return (config, true);
    }
    return (config, false);
  }

  Future<AppConfigState> load([Subscription? subscription]) async {
    emit(state.copyWith(isLoading: true));
    final appConfig = await repo.get();

    final next = await appConfig.fold(
      (l) async {
        final newState = state.copyWith(failure: l, isLoading: false);
        emit(newState);
        return newState;
      },
      (r) async {
        if (subscription != null) {
          final (config, changed) = applyForSubscription(r, subscription);
          if (changed) {
            final newState = state.copyWith(config: config, isLoading: false);
            emit(newState);
            await repo.update(config);
            return newState;
          } else {
            final newState = state.copyWith(config: r, isLoading: false);
            emit(newState);
            return newState;
          }
        } else {
          final newState = state.copyWith(config: r, isLoading: false);
          emit(newState);
          return newState;
        }
      },
    );
    initializeExclusionChecker();
    return next;
  }

  bool get isCopyingPaused =>
      state.config.pausedTill != null &&
      state.config.pausedTill!.isAfter(now());

  bool canUploadFile(int size) => state.config.dontUploadOver >= size;

  bool canCopyFile(int size) => state.config.dontCopyOver >= size;

  bool get isSyncEnabled =>
      !state.config.clockUnSynced && state.config.enableSync;

  bool get isEncryptionEnabled => state.config.autoEncrypt;
  bool get isE2EESetupDone => state.config.enc2 != null;

  bool get isPinned => state.config.pinned;

  bool get isFileSyncEnabled =>
      state.config.enableSync && state.config.enableFileSync;

  bool get duplicatePrevention => state.config.duplicatePrevention;

  ExclusionRules get exclusionRules => state.config.copyExclusionRules;

  Future<void> changePausedTill(DateTime? pausedTill) async {
    final newConfig = state.config.copyWith(pausedTill: pausedTill)
      ..applyId(state.config);
    emit(AppConfigState.loaded(config: newConfig));
    await repo.update(newConfig);
  }

  Future<void> changeAppLayout(AppLayout layout) async {
    final newConfig = state.config.copyWith(layout: layout)
      ..applyId(state.config);
    emit(AppConfigState.loaded(config: newConfig));
    await repo.update(newConfig);
  }

  Future<void> changeAppView(AppView view) async {
    final newConfig = state.config.copyWith(view: view)..applyId(state.config);
    emit(AppConfigState.loaded(config: newConfig));
    await repo.update(newConfig);
  }

  Future<void> togglePinned() async {
    final newConfig = state.config.copyWith(pinned: !state.config.pinned)
      ..applyId(state.config);
    emit(AppConfigState.loaded(config: newConfig));
    await repo.update(newConfig);
  }

  Future<void> changeWindowSize({double? width, double? height}) async {
    final config = state.config;
    final newConfig = config.copyWith(
      windowWidth: width ?? config.windowWidth,
      windowHeight: height ?? config.windowHeight,
    )..applyId(config);
    emit(AppConfigState.loaded(config: newConfig));
    await repo.update(newConfig);
  }

  Future<void> setClipboardToggleHotkey(HotKey? key) async {
    final newConfig = state.config
        .copyWith(toggleHotkey: key != null ? jsonEncode(key.toJson()) : null)
      ..applyId(state.config);
    emit(state.copyWith(config: newConfig));
    await repo.update(newConfig);
  }

  Future<void> setE2EEKey(String? key) async {
    final newConfig = state.config.copyWith(enc2: key)..applyId(state.config);
    emit(state.copyWith(config: newConfig));
    await repo.update(newConfig);
  }

  Future<void> setThemeColor(Color color) async {
    final newConfig = state.config.copyWith(themeColor: color.toARGB32())
      ..applyId(state.config);
    emit(state.copyWith(config: newConfig));
    await repo.update(newConfig);
  }

  Future<void> setThemeColorVariant(DynamicSchemeVariant? variant) async {
    if (variant == null) return;
    final newConfig = state.config.copyWith(themeVariant: variant)
      ..applyId(state.config);
    emit(state.copyWith(config: newConfig));
    await repo.update(newConfig);
  }

  Future<void> changeSyncMode(SyncSpeed? speed) async {
    if (speed == null) return;
    final newConfig = state.config.copyWith(syncSpeed: speed)
      ..applyId(state.config);
    emit(state.copyWith(config: newConfig));
    await repo.update(newConfig);
  }

  Future<void> changeDontCopyOver(int? size) async {
    if (size == null) return;
    final newConfig = state.config.copyWith(dontCopyOver: size)
      ..applyId(state.config);
    emit(state.copyWith(config: newConfig));
    await repo.update(newConfig);
  }

  Future<void> changeDontUploadOver(int? size) async {
    if (size == null) return;
    final newConfig = state.config.copyWith(dontUploadOver: size)
      ..applyId(state.config);
    emit(state.copyWith(config: newConfig));
    await repo.update(newConfig);
  }

  Future<void> changeLocale(String locale) async {
    final newConfig = state.config.copyWith(locale: locale)
      ..applyId(state.config);
    emit(state.copyWith(config: newConfig));
    await repo.update(newConfig);
  }

  Future<void> changeThemeMode(ThemeMode? mode) async {
    if (mode == null) return;
    final newConfig = state.config.copyWith(themeMode: mode)
      ..applyId(state.config);
    emit(state.copyWith(config: newConfig));
    await repo.update(newConfig);
  }

  Future<void> changeSync(bool value) async {
    final newConfig = state.config.copyWith(enableSync: value)
      ..applyId(state.config);
    emit(state.copyWith(config: newConfig));
    await repo.update(newConfig);
  }

  Future<void> togglePreventDuplication(bool value) async {
    final newConfig = state.config.copyWith(duplicatePrevention: value)
      ..applyId(state.config);
    emit(state.copyWith(config: newConfig));
    await repo.update(newConfig);
  }

  Future<void> toggleSmartPaste(bool value) async {
    final newConfig = state.config.copyWith(smartPaste: value)
      ..applyId(state.config);
    emit(state.copyWith(config: newConfig));
    await repo.update(newConfig);
  }

  Future<void> toggleDragNDrop(bool value) async {
    final newConfig = state.config.copyWith(enableDragNDrop: value)
      ..applyId(state.config);
    emit(state.copyWith(config: newConfig));
    await repo.update(newConfig);
  }

  Future<void> toggleAndroidBgListener(bool value) async {
    final newConfig = state.config.copyWith(androidBgListener: value)
      ..applyId(state.config);
    emit(state.copyWith(config: newConfig));
    await repo.update(newConfig);
  }

  Future<void> toggleAutoEncrypt(bool value) async {
    final newConfig = state.config.copyWith(autoEncrypt: value)
      ..applyId(state.config);
    emit(state.copyWith(config: newConfig));
    await repo.update(newConfig);
  }

  Future<void> changeOnBoardStatus(bool value) async {
    final newConfig = state.config.copyWith(onBoardComplete: value)
      ..applyId(state.config);
    emit(state.copyWith(config: newConfig));
    await repo.update(newConfig);
  }

  Future<void> changeFileSync(bool value) async {
    final newConfig = state.config.copyWith(enableFileSync: value)
      ..applyId(state.config);
    emit(state.copyWith(config: newConfig));
    await repo.update(newConfig);
  }

  Future<void> setLaunchAtStartup(bool value) async {
    bool launchAtStartup_ = false;
    try {
      if (value) {
        await launchAtStartup.enable();
        launchAtStartup_ = true;
      } else {
        await launchAtStartup.disable();
        launchAtStartup_ = false;
      }
    } catch (e) {
      logger.e(e);
    }
    final newConfig = state.config.copyWith(launchAtStartup: launchAtStartup_)
      ..applyId(state.config);
    emit(state.copyWith(config: newConfig));
    await repo.update(newConfig);
  }

  // ? Non persistent states
  void setLastFocusedWindowId(int? value) {
    final newConfig = state.config.copyWith(lastFocusedWindowId: value)
      ..applyId(state.config);
    emit(state.copyWith(config: newConfig));
  }

  Future<void> updateExclusionRule(ExclusionRules exclusionRule) async {
    final newConfig = state.config.copyWith(exclusionRules: exclusionRule)
      ..applyId(state.config);
    emit(state.copyWith(config: newConfig));
    await repo.update(newConfig);
    initializeExclusionChecker();
  }

  Future<bool> isCopyingAllowedByActivity() async {
    if (isMobilePlatform) return true;
    try {
      final activity =
          await focusWindow.getActivity().timeout(const Duration(seconds: 5));
      logger.w(activity);
      lastActivity = activity;
      final allowed = exclusionChecker?.isActivityAllowed(activity) ?? true;
      return allowed;
    } on TimeoutException {
      lastActivity = null;
      return true;
    } catch (e) {
      lastActivity = null;
      return true;
    }
  }

  Future<bool> confirmAccessibilityPermission() async {
    if (Platform.isAndroid) return true;
    final granted = await focusWindow.isAccessibilityPermissionGranted();
    if (!granted) {
      await focusWindow.openAccessibilityPermissionSetting();
      return false;
    }
    return true;
  }
}
