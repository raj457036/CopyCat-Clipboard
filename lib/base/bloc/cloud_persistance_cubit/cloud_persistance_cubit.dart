import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/bloc/drive_setup_cubit/drive_setup_cubit.dart';
import 'package:clipboard/base/db/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/repositories/clipboard.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/utils/blur_hash.dart';
import 'package:dartz/dartz.dart';
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

  Future<void> persist(ClipboardItem item) async {
    if (auth.isLocalAuth) return;
    // emit(const CloudPersistanceState.initial());

    if (!appConfig.isSyncEnabled) {
      if (item.userIntent) {
        emit(
          CloudPersistanceState.error(
            const Failure(
              message: "Sync is not enabled",
              code: "sync-not-enabled",
            ),
            item,
          ),
        );
      }
      return;
    }

    final userId = auth.userId;
    if (userId == null) return;

    item = item.assignUserId(userId);

    if (item.serverId != null) {
      emit(CloudPersistanceState.updatingItem(item));
      final result = await repo.update(item);
      emit(
        result.fold(
          (l) => CloudPersistanceState.error(
            l,
            item.syncDone(l),
          ),
          (r) => CloudPersistanceState.saved(r.syncDone()),
        ),
      );
    } else {
      switch (item.type) {
        case ClipItemType.text || ClipItemType.url:
          await _create(item.assignUserId(userId));
        case ClipItemType.media || ClipItemType.file:
          if (!appConfig.isFileSyncEnabled) {
            emit(
              CloudPersistanceState.error(
                const Failure(
                  message: "File and Media Sync is not enabled",
                  code: "file-sync-not-enabled",
                ),
                item,
              ),
            );
            return;
          }
          await _uploadAndCreate(
            item.assignUserId(userId),
          );
      }
    }
    return;
  }

  Future<void> _create(ClipboardItem item) async {
    emit(CloudPersistanceState.creatingItem(item));
    final result = await repo.create(item);
    emit(
      result.fold(
        (l) => CloudPersistanceState.error(
          l,
          item.syncDone(l),
        ),
        (r) => CloudPersistanceState.saved(
          r.syncDone(),
          created: true,
        ),
      ),
    );
  }

  Future<String?> _getBlurHashIfNeeded(ClipboardItem item) async {
    if (item.fileMimeType == null ||
        !item.fileMimeType!.startsWith("image/") ||
        item.localPath == null) {
      return null;
    }

    if (item.imgBlurHash != null) return item.imgBlurHash;

    final blurHash = await getBlurHash(item.localPath!);
    return blurHash;
  }

  Future<void> _uploadAndCreate(ClipboardItem item) async {
    if (!appConfig.canUploadFile(item.fileSize!) && !item.userIntent) {
      logger.i("Auto upload is disabled for files over the limit.");
      emit(
        CloudPersistanceState.error(
          const Failure(
            message: "Auto upload is disabled for files over the limit.",
            code: "auto-upload-restriction",
          ),
          item,
        ),
      );
      return;
    }

    emit(
      CloudPersistanceState.uploadingFile(
        item.copyWith(uploading: true)..applyId(item),
      ),
    );
    final userId = auth.userId;

    if (userId == null) {
      emit(
        CloudPersistanceState.error(
          authFailure,
          item.syncDone(authFailure),
        ),
      );
      return;
    }

    final drive = await driveCubit.drive;

    if (drive == null) {
      emit(CloudPersistanceState.error(
        driveFailure,
        item.syncDone(driveFailure),
      ));
      return;
    }

    final results = await Future.wait([
      drive.upload(
        item.assignUserId(userId),
        onProgress: (uploaded, total) {
          emit(
            CloudPersistanceState.uploadingFile(
              item.copyWith(
                uploading: true,
                uploadProgress: uploaded / total,
              )..applyId(item),
            ),
          );
        },
      ),
      _getBlurHashIfNeeded(item)
    ]);

    final result = results[0] as Either<Failure, ClipboardItem>;
    final blurhash = results[1] as String?;

    result.fold(
      (failure) {
        item = item.copyWith(imgBlurHash: blurhash)..applyId(item);
        emit(
          CloudPersistanceState.error(failure, item),
        );
      },
      (updatedItem) async {
        updatedItem = updatedItem.copyWith(imgBlurHash: blurhash)
          ..applyId(updatedItem);
        if (updatedItem.driveFileId != null) {
          await _create(updatedItem);
        }
      },
    );

    if (blurhash != null) {}
  }

  Future<void> delete(ClipboardItem item) async {
    emit(CloudPersistanceState.deletingItems([item]));
    final drive = await driveCubit.drive;
    drive?.cancelOperation(item);
    if (item.driveFileId != null) {
      if (drive == null) {
        emit(CloudPersistanceState.error(
          driveFailure,
          item.syncDone(driveFailure),
        ));
        return;
      }

      await drive.delete(item);

      item = item.copyWith(driveFileId: null)..applyId(item);
    }

    if (item.serverId == null) {
      emit(
        CloudPersistanceState.deletedItems(
          [item.copyWith(lastSynced: null)..applyId(item)],
        ),
      );
      return;
    }

    item = item.copyWith(deviceId: deviceId)..applyId(item);
    final result = await repo.delete(item);

    result.fold(
      (l) => emit(CloudPersistanceState.error(
        l,
        item,
      )),
      (r) => emit(
        CloudPersistanceState.deletedItems(
          [
            item.copyWith(
              serverId: null,
              lastSynced: null,
            )..applyId(item)
          ],
        ),
      ),
    );
  }

  Future<void> deleteMany(List<ClipboardItem> items) async {
    emit(CloudPersistanceState.deletingItems(items));
    final drive = await driveCubit.drive;

    await drive?.deleteMany(items);

    final items_ = items.map(
      (item) => item.copyWith(deviceId: deviceId)..applyId(item),
    );
    final result = await repo.deleteMany(items_.toList());

    result.fold(
      (l) => emit(CloudPersistanceState.error(l)),
      (r) => emit(
        CloudPersistanceState.deletedItems(items
            .map((item) => item.copyWith(
                  serverId: null,
                  lastSynced: null,
                )..applyId(item))
            .toList()),
      ),
    );
  }

  Future<void> download(ClipboardItem item) async {
    final drive = await driveCubit.drive;
    final isDownloading = drive?.isDownloading(item);
    if (isDownloading ?? false) return;

    if (item.localPath != null) {
      final exists = await File(item.localPath!).exists();
      if (exists) return;
    }

    emit(
      CloudPersistanceState.downloadingFile(
        item.copyWith(downloading: true)..applyId(item),
      ),
    );
    final userId = auth.userId;

    if (userId == null) {
      emit(CloudPersistanceState.error(
        authFailure,
        item.syncDone(authFailure),
      ));
      return;
    }

    final accessToken = await driveCubit.accessToken;

    if (accessToken == null) {
      emit(CloudPersistanceState.error(
        driveFailure,
        item.syncDone(driveFailure),
      ));
      return;
    }

    final result = await drive?.download(
      item.assignUserId(userId),
      // onProgress: (downloaded, total) {
      //   emit(CloudPersistanceState.downloadingFile(
      //     item.copyWith(
      //       downloading: true,
      //       downloadProgress: downloaded / total,
      //     )..applyId(item),
      //    ),
      //   );
      // }
    );

    result?.fold(
      (failure) {
        emit(
          CloudPersistanceState.error(failure, item),
        );
      },
      persist,
    );
  }
}
