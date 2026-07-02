import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clipboard/base/data/services/file_cloud_services/google_drive/google_services.dart';
import 'package:clipboard/base/domain/model/drive_access_token/drive_access_token.dart';
import 'package:clipboard/base/domain/repositories/drive_credential.dart';
import 'package:clipboard/common/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:injectable/injectable.dart';

part 'drive_setup_cubit.freezed.dart';
part 'drive_setup_state.dart';

@Injectable(cache: true)
class DriveSetupCubit extends Cubit<DriveSetupState> {
  Completer? readyState;
  final DriveService _drive;
  final DriveCredentialRepository repo;

  Timer? _refreshTimer;
  DriveSetupState _lastStableState = const DriveSetupState.setupError(
    failure: driveFailure,
  );
  bool _ignoreNextAuthCallback = false;

  DriveSetupCubit(this.repo, @Named("google_drive") this._drive)
    : super(const DriveSetupState.unknown());

  void _applyToken(DriveAccessToken token) {
    _drive.accessToken = token.accessToken;
    final nextState = DriveSetupState.setupDone(token: token);
    _lastStableState = nextState;
    _ignoreNextAuthCallback = false;
    emit(nextState);
    _doRestoreIn(token.expiresIn);
  }

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

  Future<void> _doRestoreIn(int seconds) async {
    _refreshTimer?.cancel();
    seconds = seconds - 300; // Refresh 5 minutes before expiry
    if (seconds <= 0) {
      refreshAccess();
      return;
    }
    _refreshTimer = Timer(Duration(seconds: seconds), refreshAccess);
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

  Future<bool> fetch() async {
    try {
      emit(const DriveSetupState.fetching());
      final response = await repo.getDriveCredentials();
      final result = await response.fold((l) async => l, (r) async {
        if (r.isExpired) {
          final refreshed = await repo.refreshAccessToken();

          return refreshed.fold((l) => l, (r) => r);
        }

        return r;
      });

      if (result is Failure) {
        emit(DriveSetupState.setupError(failure: result));
        return false;
      } else if (result is DriveAccessToken) {
        if (result.isExpired) {
          emit(const DriveSetupState.setupError(failure: driveFailure));
          return false;
        } else {
          _applyToken(result);
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
    switch (state) {
      case DriveSetupDone() || DriveSetupError():
        _lastStableState = state;
      default:
    }
    _ignoreNextAuthCallback = false;

    emit(const DriveSetupState.unknown());
    final foundAlready = force ? false : await fetch();
    if (foundAlready) return;
    final result = await repo.launchConsentPage();
    emit(
      result.fold((l) => DriveSetupState.setupError(failure: l), (r) {
        return const DriveSetupState.unknown(waiting: true);
      }),
    );
  }

  void cancelPendingSetup() {
    if (state case DriveSetupUnknown(waiting: true)) {
      _ignoreNextAuthCallback = true;
      emit(_lastStableState);
      _readyNow();
    }
  }

  Future<void> verifyAuthCodeAndSetup(String code, List<String> scopes) async {
    try {
      if (_ignoreNextAuthCallback && state is! DriveSetupUnknown) {
        _ignoreNextAuthCallback = false;
        return;
      }

      if (!scopes.contains(DriveApi.driveAppdataScope)) {
        const failure = Failure(
          message: "Permission not granted!",
          code: "drive-perm-not-granted",
        );
        _lastStableState = const DriveSetupState.setupError(failure: failure);
        emit(_lastStableState);
        return;
      }

      emit(DriveSetupState.verifyingCode(code: code, scopes: scopes));

      final result = await repo.setupDrive(code);
      result.fold((l) {
        _lastStableState = DriveSetupState.setupError(failure: l);
        emit(_lastStableState);
      }, _applyToken);
    } finally {
      _readyNow();
    }
  }

  Future<DriveAccessToken?> refreshAccess() async {
    if (isClosed) return null;
    emit(const DriveSetupState.refreshingToken());
    final result = await repo.refreshAccessToken();
    final token = result.fold<DriveAccessToken?>(
      (l) {
        _lastStableState = DriveSetupState.setupError(failure: l);
        emit(_lastStableState);
        return null;
      },
      (r) {
        _applyToken(r);
        return r;
      },
    );
    _readyNow();
    return token;
  }

  void setupError(String code) async {
    _lastStableState = DriveSetupState.setupError(
      failure: Failure(code: code, message: "Failed to setup drive."),
    );
    emit(_lastStableState);
    _readyNow();
  }

  @override
  Future<void> close() {
    _refreshTimer?.cancel();
    return super.close();
  }
}
