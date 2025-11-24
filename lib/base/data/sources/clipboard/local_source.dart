// ignore_for_file: invalid_use_of_protected_member

import 'package:clipboard/base/db/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/sources/clipboard.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/base/enums/sort.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/common/paginated_results.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';

@Named("local")
@LazySingleton(as: ClipboardSource)
class LocalClipboardSource implements ClipboardSource {
  final Isar db;
  final String deviceId;

  LocalClipboardSource(this.db, @Named('device_id') this.deviceId);

  @override
  Future<ClipboardItem> create(ClipboardItem item) async {
    final id = await db.writeTxn(() => db.clipboardItems.put(item));
    item.id = id;
    return item;
  }

  @override
  Future<PaginatedResult<ClipboardItem>> getList({
    int limit = 50,
    int offset = 0,
    String? search,
    Set<TextCategory>? textCategories,
    Set<ClipItemType>? types,
    int? collectionId,
    ClipboardSortKey? sortBy,
    SortOrder order = SortOrder.desc,
    DateTime? from,
    DateTime? to,
    bool? encrypted,
  }) async {
    QueryBuilder<ClipboardItem, ClipboardItem, QFilterCondition> resultsQuery;

    if (search == null && collectionId == null) {
      resultsQuery = db.clipboardItems.filter();
    } else {
      resultsQuery = db.clipboardItems.filter();

      if (collectionId != null) {
        resultsQuery = resultsQuery.collectionIdEqualTo(collectionId);
      } else {
        resultsQuery = resultsQuery.encryptedEqualTo(false);
      }

      for (final word in Isar.splitWords(search ?? "")) {
        resultsQuery = resultsQuery.group((q) => q
            .titleContains(word, caseSensitive: false)
            .or()
            .descriptionContains(word, caseSensitive: false)
            .or()
            .urlContains(word, caseSensitive: false)
            .or()
            .textContains(word, caseSensitive: false)
            .or()
            .fileMimeTypeContains(word, caseSensitive: false));
      }
    }

    if (encrypted != null) {
      resultsQuery = resultsQuery.encryptedEqualTo(encrypted);
    }

    if (types != null) {
      resultsQuery = resultsQuery.anyOf(
        types,
        (q, type) => q.typeEqualTo(type),
      );
    }

    if (from != null && to != null) {
      resultsQuery = resultsQuery.createdBetween(from, to);
    } else if (from != null) {
      resultsQuery = resultsQuery.createdGreaterThan(from, include: true);
    } else if (to != null) {
      resultsQuery = resultsQuery.createdLessThan(to, include: true);
    }

    if (textCategories != null) {
      resultsQuery = resultsQuery.anyOf(
        textCategories,
        (q, category) => q.textCategoryEqualTo(category),
      );
    }

    var query = resultsQuery.deletedAtIsNull();

    QueryBuilder<ClipboardItem, ClipboardItem, QAfterSortBy> sortedQuery;

    switch (sortBy) {
      case ClipboardSortKey.modified:
        sortedQuery =
            order.isDesc ? query.sortByModifiedDesc() : query.sortByModified();

      case ClipboardSortKey.lastCopied:
        sortedQuery = order.isDesc
            ? query.sortByLastCopiedDesc()
            : query.sortByLastCopied();

      case ClipboardSortKey.copyCount:
        sortedQuery = order.isDesc
            ? query.sortByCopiedCountDesc()
            : query.sortByCopiedCount();

      case ClipboardSortKey.created:
      case _:
        sortedQuery =
            order.isDesc ? query.sortByCreatedDesc() : query.sortByCreated();
    }

    var paginatedQuery = sortedQuery.offset(offset).limit(limit).findAll();

    final results = await db.txn(() async => await paginatedQuery);

    return PaginatedResult(
      results: results,
      hasMore: results.length == limit,
    );
  }

  @override
  Future<ClipboardItem> update(ClipboardItem item) async {
    ClipboardItem updated = item.copyWith(
      modified: now(),
    )..applyId(item);

    await db.writeTxn(
      () => db.clipboardItems.put(updated),
    );

    updated.id = item.id;
    return updated;
  }

  @override
  Future<bool> delete(ClipboardItem item) async {
    final result = await db.writeTxn(() => db.clipboardItems.delete(item.id));
    return result;
  }

  @override
  Future<void> deleteAll() async {
    await db.writeTxn(() => db.clipboardItems.clear());
  }

  @override
  Future<ClipboardItem?> get({int? id, int? serverId}) async {
    if (serverId != null) {
      final result = await db.txn(() =>
          db.clipboardItems.filter().serverIdEqualTo(serverId).findFirst());
      return result;
    }
    if (id != null) {
      final result = await db.txn(() => db.clipboardItems.get(id));
      return result;
    }
    return null;
  }

  @override
  Future<ClipboardItem?> getLatestFromOthers({bool? synced}) async {
    final result = await db.txn(() {
      if (synced == true) {
        final q = db.clipboardItems
            .filter()
            .not()
            .deviceIdEqualTo(deviceId)
            .and()
            .lastSyncedIsNotNull()
            .sortByLastSyncedDesc();
        return q.findFirst();
      }
      final q = db.clipboardItems
          .filter()
          .not()
          .deviceIdEqualTo(deviceId)
          .sortByModifiedDesc();
      return q.findFirst();
    });
    return result;
  }

  @override
  Future<int> fetchEncryptedCount() async {
    final count = await db.txn(() async {
      return db.clipboardItems.filter().encryptedEqualTo(true).count();
    });
    return count;
  }

  @override
  Future<List<ClipboardItem>> deleteMany(List<ClipboardItem> items) async {
    final result = await db.writeTxn(() async {
      final q = db.clipboardItems
          .filter()
          .anyOf(items, (q, item) => q.idEqualTo(item.id))
          .or()
          .anyOf(
              items,
              (q, item) =>
                  q.serverIdEqualTo(item.serverId).and().serverIdIsNotNull());

      final clipsWithLocalCache = await q.localPathIsNotNull().findAll();

      // Delete cached media
      logger.i("Deleting Cached Media");
      for (var item in clipsWithLocalCache) {
        await item.cleanUp();
      }

      // Find all items to delete at once
      final deleted = await q.findAll();

      await q.deleteAll();

      return deleted;
    });
    return result;
  }

  @override
  Future<ClipboardItem> updateOrCreate(ClipboardItem item) async {
    item = item.copyWith(lastSynced: now());
    item = await item.decrypt();
    if (item.serverId != null) {
      final existingClip = await get(serverId: item.serverId!);
      if (existingClip != null) {
        item = item.copyWith(
          localPath: existingClip.localPath,
          localOnly: existingClip.localOnly,
        )..applyId(existingClip);
        return update(item);
      }
    }
    return create(item);
  }

  @override
  Future<void> deleteAllEncrypted() async {
    // no-op
  }

  @override
  Future<int> getClipCounts([DateTime? fromTs]) async {
    final count = await db.txn(() async {
      return db.clipboardItems.count();
    });
    return count;
  }

  @override
  Future<List<ClipboardItem>> updateAll(List<ClipboardItem> items) async {
    final updates = items
        .map((item) => item.copyWith(
              modified: now(),
            )..applyId(item))
        .toList();
    await db.writeTxn(
      () => db.clipboardItems.putAll(updates),
    );
    return updates;
  }
}
