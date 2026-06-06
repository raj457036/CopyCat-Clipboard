import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/data/services/local_auth_service.dart';
import 'package:injectable/injectable.dart';

// MARK: - State

sealed class AppLockState {
  const AppLockState();
}

class AppLockUnlocked extends AppLockState {
  const AppLockUnlocked();
}

class AppLockLocked extends AppLockState {
  const AppLockLocked();
}

class AppLockAuthenticating extends AppLockState {
  const AppLockAuthenticating();
}

// MARK: - Cubit

@lazySingleton
class AppLockCubit extends Cubit<AppLockState> {
  final AppConfigCubit _appConfigCubit;
  final LocalAuthService _localAuthService;

  AppLockCubit(this._appConfigCubit, this._localAuthService)
    : super(const AppLockUnlocked());

  bool get _isEnabled => _appConfigCubit.state.config.enableLocalAuth;

  // Set while authorizeForSensitiveAction is running. Prevents onAppForeground
  // and onAppBackground from reacting to the blur/focus the system auth dialog
  // causes, without emitting any state that would trigger the overlay or the
  // BlocListener that calls windowManager.blur().
  bool _sensitiveAuthInProgress = false;
  bool get isSensitiveAuthInProgress => _sensitiveAuthInProgress;

  // Shared auth logic — emits Unlocked on success, Locked on failure.
  Future<void> _performUnlock() async {
    final timeout = _appConfigCubit.state.config.localAuthTimeoutMinutes;
    final success = await _localAuthService.authorize();
    if (isClosed) return;
    if (success) {
      _localAuthService.onUnlocked(timeoutMinutes: timeout);
      emit(const AppLockUnlocked());
    } else {
      emit(const AppLockLocked());
    }
  }

  /// Called when the app or window comes to the foreground.
  /// Immediately starts authentication if the grace-period has expired.
  void onAppForeground() {
    if (!_isEnabled) return;
    if (_sensitiveAuthInProgress) return;

    _localAuthService.onAppForeground();

    if (_localAuthService.isUnlocked) return;
    if (state is AppLockAuthenticating) return;
    emit(const AppLockAuthenticating());
    unawaited(_performUnlock());
  }

  /// Retry authentication (called from the lock screen retry button).
  Future<void> unlock() async {
    if (state is AppLockAuthenticating) return;
    emit(const AppLockAuthenticating());
    await _performUnlock();
  }

  /// Per-action authorization. Returns [true] immediately if the session is
  /// unlocked or local auth is disabled. Otherwise prompts the user.
  Future<bool> authorize() async {
    if (!_isEnabled) return true;
    if (_localAuthService.isUnlocked) return true;
    return _localAuthService.authorize();
  }

  /// Validates whether a toggle to [enable] should proceed.
  /// For enable=true: returns false if no auth hardware is available.
  /// For enable=false: prompts for authentication; returns false if denied.
  Future<bool> prepareToggle(bool enable) async {
    if (enable) return _localAuthService.isAvailable();
    return authorizeForSensitiveAction(
      reason: 'Authenticate to disable App Lock',
    );
  }

  /// Called when the app or window goes to the background.
  /// For "Immediately" mode: clears the session AND shows the lock screen so
  /// it is already rendered the next time the window becomes visible.
  void onAppBackground() {
    if (!_isEnabled) return;
    if (_sensitiveAuthInProgress) return;

    _localAuthService.onAppBackground();

    if (_appConfigCubit.state.config.localAuthTimeoutMinutes == 0) {
      _localAuthService.lock();
      if (state is AppLockUnlocked) emit(const AppLockLocked());
    }
  }

  /// Immediately locks regardless of the grace-period timer.
  void lockNow() {
    if (!_isEnabled) return;
    _localAuthService.lock();
    emit(const AppLockLocked());
  }

  /// Prompts the user to authenticate for a sensitive in-app action (e.g.
  /// disabling App Lock). Uses a private flag instead of emitting
  /// [AppLockAuthenticating] so the overlay and the BlocListener that calls
  /// windowManager.blur() are not triggered. The flag also prevents
  /// onAppForeground / onAppBackground from reacting to the transient
  /// blur/focus the system dialog causes. On success the session is refreshed
  /// so the returning-focus event in WindowFocusManager doesn't re-auth.
  Future<bool> authorizeForSensitiveAction({String? reason}) async {
    if (_sensitiveAuthInProgress) return false;
    _sensitiveAuthInProgress = true;
    try {
      final success = await _localAuthService.authorize(reason: reason);
      if (success) {
        final timeout = _appConfigCubit.state.config.localAuthTimeoutMinutes;
        _localAuthService.onUnlocked(timeoutMinutes: timeout);
      }
      return success;
    } finally {
      _sensitiveAuthInProgress = false;
    }
  }
}
