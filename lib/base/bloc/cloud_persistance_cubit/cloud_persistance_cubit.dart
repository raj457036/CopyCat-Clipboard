import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/bloc/drive_setup_cubit/drive_setup_cubit.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/repositories/clipboard.dart';
import 'package:clipboard/common/failure.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import "package:universal_io/io.dart";

part 'cloud_persistance_cubit.freezed.dart';
part 'cloud_persistance_state.dart';

@lazySingleton
class CloudPersistanceCubit extends Cubit<CloudPersistanceState> {
  final AuthCubit auth;
  final DriveSetupCubit driveCubit;
  final ClipboardRepository repo;
  final AppConfigCubit appConfig;
  final String deviceId;

  CloudPersistanceCubit(
    this.auth,
    this.driveCubit,
    this.appConfig,
    @Named("device_id") this.deviceId,
    @Named("remote") this.repo,
  ) : super(const CloudPersistanceState.initial());

  Future<void> download(ClipboardItem item) async {
    final drive = await driveCubit.drive;
    final isDownloading = drive?.isDownloading(item);
    if (isDownloading ?? false) return;

    if (item.localPath != null) {
      final exists = await File(item.localPath!).exists();
      if (exists) return;
    }

    emit(
      CloudPersistanceState.downloadingFile(item.copyWith(downloading: true)),
    );
    final userId = auth.userId;

    if (userId == null) {
      emit(
        CloudPersistanceState.error(authFailure, item.syncDone(authFailure)),
      );
      return;
    }

    final accessToken = await driveCubit.accessToken;

    if (accessToken == null) {
      emit(
        CloudPersistanceState.error(driveFailure, item.syncDone(driveFailure)),
      );
      return;
    }

    final result = await drive?.download(
      item.assignUserId(userId),
      // onProgress: (downloaded, total) {
      //   emit(CloudPersistanceState.downloadingFile(
      //     item.copyWith(
      //       downloading: true,
      //       downloadProgress: downloaded / total,
      //     ),
      //    ),
      //   );
      // }
    );

    result?.fold(
      (failure) {
        emit(CloudPersistanceState.error(failure, item));
      },
      (clip) {
        debugPrint("Downloaded file clip: $clip");
        emit(CloudPersistanceState.saved(clip.syncDone()));
      },
    );
  }
}
