import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clipboard/base/data/services/notification_service.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/model/notification_message.dart'
    show NotificationMessage, NotificationType;
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:clipboard/base/domain/services/file_cloud_service.dart';
import 'package:clipboard/base/domain/services/sync_event_bus.dart';
import 'package:clipboard/base/domain/sources/clipboard.dart';
import 'package:clipboard/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:universal_io/io.dart';

part 'file_cloud_cubit.freezed.dart';
part 'file_cloud_state.dart';

@injectable
class FileCloudCubit extends Cubit<FileCloudState> {
  final FileCloudService _fileCloudService;
  final ClipboardSource _localSource;
  final SyncEventBus _syncEventBus;
  final Set<Object> _activeDownloads = <Object>{};

  FileCloudCubit(
    this._fileCloudService,
    @Named('local') this._localSource,
    this._syncEventBus,
  ) : super(const FileCloudState.initial());

  Future<void> download(ClipboardItem item) async {
    final downloadKey = _downloadKey(item);
    if (downloadKey == null || _activeDownloads.contains(downloadKey)) return;

    final localPath = item.localPath;
    if (localPath != null) {
      final exists = await File(localPath).exists();
      if (exists) return;
    }

    _activeDownloads.add(downloadKey);
    final pendingItem = item.copyWith(downloading: true, failure: null);
    _emitItemEvent(CrossSyncEventType.update, pendingItem);
    emit(FileCloudState.downloading(pendingItem));

    try {
      final downloadResult = await _fileCloudService.download(item);
      await downloadResult.fold<Future<void>>(
        (failure) async => _handleDownloadFailure(failure, item),
        (downloadedItem) async {
          final persistedResult = await _persistDownloadedItem(downloadedItem);
          await persistedResult.fold<Future<void>>(
            (failure) async {
              await downloadedItem.cleanUp();
              _handleDownloadFailure(failure, item);
            },
            (saved) async {
              final (eventType, persistedItem) = saved;
              final completedItem = persistedItem.syncDone();
              _emitItemEvent(eventType, completedItem);
              emit(FileCloudState.downloaded(completedItem));
            },
          );
        },
      );
    } finally {
      _activeDownloads.remove(downloadKey);
    }
  }

  Object? _downloadKey(ClipboardItem item) {
    return item.id ?? item.serverId ?? item.driveFileId;
  }

  FailureOr<(CrossSyncEventType, ClipboardItem)> _persistDownloadedItem(
    ClipboardItem item,
  ) async {
    try {
      if (item.id != null) {
        return _updateDownloadedItem(item);
      }

      if (item.serverId == null) {
        return _createDownloadedItem(item);
      }

      final existingItem = await _localSource.get(serverId: item.serverId);
      if (existingItem == null) {
        return _createDownloadedItem(item);
      }

      return _updateDownloadedItem(
        item.copyWith(id: existingItem.id, localOnly: existingItem.localOnly),
      );
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  FailureOr<(CrossSyncEventType, ClipboardItem)> _createDownloadedItem(
    ClipboardItem item,
  ) async {
    try {
      // Write directly to the local source so manual downloads do not enqueue
      // outbox entries and bounce back into remote sync.
      final savedItem = await _localSource.create(item);
      return Right((CrossSyncEventType.create, savedItem));
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  FailureOr<(CrossSyncEventType, ClipboardItem)> _updateDownloadedItem(
    ClipboardItem item,
  ) async {
    try {
      final savedItem = await _localSource.update(item);
      return Right((CrossSyncEventType.update, savedItem));
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  void _handleDownloadFailure(Failure failure, ClipboardItem item) {
    _notifyDownloadError(failure);
    final failedItem = item.syncDone(failure);
    _emitItemEvent(CrossSyncEventType.update, failedItem);
    emit(FileCloudState.error(failure, failedItem));
  }

  void _notifyDownloadError(Failure failure) {
    InAppNotificationService.i.notify(
      NotificationMessage(
        id: 'file_cloud_download_error',
        body: failure.message,
        type: NotificationType.error,
      ),
    );
  }

  void _emitItemEvent(CrossSyncEventType eventType, ClipboardItem item) {
    _syncEventBus.emit<ClipboardItem>((eventType, item));
  }
}
