// ignore_for_file: invalid_use_of_protected_member

import 'package:clipboard/base/db/clip_collection/clipcollection.dart';
import 'package:clipboard/base/db/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/sources/clip_collection.dart';
import 'package:clipboard/common/paginated_results.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';

@Named("local")
@LazySingleton(as: ClipCollectionSource)
class LocalClipCollectionSource implements ClipCollectionSource {
  final Isar db;
  final String deviceId;

  LocalClipCollectionSource(this.db, @Named("device_id") this.deviceId);

  @override
  Future<ClipCollection> create(ClipCollection collection) async {
    final id = await db.writeTxn(() => db.clipCollections.put(collection));
    collection.id = id;
    return collection;
  }

  @override
  Future<PaginatedResult<ClipCollection>> getList({
    int limit = 50,
    int offset = 0,
    String? search,
  }) async {
    List<ClipCollection> results;

    if (search == null) {
      results = await db.txn(() async => await db.clipCollections
          .where()
          .sortByCreatedDesc()
          .offset(offset)
          .limit(limit)
          .findAll());
    } else {
      results = await db.txn(() async {
        var filter = db.clipCollections.filter();

        for (final word in Isar.splitWords(search)) {
          filter = filter
              .titleWordsElementContains(word, caseSensitive: false)
              .or()
              .titleWordsElementStartsWith(word, caseSensitive: false)
              .or()
              .titleContains(word, caseSensitive: false)
              .or()
              .descriptionWordsElementContains(word, caseSensitive: false)
              .or()
              .descriptionWordsElementStartsWith(word, caseSensitive: false)
              .or()
              .descriptionContains(word, caseSensitive: false);
        }

        var query = filter
            .titleIsNotEmpty()
            .sortByCreatedDesc()
            .offset(offset)
            .limit(limit)
            .findAll();
        return query;
      });
    }

    return PaginatedResult(
      results: results,
      hasMore: results.length == limit,
    );
  }

  @override
  Future<ClipCollection> update(ClipCollection collection) async {
    final updated = collection.copyWith(
      modified: now(),
    )..applyId(collection);
    await db.writeTxn(
      () => db.clipCollections.put(updated),
    );
    return updated;
  }

  @override
  Future<List<ClipCollection>> updateMany(
    List<ClipCollection> collections,
  ) async {
    final updates = collections
        .map((collection) => collection.copyWith(
              modified: now(),
            )..applyId(collection))
        .toList();
    final ids = await db.writeTxn(
      () => db.clipCollections.putAll(updates),
    );

    for (var i = 0; i < ids.length; i++) {
      collections[i].id = ids[i];
    }
    return collections;
  }

  @override
  Future<bool> delete(ClipCollection collection) async {
    final result = await db.writeTxn(() async {
      final items = await db.clipboardItems
          .filter()
          .collectionIdEqualTo(collection.id)
          .findAll();
      final updates = items
          .map(
            (e) => e.copyWith(
              collectionId: null,
              modified: now(),
            )..applyId(e),
          )
          .toList();
      await db.clipboardItems.putAll(updates);
      await db.clipCollections.delete(collection.id);
    });
    return result;
  }

  @override
  Future<void> deleteAll() async {
    await db.writeTxn(() => db.clipCollections.clear());
  }

  @override
  Future<ClipCollection?> get({int? id, int? serverId}) async {
    if (serverId != null) {
      final result = await db.txn(() =>
          db.clipCollections.filter().serverIdEqualTo(serverId).findFirst());
      return result;
    }
    if (id != null) {
      final result = await db.txn(() => db.clipCollections.get(id));
      return result;
    }
    return null;
  }

  @override
  Future<ClipCollection> updateOrCreate(ClipCollection collection) async {
    if (collection.serverId != null) {
      final existingClip = await get(serverId: collection.serverId!);
      if (existingClip != null) {
        collection.id = existingClip.id;
        return update(collection);
      }
    }
    return create(collection);
  }

  @override
  Future<ClipCollection?> getLatestFromOthers({bool? synced}) async {
    final result = await db.txn(() {
      if (synced == true) {
        final q = db.clipCollections
            .filter()
            .not()
            .deviceIdEqualTo(deviceId)
            .and()
            .lastSyncedIsNotNull()
            .sortByLastSyncedDesc()
            .findFirst();
        return q;
      }
      final q = db.clipCollections
          .filter()
          .not()
          .deviceIdEqualTo(deviceId)
          .sortByModifiedDesc()
          .findFirst();
      return q;
    });
    return result;
  }

  @override
  Future<List<ClipCollection>> deleteMany(List<ClipCollection> items) async {
    final result = await db.writeTxn(() async {
      final q = db.clipCollections
          .filter()
          .anyOf(items, (q, item) => q.idEqualTo(item.id))
          .or()
          .anyOf(items, (q, item) => q.serverIdEqualTo(item.serverId));

      // Find all items to delete at once
      final deleted = await q.findAll();

      await q.deleteAll();

      return deleted;
    });
    return result;
  }

  @override
  Future<int> getCount() async {
    final count = await db.txn(() {
      return db.clipCollections.count();
    });
    return count;
  }
}
