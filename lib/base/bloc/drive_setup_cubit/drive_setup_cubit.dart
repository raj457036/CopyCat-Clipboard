import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clipboard/base/data/services/google_services.dart';
import 'package:clipboard/base/domain/model/drive_access_token/drive_access_token.dart';
import 'package:clipboard/base/domain/repositories/drive_credential.dart';
import 'package:clipboard/common/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:injectable/injectable.dart';

part 'drive_setup_cubit.freezed.dart';
part 'drive_setup_state.dart';

@lazySingleton
class DriveSetupCubit extends Cubit<DriveSetupState> {
  Completer? readyState;
  final DriveService _drive;
  final DriveCredentialRepository repo;

  Timer? timer;

  DriveSetupCubit(
    this.repo,
    @Named("google_drive") this._drive,
  ) : super(const DriveSetupState.unknown());

  void _readyNow() {
    if (readyState != null) {
      if (!readyState!.isCompleted) {
        readyState!.complete();
        readyState = null;
      }
    }
  }

  Future<DriveService?> get drive async {
    await waitIfNotReady();
    _drive.accessToken = await accessToken;
    if (_drive.accessToken == null) return null;
    return _drive;
  }

  Future<void> waitIfNotReady() async {
    switch (state) {
      case DriveSetupDone():
        return;
      case DriveSetupUnknown(waiting: true) ||
            DriveSetupFetching() ||
            DriveSetupRefreshingToken():
        readyState = Completer();
        return readyState!.future;
    }
  }

  Future<void> startResetTimer() async {
    timer = Timer(
      const Duration(seconds: 10),
      () => emit(
        const DriveSetupState.setupError(
          failure: Failure(
            message: "timeout",
            code: "gd-timeout",
          ),
        ),
      ),
    );
  }

  Future<void> stopResetTimer() async {
    timer?.cancel();
    timer = null;
  }

  Future<String?> get accessToken async {
    var token = state.whenOrNull(setupDone: (token) => token);
    if (token == null) {
      return null;
    }

    if (token.isExpired) {
      token = await refreshAccess();
    }
    return token?.accessToken;
  }

  void reset() {
    emit(const DriveSetupState.unknown());
    _readyNow();
  }

  Future<bool> fetch() async {
    try {
      emit(const DriveSetupState.fetching());
      final response = await repo.getDriveCredentials();
      final result = await response.fold(
        (l) async => l,
        (r) async {
          if (r.isExpired) {
            final refreshed = await repo.refreshAccessToken();

            return refreshed.fold(
              (l) => l,
              (r) => r,
            );
          }

          return r;
        },
      );

      if (result is Failure) {
        emit(DriveSetupState.setupError(failure: result));
        return false;
      } else if (result is DriveAccessToken) {
        if (result.isExpired) {
          emit(const DriveSetupState.setupError(failure: driveFailure));
          return false;
        } else {
          emit(DriveSetupState.setupDone(token: result));

          return true;
        }
      } else {
        return false;
      }
    } finally {
      _readyNow();
    }
  }

  Future<void> startSetup({bool force = false}) async {
    emit(const DriveSetupState.unknown());
    final foundAlready = force ? false : await fetch();
    if (foundAlready) return;
    final result = await repo.launchConsentPage();
    emit(result.fold(
      (l) => DriveSetupState.setupError(failure: l),
      (r) {
        startResetTimer();
        return const DriveSetupState.unknown(waiting: true);
      },
    ));
  }

  Future<void> verifyAuthCodeAndSetup(String code, List<String> scopes) async {
    try {
      if (!scopes.contains(DriveApi.driveAppdataScope)) {
        emit(
          const DriveSetupState.setupError(
            failure: Failure(
              message: "Permission not granted!",
              code: "drive-perm-not-granted",
            ),
          ),
        );
        return;
      }

      emit(DriveSetupState.verifyingCode(code: code, scopes: scopes));

      final result = await repo.setupDrive(code);
      stopResetTimer();
      final newState = result.fold(
        (l) => DriveSetupState.setupError(failure: l),
        (r) => DriveSetupState.setupDone(token: r),
      );
      emit(newState);
    } finally {
      _readyNow();
    }
  }

  Future<DriveAccessToken?> refreshAccess() async {
    emit(const DriveSetupState.refreshingToken());
    final result = await repo.refreshAccessToken();
    result.fold(
      (l) {
        emit(DriveSetupState.setupError(failure: l));
        return null;
      },
      (r) {
        emit(DriveSetupState.setupDone(token: r));
        return r;
      },
    );
    _readyNow();
    return null;
  }

  void setupError(String code) async {
    emit(
      DriveSetupState.setupError(
        failure: Failure(code: code, message: "Failed to setup drive."),
      ),
    );
    _readyNow();
  }
}
