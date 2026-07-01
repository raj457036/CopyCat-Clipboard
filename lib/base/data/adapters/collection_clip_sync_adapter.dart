import 'package:clipboard/base/bloc/clip_collection_cubit/clip_collection_cubit.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:clipboard/base/domain/services/file_cloud_service.dart';
import 'package:clipboard/base/domain/sources/clipboard.dart';
import 'package:dartz/dartz.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/repositories/clipboard.dart';
import 'package:clipboard/base/domain/repositories/sync_clipboard.dart';
import 'package:clipboard/base/domain/services/clip_batch_sync_service.dart';
import 'package:clipboard/base/domain/services/conflict_resolver.dart';
import 'package:clipboard/base/domain/services/sync_adapter.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/paginated_results.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:injectable/injectable.dart';

@Named("collection_clips")
@LazySingleton(as: SyncAdapter<ClipboardItem>)
class CollectionClipSyncAdapter implements SyncAdapter<ClipboardItem> {
  static const _logger = AppLogger.scoped('CollectionClipSyncAdapter');
  final SyncRepository _syncRepo;
  final ClipboardRepository _clipRepo;
  final ClipboardRepository _remoteRepo;
  final ClipBatchSyncService _batchSyncService;
  final ClipCollectionCubit _collectionCubit;
  final FileCloudService _fileCloudService;

  /// Direct local source access for write-back operations that must NOT
  /// trigger outbox re-enqueue (e.g., saving serverId after remote creation).
  final ClipboardSource _localSource;

  CollectionClipSyncAdapter(
    this._syncRepo,
    @Named("local") this._clipRepo,
    @Named("remote") this._remoteRepo,
    this._batchSyncService,
    this._collectionCubit,
    this._fileCloudService,
    @Named("local") this._localSource,
  );

  @override
  String get entityType => 'clip';

  // Clip Sync will be handling realtime updates for all kind of clips.
  @override
  CrossSyncListener<ClipboardItem>? get realtimeListener => null;

  @override
  Future<DateTime?> getLatestSyncTimestamp() async {
    final result = await _clipRepo.getLatestFromOthers(synced: true);
    return result.fold((l) => null, (r) => r?.lastSynced);
  }

  @override
  FailureOr<PaginatedResult<ClipboardItem>> fetchRemoteChanges({
    required int limit,
    DateTime? lastModified,
    String? excludeDeviceId,
  }) {
    final result = _syncRepo.getLatestCollectionClipboardItems(
      limit: limit,
      lastModified: lastModified,
      excludeDeviceId: excludeDeviceId,
    );

    return result;
  }

  @override
  FailureOr<PaginatedResult<ClipboardItem>> fetchRemoteDeleted({
    required int limit,
    DateTime? lastModified,
    String? excludeDeviceId,
    DateTime? lastSynced,
  }) async {
    // NO-OP
    // Since clip sync adapter will be handling this.
    return Right(PaginatedResult.empty());
  }

  @override
  Future<List<CrossSyncEvent<ClipboardItem>>> applyBatch(
    List<ClipboardItem> items, {
    required ConflictResolver<ClipboardItem> conflictResolver,
  }) async {
    await _batchSyncService.waitUntilReady();
    final collectionMapping = _collectionCubit.serverMapping;

    final events = await _batchSyncService.syncBatch(items, collectionMapping);
    return events;
  }

  @override
  Future<List<ClipboardItem>> deleteLocally(List<ClipboardItem> items) async {
    return await _localSource.deleteMany(items, soft: false);
  }

  @override
  Future<ClipboardItem?> getLocalById(int localId) async {
    final result = await _clipRepo.get(id: localId);
    return result.fold((l) => null, (r) => r);
  }

  Future<ClipboardItem?> findLocalByServerId(int serverId) async {
    final result = await _clipRepo.get(serverId: serverId);
    return result.fold((l) => null, (r) => r);
  }

  @override
  FailureOr<ClipboardItem> pushToRemote(ClipboardItem item) async {
    _logger.d(
      () =>
          'pushToRemote: id=${item.id} userId=${item.userId} serverId=${item.serverId} type=${item.type}',
    );

    // Re-read from DB to get latest state (serverId may have been set
    // by another sync path, preventing double-creation).
    if (item.id != null) {
      final fresh = await getLocalById(item.id!);
      if (fresh != null) {
        _logger.d(
          () => 'Re-read: serverId=${fresh.serverId} userId=${fresh.userId}',
        );
        item = fresh;
      }
    }

    // Handle file/media upload via the FileUploadService
    if (item.needsFileUpload) {
      _logger.d(() => 'File upload needed. Calling FileUploadService...');
      final uploadResult = await _fileCloudService.upload(item);
      return uploadResult.fold(
        (failure) {
          _logger.e(() => 'File upload FAILED: ${failure.message}');
          return Left(failure);
        },
        (uploadedItem) async {
          _logger.i(
            () =>
                'File upload SUCCESS. driveFileId=${uploadedItem.driveFileId}',
          );
          item = uploadedItem;
          return await _createOrUpdateRemote(item);
        },
      );
    }

    return await _createOrUpdateRemote(item);
  }

