import 'package:clipboard/base/bloc/clip_collection_cubit/clip_collection_cubit.dart';
import 'package:clipboard/base/constants/strings/strings.dart';
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
  final ClipCollectionSource _remoteSource;
  final ClipCollectionCubit _collectionCubit;
  final CollectionCrossSyncListener _realtimeListener;

  CollectionSyncAdapter(
    this._syncRepo,
    this._collectionRepo,
    @Named("remote") this._remoteSource,
    this._collectionCubit,
    this._realtimeListener,
  );

  @override
  String get entityType => 'collection';

  @override
  List<String> get dependsOn => const [];

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
    required int offset,
    String? excludeDeviceId,
    DateTime? lastSynced,
  }) {
    return _syncRepo.getLatestClipCollections(
      limit: limit,
      offset: offset,
      excludeDeviceId: excludeDeviceId,
      lastSynced: lastSynced,
    );
  }

  @override
  FailureOr<PaginatedResult<ClipCollection>> fetchRemoteDeleted({
    required int limit,
    required int offset,
    String? excludeDeviceId,
    DateTime? lastSynced,
  }) {
    return _syncRepo.getDeletedClipCollections(
      limit: limit,
      offset: offset,
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

    // Convert to local IDs where possible
    for (var i = 0; i < items.length; i++) {
      final serverId = items[i].serverId;
      final localId = collectionMapping[serverId];
      if (localId != null) {
        items[i] = items[i].copyWith(id: localId);
        // Note: conflictResolver could be used here if we fetched the existing items
        syncEvents.add((CrossSyncEventType.update, items[i]));
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
    final result = await _collectionRepo.deleteMany(items);
    return result.fold((l) => [], (r) => r);
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
    if (item.userId == kLocalUserId) {
      // Local-only entries should never be pushed to Supabase.
      return Right(item);
    }

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
    if (item.userId == kLocalUserId) {
      return const Right(true);
    }

    try {
      await _remoteSource.delete(item);
      return const Right(true);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<ClipCollection?> markSyncInProgress(
    ClipCollection item, {
    required bool inProgress,
    Failure? failure,
  }) async {
    return item;
  }

  @override
  Future<ClipCollection> beforeLocalWrite(ClipCollection item) async {
    // No-op
    return item;
  }
}
