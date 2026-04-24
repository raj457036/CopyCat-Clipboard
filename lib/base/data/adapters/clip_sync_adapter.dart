import 'package:clipboard/base/bloc/clip_collection_cubit/clip_collection_cubit.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/base/constants/strings/strings.dart';
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
import 'package:injectable/injectable.dart';

@LazySingleton(as: SyncAdapter<ClipboardItem>)
class ClipSyncAdapter implements SyncAdapter<ClipboardItem> {
  final SyncRepository _syncRepo;
  final ClipboardRepository _clipRepo;
  final ClipboardRepository _remoteRepo;
  final ClipBatchSyncService _batchSyncService;
  final ClipCollectionCubit _collectionCubit;
  final ClipCrossSyncListener _realtimeListener;
  final FileCloudService _fileCloudService;

  /// Direct local source access for write-back operations that must NOT
  /// trigger outbox re-enqueue (e.g., saving serverId after remote creation).
  final ClipboardSource _localSource;

  ClipSyncAdapter(
    this._syncRepo,
    @Named("local") this._clipRepo,
    @Named("remote") this._remoteRepo,
    this._batchSyncService,
    this._collectionCubit,
    this._realtimeListener,
    this._fileCloudService,
    @Named("local") this._localSource,
  );

  @override
  String get entityType => 'clip';

  @override
  List<String> get dependsOn => ['collection'];

  @override
  CrossSyncListener<ClipboardItem>? get realtimeListener => _realtimeListener;

  @override
  Future<DateTime?> getLatestSyncTimestamp() async {
    final result = await _clipRepo.getLatestFromOthers(synced: true);
    return result.fold((l) => null, (r) => r?.lastSynced);
  }

  @override
  FailureOr<PaginatedResult<ClipboardItem>> fetchRemoteChanges({
    required int limit,
    required int offset,
    String? excludeDeviceId,
    DateTime? lastSynced,
  }) {
    return _syncRepo.getLatestClipboardItems(
      limit: limit,
      offset: offset,
      excludeDeviceId: excludeDeviceId,
      lastSynced: lastSynced,
    );
  }

  @override
  FailureOr<PaginatedResult<ClipboardItem>> fetchRemoteDeleted({
    required int limit,
    required int offset,
    String? excludeDeviceId,
    DateTime? lastSynced,
  }) {
    return _syncRepo.getDeletedClipboardItems(
      limit: limit,
      offset: offset,
      excludeDeviceId: excludeDeviceId,
      lastSynced: lastSynced,
    );
  }

  @override
  Future<List<CrossSyncEvent<ClipboardItem>>> applyBatch(
    List<ClipboardItem> items, {
    required ConflictResolver<ClipboardItem> conflictResolver,
  }) async {
    await _batchSyncService.waitUntilReady();
    final collectionMapping = _collectionCubit.serverMapping;

    // Note: The current batchSyncService isolate doesn't use the conflictResolver
    // because it runs in a separate isolate and can't easily execute closures/classes
    // passed to it. In a robust setup, we'd pass conflict logic or run it here before
    // sending to isolate. For now, it delegates to the existing isolate logic.
    return _batchSyncService.syncBatch(items, collectionMapping);
  }

  @override
  Future<List<ClipboardItem>> deleteLocally(List<ClipboardItem> items) async {
    final result = await _clipRepo.deleteMany(items);
    return result.fold((l) => [], (r) => r);
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
    logger.i(
      '[ClipSync] pushToRemote: id=${item.id} userId=${item.userId} serverId=${item.serverId} type=${item.type}',
    );
    if (item.userId == kLocalUserId) {
      // Local-only entries should never be pushed to Supabase.
      logger.w('[ClipSync] SKIPPED: userId is kLocalUserId ($kLocalUserId)');
      return Right(item);
    }

    // Re-read from DB to get latest state (serverId may have been set
    // by another sync path, preventing double-creation).
    if (item.id != null) {
      final fresh = await getLocalById(item.id!);
      if (fresh != null) {
        logger.i(
          '[ClipSync] Re-read: serverId=${fresh.serverId} userId=${fresh.userId}',
        );
        item = fresh;
      }
    }

    // Handle file/media upload via the FileUploadService
    if (item.needsFileUpload) {
      logger.i('[ClipSync] File upload needed. Calling FileUploadService...');
      final uploadResult = await _fileCloudService.upload(item);
      return uploadResult.fold(
        (failure) {
          logger.e('[ClipSync] File upload FAILED: ${failure.message}');
          return Left(failure);
        },
        (uploadedItem) async {
          logger.i(
            '[ClipSync] File upload SUCCESS. driveFileId=${uploadedItem.driveFileId}',
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
      logger.i('[ClipSync] Creating on server (no serverId yet)...');
      final result = await _remoteRepo.create(item);
      // Once created remotely, save the new serverId to local DB directly
      // via _localSource (NOT _clipRepo) to avoid re-enqueuing outbox entries.
      return result.fold(
        (l) {
          logger.e('[ClipSync] Server create FAILED: ${l.message}');
          return Left(l);
        },
        (r) async {
          logger.i(
            '[ClipSync] Server create SUCCESS. serverId=${r.serverId}. Saving to local...',
          );
          await _localSource.update(r);
          return Right(r);
        },
      );
    } else {
      logger.i('[ClipSync] Updating on server (serverId=${item.serverId})...');
      return await _remoteRepo.update(item);
    }
  }

  Future<void> _removeFromLocal(ClipboardItem item) async {
    try {
      await _localSource.delete(item, soft: false);
      await item.cleanUp();
    } catch (e) {
      logger.e('[ClipSync] Failed to delete local item: $e');
    }
  }

  @override
  FailureOr<bool> deleteFromRemote(ClipboardItem item) async {
    if (item.userId == kLocalUserId) {
      await _removeFromLocal(item);
      return const Right(true);
    }

    if (item.driveFileId != null) {
      final fileDeleteResult = await _fileCloudService.delete(item);

      return fileDeleteResult.fold(
        (failure) => _handleFileDeleteFailure(failure),
        (deletedItem) {
          logger.i(
            '[ClipSync] File delete SUCCESS. driveFileId=${deletedItem.driveFileId}',
          );
          return _deleteFromServerAndLocal(item, deletedItem);
        },
      );
    }

    return _deleteFromServerAndLocal(item, item);
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
    );
  }

  Either<Failure, bool> _handleFileDeleteFailure(Failure failure) {
    logger.e('[ClipSync] File delete FAILED: ${failure.message}');
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
      logger.e(
        '[ClipSync] Server delete FAILED: ${failure.message}, Recovering local item.',
      );
      await _localSource.update(deletedItem.copyWith(deletedAt: null));
    } catch (e) {
      logger.e(
        '[ClipSync] Failed to recover local item after server delete failure: $e',
      );
    }
  }
}