  FailureOr<ClipboardItem> _createOrUpdateRemote(ClipboardItem item) async {
    if (item.serverId == null) {
      _logger.d(() => 'Creating on server (no serverId yet)...');
      final result = await _remoteRepo.create(item);
      // Once created remotely, save the new serverId to local DB directly
      // via _localSource (NOT _clipRepo) to avoid re-enqueuing outbox entries.
      return result.fold(
        (l) {
          _logger.e(() => 'Server create FAILED: ${l.message}');
          return Left(l);
        },
        (r) async {
          _logger.d(
            () =>
                'Server create SUCCESS. serverId=${r.serverId}. Saving to local...',
          );
          await _localSource.update(r);
          return Right(r);
        },
      );
    } else {
      _logger.i(() => 'Updating on server (serverId=${item.serverId})...');
      return await _remoteRepo.update(item);
    }
  }

  @override
  Future<ClipboardItem?> persistSyncResult(
    ClipboardItem item, {
    DateTime? syncedAt,
  }) async {
    final saved = item.copyWith(
      lastSynced: syncedAt ?? systemTime(),
      isQueued: false,
      uploading: false,
      downloading: false,
      failure: null,
    );

    try {
      return await _localSource.update(saved);
    } catch (e) {
      _logger.w(() => 'Failed to persist sync result locally: $e');
      return saved;
    }
  }

  Future<void> _removeFromLocal(ClipboardItem item) async {
    try {
      await _localSource.delete(item, soft: false);
      await item.cleanUp();
    } catch (e) {
      _logger.e(() => 'Failed to delete local item: $e');
    }
  }

  @override
  FailureOr<bool> deleteFromRemote(ClipboardItem item) async {
    if (item.driveFileId != null) {
      final fileDeleteResult = await _fileCloudService.delete(item);

      return fileDeleteResult.fold(
        (failure) => _handleFileDeleteFailure(failure),
        (deletedItem) {
          _logger.d(
            () => 'File delete SUCCESS. driveFileId=${deletedItem.driveFileId}',
          );
          return _deleteFromServerAndLocal(item, deletedItem);
        },
      );
    }

    return _deleteFromServerAndLocal(item, item);
  }

  @override
  FailureOr<bool> deleteBatchFromRemote(List<ClipboardItem> items) async {
    if (items.isEmpty) return const Right(true);

    final remoteDelete = await _remoteRepo.deleteMany(items);
    final failed = remoteDelete.fold((failure) => failure, (_) => null);
    if (failed != null) {
      _logger.e(() => 'Batch server delete FAILED: ${failed.message}');
      return Left(failed);
    }

    for (final item in items) {
      await _removeFromLocal(item);
    }

    return const Right(true);
  }

  @override
  Future<ClipboardItem?> markSyncInProgress(
    ClipboardItem item, {
    required bool inProgress,
    Failure? failure,
  }) async {
    return item.copyWith(
      uploading: inProgress,
      uploadProgress: inProgress ? item.uploadProgress : null,
      failure: failure,
      isQueued: inProgress ? item.isQueued : false,
    );
  }

  Either<Failure, bool> _handleFileDeleteFailure(Failure failure) {
    _logger.i(() => 'File delete FAILED: ${failure.message}');
    return Left(failure);
  }

  FailureOr<bool> _deleteFromServerAndLocal(
    ClipboardItem originalItem,
    ClipboardItem deletedItem,
  ) async {
    final serverDeleteResult = await _remoteRepo.delete(originalItem);
    return serverDeleteResult.fold(
      (failure) async {
        await _recoverLocalItemAfterServerDeleteFailure(deletedItem, failure);
        return Left(failure);
      },
      (_) async {
        await _removeFromLocal(deletedItem);
        return const Right(true);
      },
    );
  }

  Future<void> _recoverLocalItemAfterServerDeleteFailure(
    ClipboardItem deletedItem,
    Failure failure,
  ) async {
    try {
      _logger.e(
        () =>
            'Server delete FAILED: ${failure.message}, Recovering local item.',
      );
      await _localSource.update(deletedItem.copyWith(deletedAt: null));
    } catch (e) {
      _logger.e(
        () => 'Failed to recover local item after server delete failure: $e',
      );
    }
  }
}
