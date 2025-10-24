import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/domain/model/auth_user/auth_user.dart';
import 'package:clipboard/base/domain/repositories/analytics.dart';
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
  final AnalyticsRepository analyticsRepo;

  AuthCubit(
    this.repo,
    this.localCache,
    this.analyticsRepo,
  ) : super(const AuthState.unknown());

  /// validate the code and return a suitable page path
  Future<(String?, Failure?)> validateAuthCode(String code) async {
    final result = await repo.validateAuthCode(code);

    return result.fold(
      (failure) => (null, failure),
      (right) {
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
      },
    );
  }

  bool get isLocalAuth => state is LocalAuthenticatedAuthState;
  String? get userId => repo.userId;

  Future<bool> checkForAuthentication() async {
    if (checkLocalSignin()) return true;
    if (repo.currentUser != null) {
      await authenticated(repo.currentUser!, repo.accessToken!);
    } else {
      unauthenticated(authFailure);
    }
    return state is AuthenticatedAuthState;
  }

  Future<void> removeEncryptionSetup() async {
    await state.mapOrNull(authenticated: (authState) async {
      final result = await repo.updateUserInfo({
        "enc1": null,
        "enc2KeyId": null,
      });
      result.fold((l) {}, (user) {
        emit(authState.copyWith(user: user));
      });
    });
  }

  /// enc1 is always encrypted with enc2 key.
  Future<void> setupEncryption(String enc2KeyId, String enc1) async {
    await state.mapOrNull(authenticated: (authState) async {
      final result = await repo.updateUserInfo({
        "enc1": enc1,
        "enc2KeyId": enc2KeyId,
      });
      result.fold((l) {}, (user) {
        emit(authState.copyWith(user: user));
      });
    });
  }

  bool checkLocalSignin() {
    final result = localCache.get(klocalAuthKey);
    if (result == true) {
      emit(const AuthState.localAuthenticated());
      return true;
    }
    return false;
  }

  Future<void> localAuthenticated() async {
    localCache.set(klocalAuthKey, true);

    emit(const AuthState.localAuthenticated());
  }

  Future<void> authenticated(AuthUser user, String accessToken) async {
    analyticsRepo.setAnalyticUser(user);

    emit(AuthState.authenticated(
      user: user,
      accessToken: accessToken,
    ));
  }

  void unauthenticated(Failure failure) {
    emit(AuthState.unauthenticated(failure));
  }

  Future<void> logout() async {
    emit(const AuthState.authenticating());
    localCache.set(klocalAuthKey, false);
    await repo.logout();
    emit(const AuthState.unauthenticated());
  }
}
