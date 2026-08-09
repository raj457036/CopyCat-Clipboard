import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/domain/model/auth_user/auth_user.dart';
import 'package:clipboard/base/domain/repositories/auth.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/logging.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:tiny_storage/tiny_storage.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

@singleton
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repo;
  final TinyStorage localCache;
  final AppConfigCubit appConfigCubit;
  StreamSubscription<void>? _authStateChangesSubscription;
  bool _isAuthCheckInProgress = false;
  bool _isRefreshInProgress = false;

  AuthCubit(this.repo, this.localCache, this.appConfigCubit)
    : super(const AuthState.unknown()) {
    _listenToAuthStateChanges();
  }

  /// validate the code and return a suitable page path
  Future<(String?, Failure?)> validateAuthCode(String code) async {
    final result = await repo.validateAuthCode(code);

    return result.fold((failure) => (null, failure), (right) {
      final (type, user) = right;
      if (user == null) return (null, null);
      switch (type) {
        case "passwordRecovery":
          authenticated(user, repo.accessToken!);
          return (RouteConstants.resetPassword, null);
        case _:
          logger.w("Exchange not supported. $type");
      }
      return (null, null);
    });
  }

  bool get isLocalAuth => state is LocalAuthenticatedAuthState;
  String? get userId => repo.userId;

  Future<bool> checkForAuthentication() async {
    emit(const AuthState.authenticating());

    if (_isAuthCheckInProgress) {
      return state is AuthenticatedAuthState ||
          state is LocalAuthenticatedAuthState;
    }

    _isAuthCheckInProgress = true;

    try {
      if (checkLocalSignin()) return true;

      final currentUser = repo.currentUser;
      final accessToken = repo.accessToken;
      if (currentUser != null && accessToken != null) {
        await authenticated(currentUser, accessToken);

        if (repo.needsSessionRefresh) {
          unawaited(_refreshSessionInBackground());
        }
        return true;
      }

      final hasCachedSession = currentUser != null || accessToken != null;
      if (hasCachedSession) {
        unawaited(_refreshSessionInBackground());
        return false;
      }

      unauthenticated(authFailure);
      return false;
    } finally {
      _isAuthCheckInProgress = false;
    }
  }

  Future<void> removeEncryptionSetup() async {
    await state.mapOrNull(
      authenticated: (authState) async {
        final result = await repo.updateUserInfo({
          "enc1": null,
          "enc2KeyId": null,
        });
        result.fold((l) {}, (user) {
          emit(authState.copyWith(user: user));
        });
      },
    );
  }

  /// enc1 is always encrypted with enc2 key.
  Future<void> setupEncryption(String enc2KeyId, String enc1) async {
    await state.mapOrNull(
      authenticated: (authState) async {
        final result = await repo.updateUserInfo({
          "enc1": enc1,
          "enc2KeyId": enc2KeyId,
        });
        result.fold((l) {}, (user) {
          emit(authState.copyWith(user: user));
        });
      },
    );
  }

  bool checkLocalSignin() {
    final result = localCache.get(klocalAuthKey);
    if (result == true) {
      if (state is! LocalAuthenticatedAuthState) {
        emit(const AuthState.localAuthenticated());
      }
      return true;
    }
    return false;
  }

  Future<void> localAuthenticated() async {
    localCache.set(klocalAuthKey, true);

    emit(const AuthState.localAuthenticated());
  }

  Future<void> authenticated(AuthUser user, String accessToken) async {
    if (!appConfigCubit.loaded.isCompleted) {
      await appConfigCubit.loaded.future;
    }

    final isOnboardingCompleted = appConfigCubit.state.config.onBoardComplete;
    final isEncryptionKeySetup = appConfigCubit.isE2EESetupDone;
    emit(
      AuthState.authenticated(
        user: user,
        accessToken: accessToken,
        isOnboardingCompleted: isOnboardingCompleted,
        isEncryptionKeySetup: isEncryptionKeySetup,
      ),
    );
  }

  Future<void> setOnboardingCompleted() async {
    final currentState = state;
    if (currentState is AuthenticatedAuthState) {
      emit(currentState.copyWith(isOnboardingCompleted: true));
    }
  }

  Future<void> encryptionKeySetupCompleted() async {
    final currentState = state;
    if (currentState is AuthenticatedAuthState) {
      emit(currentState.copyWith(isEncryptionKeySetup: true));
    }
  }

  void unauthenticated(Failure failure) {
    emit(AuthState.unauthenticated(failure));
  }

  Future<void> _refreshSessionInBackground() async {
    if (_isRefreshInProgress) return;
    _isRefreshInProgress = true;

    try {
      final result = await repo.refreshSession().timeout(
        const Duration(seconds: 8),
      );

      await result.fold(
        (failure) async {
          logger.w("Session refresh failed: ${failure.message}");

          final hasSession =
              repo.currentUser != null && repo.accessToken != null;
          if (!hasSession &&
              state is! AuthenticatedAuthState &&
              state is! LocalAuthenticatedAuthState) {
            unauthenticated(failure);
          }
        },
        (_) async {
          final refreshedUser = repo.currentUser;
          final refreshedToken = repo.accessToken;

          if (refreshedUser != null && refreshedToken != null) {
            await authenticated(refreshedUser, refreshedToken);
            return;
          }

          if (state is! LocalAuthenticatedAuthState) {
            unauthenticated(authFailure);
          }
        },
      );
    } on TimeoutException {
      logger.w("Session refresh timed out while bootstrapping auth state.");
    } catch (e) {
      logger.w("Session refresh threw while bootstrapping auth state. $e");
    } finally {
      _isRefreshInProgress = false;
    }
  }

  void _listenToAuthStateChanges() {
    _authStateChangesSubscription = repo.authStateChanges.listen(
      (_) {
        unawaited(_reconcileAuthStateFromRepository());
      },
      onError: (error) {
        logger.w("Auth state stream error: $error");
      },
    );
  }

  Future<void> _reconcileAuthStateFromRepository() async {
    if (checkLocalSignin()) return;

    final currentUser = repo.currentUser;
    final accessToken = repo.accessToken;

    if (currentUser != null && accessToken != null) {
      final currentState = state;
      if (currentState is AuthenticatedAuthState &&
          currentState.user.userId == currentUser.userId) {
        return;
      }

      await authenticated(currentUser, accessToken);
      return;
    }

    if (state is! UnauthenticatedAuthState) {
      unauthenticated(authFailure);
    }
  }

  Future<void> logout() async {
    emit(const AuthState.authenticating());
    localCache.set(klocalAuthKey, false);
    await repo.logout();
    emit(const AuthState.unauthenticated());
  }

  @override
  Future<void> close() async {
    await _authStateChangesSubscription?.cancel();
    return super.close();
  }
}
