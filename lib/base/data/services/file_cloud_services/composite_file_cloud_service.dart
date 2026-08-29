import 'dart:async';

import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/model/cloud_file_id/cloud_file_id.dart';
import 'package:clipboard/base/domain/services/file_cloud_service.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/logging.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

/// Composite [FileCloudService] that routes uploads to the currently selected
/// cloud provider (WebDAV or Google Drive), and routes downloads / deletions
/// based on the [ClipboardItem.driveFileId] prefix.
@LazySingleton(as: FileCloudService)
class CompositeFileCloudService implements FileCloudService {
  static const _logger = AppLogger.scoped('CompositeFileCloudService');

  final FileCloudService _googleDriveService;
  final FileCloudService _webdavService;
  final AppConfigCubit _appConfig;

  CompositeFileCloudService(
    @Named("google_drive") this._googleDriveService,
    @Named("webdav") this._webdavService,
    this._appConfig,
  );

  @override
  Future<bool> get isAvailable async {
    final activeProvider = _appConfig.state.config.activeStorageProvider;
    if (activeProvider == ActiveCloudStorageProvider.webdav) {
      return await _webdavService.isAvailable;
    }
    return await _googleDriveService.isAvailable;
  }

  @override
  FailureOr<ClipboardItem> upload(
    ClipboardItem item, {
    Stream<TransferProgress>? progress,
  }) async {
    final activeProvider = _appConfig.state.config.activeStorageProvider;
    if (activeProvider == ActiveCloudStorageProvider.webdav) {
      if (await _webdavService.isAvailable) {
        _logger.d(() => 'Uploading clip via selected WebDAV provider');
        return _webdavService.upload(item, progress: progress);
      }
      return const Left(
        Failure(
          message: "WebDAV storage is not connected",
          code: "webdav-not-connected",
        ),
      );
    } else {
      if (await _googleDriveService.isAvailable) {
        _logger.d(() => 'Uploading clip via selected Google Drive provider');
        return _googleDriveService.upload(item, progress: progress);
      }
      return const Left(
        Failure(
          message: "Google Drive is not connected",
          code: "google-drive-not-connected",
        ),
      );
    }
  }

  @override
  FailureOr<ClipboardItem> download(
    ClipboardItem item, {
    Stream<TransferProgress>? progress,
  }) async {
    final driveId = item.driveFileId;
    if (driveId == null) {
      return const Left(
        Failure(
          message: "Item does not have a remote file ID",
          code: "missing-drive-file-id",
        ),
      );
    }

    final parsed = CloudFileId.parse(driveId);
    if (parsed.isWebDav) {
      _logger.d(() => 'Downloading clip via WebDAV provider');
      return _webdavService.download(item, progress: progress);
    } else {
      _logger.d(() => 'Downloading clip via Google Drive provider');
      return _googleDriveService.download(item, progress: progress);
    }
  }

  @override
  FailureOr<ClipboardItem> delete(ClipboardItem item) async {
    final driveId = item.driveFileId;
    if (driveId == null) {
      return Right(item);
    }

    final parsed = CloudFileId.parse(driveId);
    if (parsed.isWebDav) {
      _logger.d(() => 'Deleting clip via WebDAV provider');
      return _webdavService.delete(item);
    } else {
      _logger.d(() => 'Deleting clip via Google Drive provider');
      return _googleDriveService.delete(item);
    }
  }
}
