// ignore_for_file: invalid_use_of_protected_member

import 'package:clipboard/base/data/isar/adapters/isar_clip_collection.dart';
import 'package:clipboard/base/data/isar/adapters/isar_clipboard_item.dart';
import 'package:clipboard/base/domain/model/clip_collection/clipcollection.dart';
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

  IsarCollection<IsarClipCollection> get _collection =>
      db.collection<IsarClipCollection>();

  IsarCollection<IsarClipboardItem> get _clipboardItems =>
      db.collection<IsarClipboardItem>();

  @override
  Future<ClipCollection> create(ClipCollection collection) async {
    final isarItem = IsarClipCollection.fromDomain(collection);
    final id = await db.writeTxn(() => _collection.put(isarItem));
    return collection.copyWith(id: id);
  }

  @override
  Future<PaginatedResult<ClipCollection>> getList({
    int limit = 50,
    int offset = 0,
    String? search,
  }) async {
    List<IsarClipCollection> isarResults;

    if (search == null) {
      isarResults = await db.txn(
        () async => await _collection
            .filter()
            .deletedAtIsNull()
            .sortByCreatedDesc()
            .offset(offset)
            .limit(limit)
            .findAll(),
      );
    } else {
      isarResults = await db.txn(() async {
        var filter = _collection.filter();

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
            .deletedAtIsNull()
            .titleIsNotEmpty()
            .sortByCreatedDesc()
            .offset(offset)
            .limit(limit)
            .findAll();
        return query;
      });
    }

    final results = isarResults.map((e) => e.toDomain()).toList();
    return PaginatedResult(results: results, hasMore: results.length == limit);
  }

  @override
  Future<ClipCollection> update(ClipCollection collection) async {
    final isarItem = IsarClipCollection.fromDomain(collection);
    await db.writeTxn(() => _collection.put(isarItem));
    return collection;
  }

  @override
  Future<List<ClipCollection>> updateMany(
    List<ClipCollection> collections,
  ) async {
    final isarItems = collections.map(IsarClipCollection.fromDomain).toList();
    final ids = await db.writeTxn(() => _collection.putAll(isarItems));

    return [
      for (var i = 0; i < ids.length; i++) collections[i].copyWith(id: ids[i]),
    ];
  }

  @override
  Future<bool> delete(ClipCollection collection, {bool soft = true}) async {
    if (collection.id == null) return false;
    final result = await db.writeTxn(() async {
      final items = await _clipboardItems
          .filter()
          .collectionIdEqualTo(collection.id)
          .findAll();
      final updatedItems = items.map((e) {
        final domain = e.toDomain();
        return IsarClipboardItem.fromDomain(
          domain.copyWith(collectionId: null, modified: systemTime()),
        );
      }).toList();
      await _clipboardItems.putAll(updatedItems);
      if (soft) {
        await _collection.put(
          IsarClipCollection.fromDomain(
            collection.copyWith(
              deletedAt: systemTime(),
              modified: systemTime(),
            ),
          ),
        );
      } else {
        await _collection.delete(collection.id!);
      }
      return true;
    });
    return result;
  }

  @override
  Future<void> deleteAll() async {
    await db.writeTxn(() => _collection.clear());
  }

  @override
  Future<ClipCollection?> get({int? id, int? serverId}) async {
    if (serverId != null) {
      final result = await db.txn(
        () => _collection.filter().serverIdEqualTo(serverId).findFirst(),
      );
      return result?.toDomain();
    }
    if (id != null) {
      final result = await db.txn(() => _collection.get(id));
      return result?.toDomain();
    }
    return null;
  }

  @override
  Future<ClipCollection> updateOrCreate(ClipCollection collection) async {
    if (collection.serverId != null) {
      final existingClip = await get(serverId: collection.serverId!);
      if (existingClip != null) {
        return update(collection.copyWith(id: existingClip.id));
      }
    }
    return create(collection);
  }

  @override
  Future<ClipCollection?> getLatestFromOthers({bool? synced}) async {
    final result = await db.txn(() {
      if (synced == true) {
        final q = _collection
            .filter()
            .not()
            .deviceIdEqualTo(deviceId)
            .and()
            .lastSyncedIsNotNull()
            .sortByLastSyncedDesc()
            .findFirst();
        return q;
      }
      final q = _collection
          .filter()
          .not()
          .deviceIdEqualTo(deviceId)
          .sortByModifiedDesc()
          .findFirst();
      return q;
    });
    return result?.toDomain();
  }

  @override
  Future<List<ClipCollection>> deleteMany(
    List<ClipCollection> items, {
    bool soft = true,
  }) async {
    final result = await db.writeTxn(() async {
      final q = _collection
          .filter()
          .anyOf(
            items,
            (q, item) => item.id != null
                ? q.isarIdEqualTo(item.id!)
                : q.isarIdEqualTo(-1),
          )
          .or()
          .anyOf(items, (q, item) => q.serverIdEqualTo(item.serverId));

      // Find all items to delete at once
      final deleted = await q.findAll();

      if (soft) {
        final now = systemTime();
        final updated = deleted
            .map(
              (c) => IsarClipCollection.fromDomain(
                c.toDomain().copyWith(deletedAt: now, modified: now),
              ),
            )
            .toList();
        await _collection.putAll(updated);
      } else {
        await q.deleteAll();
      }

      return deleted.map((e) => e.toDomain()).toList();
    });
    return result;
  }

  @override
  Future<int> getCount() async {
    final count = await db.txn(() {
      return _collection.count();
    });
    return count;
  }
}
