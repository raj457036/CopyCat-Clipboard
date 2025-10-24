import 'package:clipboard/base/common/failure.dart';
import 'package:clipboard/base/common/paginated_results.dart';
import 'package:clipboard/base/db/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/repositories/clipboard.dart';
import 'package:clipboard/base/domain/sources/clipboard.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/base/enums/sort.dart';
import 'package:clipboard/base/utils/utility.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Named("remote")
@LazySingleton(as: ClipboardRepository)
class ClipboardRepositoryCloudImpl implements ClipboardRepository {
  final ClipboardSource remote;

  ClipboardRepositoryCloudImpl(
    @Named("remote") this.remote,
  );

  @override
  FailureOr<ClipboardItem> create(ClipboardItem item) async {
    try {
      item = item.copyWith(modified: now())..applyId(item);
      final encrypted = await item.encrypt();
      final result = await remote.create(encrypted);
      final clip = item.copyWith(
        serverId: result.serverId,
        lastSynced: result.lastSynced,
      )..applyId(result);
      return Right(clip);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<PaginatedResult<ClipboardItem>> getList({
    int limit = 50,
    int offset = 0,
    String? search,
    Set<TextCategory>? category,
    Set<ClipItemType>? types,
    int? collectionId,
    ClipboardSortKey? sortBy,
    SortOrder order = SortOrder.desc,
    DateTime? from,
    DateTime? to,
    bool? encrypted,
  }) async {
    try {
      final result = await remote.getList(
        limit: limit,
        offset: offset,
        collectionId: collectionId,
        sortBy: sortBy,
        order: order,
        search: search,
        types: types,
        textCategories: category,
        from: from,
        to: to,
      );
      final decryptedItems = await Future.wait(
        result.results.map(
          (e) => e.decrypt(),
        ),
      );

      return Right(
        PaginatedResult(
          results: decryptedItems,
          hasMore: result.hasMore,
        ),
      );
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<ClipboardItem> update(ClipboardItem item) async {
    try {
      item = item.copyWith(modified: now())..applyId(item);
      final encrypted = await item.encrypt();
      final result = await remote.update(encrypted);
      final clip = item.copyWith(
        lastSynced: now(),
      )..applyId(result);
      return Right(clip);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<bool> delete(ClipboardItem item) async {
    try {
      await remote.delete(item);
      return const Right(true);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<void> deleteAll() async {
    // no-op
    return const Right(null);
  }

  @override
  FailureOr<ClipboardItem?> get({int? id, int? serverId}) async {
    try {
      final result = await remote.get(serverId: serverId);
      final decrypted = await result?.decrypt();
      return Right(decrypted);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<ClipboardItem?> getLatestFromOthers({bool? synced}) {
    throw UnimplementedError();
  }

  @override
  FailureOr<int> fetchEncryptedCount() {
    throw UnimplementedError();
  }

  @override
  FailureOr<List<ClipboardItem>> deleteMany(List<ClipboardItem> items) async {
    try {
      final deleted = await remote.deleteMany(items);
      return Right(deleted);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<ClipboardItem> updateOrCreate(ClipboardItem item) {
    throw UnimplementedError();
  }

  @override
  FailureOr<void> deleteAllEncrypted() async {
    try {
      await remote.deleteAllEncrypted();
      return const Right(null);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<int> getClipCounts([DateTime? fromTs]) async {
    try {
      final count = await remote.getClipCounts(fromTs);
      return Right(count);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<List<ClipboardItem>> updateAll(List<ClipboardItem> items) async {
    try {
      final updates = await remote.updateAll(items);
      return Right(updates);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}

@Named("local")
@LazySingleton(as: ClipboardRepository)
class ClipboardRepositoryOfflineImpl implements ClipboardRepository {
  final ClipboardSource local;

  ClipboardRepositoryOfflineImpl(
    @Named("local") this.local,
  );

  @override
  FailureOr<ClipboardItem> create(ClipboardItem item) async {
    try {
      final result = await local.create(item);
      return Right(result);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<PaginatedResult<ClipboardItem>> getList({
    int limit = 50,
    int offset = 0,
    String? search,
    Set<TextCategory>? category,
    Set<ClipItemType>? types,
    int? collectionId,
    ClipboardSortKey? sortBy,
    SortOrder order = SortOrder.desc,
    DateTime? from,
    DateTime? to,
    bool? encrypted,
  }) async {
    try {
      final result = await local.getList(
        limit: limit,
        offset: offset,
        search: search,
        types: types,
        textCategories: category,
        collectionId: collectionId,
        sortBy: sortBy,
        order: order,
        from: from,
        to: to,
        encrypted: encrypted,
      );

      return Right(result);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<ClipboardItem> update(ClipboardItem item) async {
    try {
      final result = await local.update(item);
      return Right(result);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<bool> delete(ClipboardItem item) async {
    try {
      await local.delete(item);
      return const Right(true);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<void> deleteAll() async {
    try {
      await local.deleteAll();
      return const Right(null);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<ClipboardItem?> get({int? id, int? serverId}) async {
    try {
      final result = await local.get(id: id, serverId: serverId);
      return Right(result);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<ClipboardItem?> getLatestFromOthers({bool? synced}) async {
    try {
      final result = await local.getLatestFromOthers(synced: synced);
      return Right(result);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<int> fetchEncryptedCount() async {
    try {
      final count = await local.fetchEncryptedCount();
      return Right(count);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<List<ClipboardItem>> deleteMany(List<ClipboardItem> items) async {
    try {
      final deleted = await local.deleteMany(items);
      return Right(deleted);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<ClipboardItem> updateOrCreate(ClipboardItem item) async {
    try {
      final result = await local.updateOrCreate(item);
      return Right(result);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<void> deleteAllEncrypted() async {
    // no-op
    return const Right(null);
  }

  @override
  FailureOr<int> getClipCounts([DateTime? fromTs]) async {
    try {
      final result = await local.getClipCounts();
      return Right(result);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<List<ClipboardItem>> updateAll(List<ClipboardItem> items) async {
    try {
      final result = await local.updateAll(items);
      return Right(result);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
