import 'package:clipboard/base/bloc/clip_collection_cubit/clip_collection_cubit.dart';
import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
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

  ClipSyncAdapter(
    this._syncRepo,
    @Named("local") this._clipRepo,
    @Named("remote") this._remoteRepo,
    this._batchSyncService,
    this._collectionCubit,
    this._realtimeListener,
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
    if (item.userId == kLocalUserId) {
      // Local-only entries should never be pushed to Supabase.
      return Right(item);
    }

    // NOTE: File/media sync requires using drive upload, which currently lives in
    // CloudPersistanceCubit. For text/links, or metadata updates, direct remoteRepo hits work well.
    if (item.serverId == null) {
      final result = await _remoteRepo.create(item);
      // Once created remotely, save the new serverId down to Isar
      return result.fold((l) => Left(l), (r) async {
        await _clipRepo.update(r);
        return Right(r);
      });
    } else {
      return await _remoteRepo.update(item);
    }
  }

  @override
  FailureOr<bool> deleteFromRemote(ClipboardItem item) async {
    if (item.userId == kLocalUserId) {
      return const Right(true);
    }

    return await _remoteRepo.delete(item);
  }
}
