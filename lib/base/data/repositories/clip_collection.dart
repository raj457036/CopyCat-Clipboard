import 'package:clipboard/base/domain/model/clip_collection/clipcollection.dart';
import 'package:clipboard/base/domain/repositories/clip_collection.dart';
import 'package:clipboard/base/domain/sources/clip_collection.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/paginated_results.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/base/domain/model/sync/sync_outbox_entry.dart';
import 'package:clipboard/base/domain/repositories/sync_outbox.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ClipCollectionRepository)
class ClipCollectionRepositoryImpl implements ClipCollectionRepository {
  final ClipCollectionSource remote;
  final ClipCollectionSource local;
  final SyncOutboxRepository outbox;

  ClipCollectionRepositoryImpl(
    @Named("remote") this.remote,
    @Named("local") this.local,
    this.outbox,
  );

  @override
  FailureOr<ClipCollection> create(ClipCollection collection) async {
    try {
      collection = collection.copyWith(modified: systemTime());
      ClipCollection result = await local.create(collection);
      if (result.id != null) {
        await outbox.enqueue(
          SyncOutboxEntry(
            entityType: 'collection',
            localId: result.id!,
            action: SyncOutboxAction.create,
            createdAt: DateTime.now(),
          ),
        );
      }
      try {
        result = await remote.create(result);
        await local.update(result);
      } catch (_) {}
      return Right(result);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<bool> delete(ClipCollection collection) async {
    try {
      await local.delete(collection, soft: true);
      if (collection.id != null && collection.deletedAt == null) {
        await outbox.enqueue(
          SyncOutboxEntry(
            entityType: 'collection',
            localId: collection.id!,
            action: SyncOutboxAction.delete,
            createdAt: DateTime.now(),
          ),
        );
      }
      return const Right(true);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<void> deleteAll() async {
    try {
      final result = await local.deleteAll();
      return Right(result);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<PaginatedResult<ClipCollection>> getList({
    int limit = 50,
    int offset = 0,
    String? search,
    bool fromServer = false,
  }) async {
    try {
      if (fromServer) {
        final result = await remote.getList(
          limit: limit,
          offset: offset,
          search: search,
        );
        return Right(result);
      } else {
        final result = await local.getList(
          limit: limit,
          offset: offset,
          search: search,
        );
        return Right(result);
      }
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<ClipCollection> update(ClipCollection collection) async {
    try {
      ClipCollection result = await local.update(collection);
      if (result.id != null) {
        await outbox.enqueue(
          SyncOutboxEntry(
            entityType: 'collection',
            localId: result.id!,
            action: SyncOutboxAction.update,
            createdAt: systemTime(),
          ),
        );
        try {
          result = await remote.update(result);
          await local.update(result);
        } catch (_) {}
      }
      return Right(result);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<ClipCollection?> get({int? id, int? serverId}) async {
    try {
      ClipCollection? result = await local.get(id: id, serverId: serverId);
      result ??= await remote.get(id: id, serverId: serverId);
      return Right(result);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<List<ClipCollection>> deleteMany(List<ClipCollection> items) async {
    try {
      final result = await local.deleteMany(items, soft: true);
      final queuedLocalIds = <int>{};
      for (final item in items) {
        final localId = item.id;
        if (localId == null || !queuedLocalIds.add(localId)) continue;
        await outbox.enqueue(
          SyncOutboxEntry(
            entityType: 'collection',
            localId: localId,
            action: SyncOutboxAction.delete,
            createdAt: systemTime(),
          ),
        );
      }
      return Right(result);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<ClipCollection> updateOrCreate(ClipCollection collection) async {
    try {
      final result = await local.updateOrCreate(collection);
      return Right(result);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<ClipCollection?> getLatestFromOthers({bool? synced}) async {
    try {
      final result = await local.getLatestFromOthers(synced: synced);
      return Right(result);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<List<ClipCollection>> updateMany(
    List<ClipCollection> collections,
  ) async {
    try {
      final result = await local.updateMany(collections);
      return Right(result);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<int> getCount({bool local = true}) async {
    try {
      final int count;
      if (local) {
        count = await this.local.getCount();
      } else {
        count = await remote.getCount();
      }
      return Right(count);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
