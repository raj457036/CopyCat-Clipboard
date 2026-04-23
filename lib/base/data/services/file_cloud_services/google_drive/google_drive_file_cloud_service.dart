import 'dart:async';

import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/drive_setup_cubit/drive_setup_cubit.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/services/file_cloud_service.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/utils/blur_hash.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

/// Google Drive implementation of [FileCloudService].
///
/// Handles uploading file/media content to Google Drive, including
/// blur hash generation for images. Additional cloud drive providers
/// can be added by implementing the [FileCloudService] interface.
@LazySingleton(as: FileCloudService)
class GoogleDriveFileCloudService implements FileCloudService {
  final DriveSetupCubit _driveCubit;
  final AppConfigCubit _appConfig;

  GoogleDriveFileCloudService(this._driveCubit, this._appConfig);

  @override
  Future<bool> get isAvailable async => (await _driveCubit.drive) != null;

  @override
  FailureOr<ClipboardItem> upload(
    ClipboardItem item, {
    Stream<TransferProgress>? progress,
  }) async {
    if (!_appConfig.isFileSyncEnabled) {
      return const Left(
        Failure(
          message: "File and Media Sync is not enabled",
          code: "file-sync-not-enabled",
        ),
      );
    }

    if (!_appConfig.canUploadFile(item.fileSize ?? 0)) {
      return const Left(
        Failure(
          message: "Auto upload is disabled for files over the limit.",
          code: "auto-upload-restriction",
        ),
      );
    }

    final drive = await _driveCubit.drive;
    if (drive == null) {
      return const Left(
        Failure(message: "Drive not available", code: "drive-failure"),
      );
    }

    final results = await Future.wait([
      drive.upload(item),
      _getBlurHashIfNeeded(item),
    ]);

    final result = results[0] as Either<Failure, ClipboardItem>;
    final blurHash = results[1] as String?;

    return result.fold((failure) => Left(failure), (uploadedItem) {
      final updated = uploadedItem.copyWith(
        imgBlurHash: blurHash ?? uploadedItem.imgBlurHash,
      );
      if (updated.driveFileId == null) {
        return const Left(
          Failure(
            message: "Upload succeeded but no drive file ID returned",
            code: "drive-upload-no-id",
          ),
        );
      }
      return Right(updated);
    });
  }

  Future<String?> _getBlurHashIfNeeded(ClipboardItem item) async {
    if (item.fileMimeType == null ||
        !item.fileMimeType!.startsWith("image/") ||
        item.localPath == null) {
      return null;
    }

    if (item.imgBlurHash != null) return item.imgBlurHash;

    return await getBlurHash(item.localPath!);
  }

  @override
  FailureOr<ClipboardItem> delete(ClipboardItem item) async {
    final drive = await _driveCubit.drive;
    if (drive == null) {
      return const Left(
        Failure(message: "Drive not available", code: "drive-failure"),
      );
    }

    final isSuccess = await drive.delete(item);

    if (!isSuccess) {
      return const Left(
        Failure(
          message: "Failed to delete file from Drive",
          code: "drive-delete-failure",
        ),
      );
    }
    return Right(item);
  }

  @override
  FailureOr<ClipboardItem> download(
    ClipboardItem item, {
    Stream<TransferProgress>? progress,
  }) async {
    final drive = await _driveCubit.drive;
    if (drive == null) {
      return const Left(
        Failure(message: "Drive not available", code: "drive-failure"),
      );
    }

    try {
      return await drive.download(item);
    } catch (e) {
      return const Left(
        Failure(
          message: "Failed to download file from Drive",
          code: "drive-download-failure",
        ),
      );
    }
  }
}
