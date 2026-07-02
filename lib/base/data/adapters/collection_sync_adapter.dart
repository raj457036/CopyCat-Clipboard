import 'package:clipboard/base/bloc/clip_collection_cubit/clip_collection_cubit.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:clipboard/base/domain/sources/clip_collection.dart';
import 'package:clipboard/base/domain/model/clip_collection/clipcollection.dart';
import 'package:clipboard/base/domain/repositories/clip_collection.dart';
import 'package:clipboard/base/domain/repositories/sync_clipboard.dart';
import 'package:clipboard/base/domain/services/conflict_resolver.dart';
import 'package:clipboard/base/domain/services/sync_adapter.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/paginated_results.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SyncAdapter<ClipCollection>)
class CollectionSyncAdapter implements SyncAdapter<ClipCollection> {
  final SyncRepository _syncRepo;
  final ClipCollectionRepository _collectionRepo;
  final ClipCollectionSource _localSource;
  final ClipCollectionSource _remoteSource;
  final ClipCollectionCubit _collectionCubit;
  final CollectionCrossSyncListener _realtimeListener;

  CollectionSyncAdapter(
    this._syncRepo,
    this._collectionRepo,
    @Named("local") this._localSource,
    @Named("remote") this._remoteSource,
    this._collectionCubit,
    this._realtimeListener,
  );

  @override
  String get entityType => 'collection';

  @override
  CrossSyncListener<ClipCollection>? get realtimeListener => _realtimeListener;

  @override
  Future<DateTime?> getLatestSyncTimestamp() async {
    final result = await _collectionRepo.getLatestFromOthers(synced: true);
    return result.fold((l) => null, (r) => r?.lastSynced);
  }

  @override
  FailureOr<PaginatedResult<ClipCollection>> fetchRemoteChanges({
    required int limit,
    DateTime? lastModified,
    String? excludeDeviceId,
  }) {
    return _syncRepo.getLatestClipCollections(
      limit: limit,
      lastModified: lastModified,
      excludeDeviceId: excludeDeviceId,
    );
  }

  @override
  FailureOr<PaginatedResult<ClipCollection>> fetchRemoteDeleted({
    required int limit,
    DateTime? lastModified,
    String? excludeDeviceId,
    DateTime? lastSynced,
  }) {
    return _syncRepo.getDeletedClipCollections(
      limit: limit,
      lastModified: lastModified,
      excludeDeviceId: excludeDeviceId,
      lastSynced: lastSynced,
    );
  }

  @override
  Future<List<CrossSyncEvent<ClipCollection>>> applyBatch(
    List<ClipCollection> items, {
    required ConflictResolver<ClipCollection> conflictResolver,
  }) async {
    final collectionMapping = _collectionCubit.serverMapping;
    final syncEvents = <CollectionCrossSyncEvent>[];

    // Convert to local IDs where possible.
    // Fast path: check the in-memory cubit mapping.
    // Fallback: query the DB by serverId to avoid duplicate inserts when the
    // cubit is fresh (e.g. first launch, concurrent sync, app restart).
    for (var i = 0; i < items.length; i++) {
      final serverId = items[i].serverId;
      final localId = serverId != null ? collectionMapping[serverId] : null;
      if (localId != null) {
        items[i] = items[i].copyWith(id: localId);
        syncEvents.add((CrossSyncEventType.update, items[i]));
      } else if (serverId != null) {
        final existing = await _collectionRepo.get(serverId: serverId);
        final existingId = existing.fold((l) => null, (r) => r?.id);
        if (existingId != null) {
          items[i] = items[i].copyWith(id: existingId);
          syncEvents.add((CrossSyncEventType.update, items[i]));
        } else {
          syncEvents.add((CrossSyncEventType.create, items[i]));
        }
      } else {
        syncEvents.add((CrossSyncEventType.create, items[i]));
      }
    }

    final result = await _collectionRepo.updateMany(items);
    return result.fold((l) => [], (collections) {
      for (var i = 0; i < collections.length; i++) {
        syncEvents[i] = (syncEvents[i].$1, collections[i]);
      }
      return syncEvents;
    });
  }

  @override
  Future<List<ClipCollection>> deleteLocally(List<ClipCollection> items) async {
    return await _localSource.deleteMany(items, soft: false);
  }

  @override
  Future<ClipCollection?> getLocalById(int localId) async {
    final result = await _collectionRepo.get(id: localId);
    return result.fold((l) => null, (r) => r);
  }

  Future<ClipCollection?> findLocalByServerId(int serverId) async {
    final result = await _collectionRepo.get(serverId: serverId);
    return result.fold((l) => null, (r) => r);
  }

  @override
  FailureOr<ClipCollection> pushToRemote(ClipCollection item) async {
    try {
      if (item.serverId == null) {
        final result = await _remoteSource.create(item);
        // We only return success here, the pull will sync back the ID and lastSynced,
        // or we could update local manually. For now, returning the created item works.
        return Right(result);
      } else {
        final result = await _remoteSource.update(item);
        return Right(result);
      }
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<bool> deleteFromRemote(ClipCollection item) async {
    try {
      await _remoteSource.delete(item, soft: true);
      await _removeFromLocal([item]);
      return const Right(true);
    } catch (e) {
      await _recoverLocalItemAfterServerDeleteFailure([item]);
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<ClipCollection?> persistSyncResult(
    ClipCollection item, {
    DateTime? syncedAt,
  }) async {
    return item.copyWith(lastSynced: syncedAt ?? DateTime.now());
  }

  @override
  FailureOr<bool> deleteBatchFromRemote(List<ClipCollection> items) async {
    if (items.isEmpty) return const Right(true);

    try {
      await _remoteSource.deleteMany(items, soft: true);
      await _removeFromLocal(items);
      return const Right(true);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  Future<void> _removeFromLocal(List<ClipCollection> items) async {
    try {
      await _localSource.deleteMany(items, soft: false);
    } catch (_) {}
  }

  Future<void> _recoverLocalItemAfterServerDeleteFailure(
    List<ClipCollection> items,
  ) async {
    try {
      await _localSource.updateMany(
        items.map((item) => item.copyWith(deletedAt: null)).toList(),
      );
    } catch (_) {}
  }

  @override
  Future<ClipCollection?> markSyncInProgress(
    ClipCollection item, {
    required bool inProgress,
    Failure? failure,
  }) async {
    return item;
  }
}
