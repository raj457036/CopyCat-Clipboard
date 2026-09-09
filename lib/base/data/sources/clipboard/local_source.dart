// ignore_for_file: invalid_use_of_protected_member

import 'package:clipboard/base/data/isar/adapters/isar_clipboard_item.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/repositories/sync_outbox.dart';
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
  static const _logger = AppLogger.scoped('Local Clipboard Source');

  final Isar db;
  final String deviceId;
  final SyncOutboxRepository outbox;

  LocalClipboardSource(this.db, @Named('device_id') this.deviceId, this.outbox);

  IsarCollection<IsarClipboardItem> get _collection =>
      db.collection<IsarClipboardItem>();

  static List<String> _toSearchTokens(String? value) {
    if (value == null || value.trim().isEmpty) return const [];
    return Isar.splitWords(
      value.toLowerCase(),
    ).where((word) => word.length > 2).toSet().toList();
  }

  @override
  Future<ClipboardItem> create(ClipboardItem item) async {
    final isarItem = IsarClipboardItem.fromDomain(item);
    final id = await db.writeTxn(() => _collection.put(isarItem));
    return item.copyWith(id: id);
  }

  @override
  Future<PaginatedResult<ClipboardItem>> getList({
    int limit = 50,
    int offset = 0,
    String? search,
    Set<TextCategory>? textCategories,
    Set<ClipItemType>? types,
    int? collectionId,
    int? serverCollectionId,
    ClipboardSortKey? sortBy,
    SortOrder order = SortOrder.desc,
    DateTime? from,
    DateTime? to,
    bool? encrypted,
  }) async {
    QueryBuilder<IsarClipboardItem, IsarClipboardItem, QFilterCondition>
    resultsQuery;

    final searchTokens = _toSearchTokens(search);
    final hasCollectionFilter =
        collectionId != null || serverCollectionId != null;

    if (searchTokens.isEmpty && !hasCollectionFilter) {
      resultsQuery = _collection.filter();
    } else {
      resultsQuery = _collection.filter();

      if (serverCollectionId != null && collectionId != null) {
        resultsQuery = resultsQuery.group(
          (q) => q
              .serverCollectionIdEqualTo(serverCollectionId)
              .or()
              .collectionIdEqualTo(collectionId),
        );
      } else if (serverCollectionId != null) {
        resultsQuery = resultsQuery.serverCollectionIdEqualTo(
          serverCollectionId,
        );
      } else if (collectionId != null) {
        resultsQuery = resultsQuery.collectionIdEqualTo(collectionId);
      }

      for (final token in searchTokens) {
        resultsQuery = resultsQuery.group(
          (q) => q
              .searchTokensElementEqualTo(token, caseSensitive: false)
              .or()
              .searchTokensElementStartsWith(token, caseSensitive: false)
              .or()
              .searchTokensElementEndsWith(token, caseSensitive: false),
        );
      }
    }

    if (encrypted != null) {
      resultsQuery = resultsQuery
          .encryptedEqualTo(encrypted)
          .lockedEqualTo(false);
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

    QueryBuilder<IsarClipboardItem, IsarClipboardItem, QAfterSortBy>
    sortedQuery;

    switch (sortBy) {
      case ClipboardSortKey.modified:
        sortedQuery = order.isDesc
            ? query.sortByModifiedDesc()
            : query.sortByModified();

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
        sortedQuery = order.isDesc
            ? query.sortByCreatedDesc()
            : query.sortByCreated();
    }

    var paginatedQuery = sortedQuery.offset(offset).limit(limit).findAll();

    final isarResults = await db.txn(() async => await paginatedQuery);
    final results = isarResults.map((e) {
      final item = _toPreviewItem(e.toDomain());
      return item.id != null && outbox.isLocalIdQueued('clip', item.id!)
          ? item.copyWith(isQueued: true)
          : item;
    }).toList();

    return PaginatedResult(results: results, hasMore: results.length == limit);
  }

  /// Returns a memory-efficient preview of [item] for use in list views.
  ///
  /// For text items, [ClipboardItem.richData] is always stripped (can be
  /// several KB of RTF/HTML) and [ClipboardItem.text] is truncated to
  /// [_kTextPreviewLimit] characters when longer. When content is stripped the
  /// [ClipboardItem.previewOnly] flag is set so callers know to re-fetch the
  /// full item before copying/pasting.
  static const _kTextPreviewLimit = 300;

  ClipboardItem _toPreviewItem(ClipboardItem item) {
    if (item.type != ClipItemType.text) return item;
    final text = item.text;
    final hasRichData = item.richData != null;
    final isLongText = text != null && text.length > _kTextPreviewLimit;
    if (!hasRichData && !isLongText) return item;
    return item.copyWith(
      text: isLongText ? text.substring(0, _kTextPreviewLimit) : text,
      richData: null,
      previewOnly: true,
    );
  }

  @override
  Future<ClipboardItem> update(ClipboardItem item) async {
    final isarItem = IsarClipboardItem.fromDomain(item);

    await db.writeTxn(() => _collection.put(isarItem));

    return item;
  }

  @override
  Future<bool> delete(ClipboardItem item, {bool soft = true}) async {
    if (item.id == null) return false;

    if (soft) {
      _logger.i(() => "Soft deleting item with id ${item.id}");
      await update(item.copyWith(deletedAt: systemTime()));
      return true;
    }

    final result = await db.writeTxn(() => _collection.delete(item.id!));
    return result;
  }

  @override
  Future<List<ClipboardItem>> deleteMany(
    List<ClipboardItem> items, {
    bool soft = true,
  }) async {
    if (soft) {
      _logger.i(() => "Soft deleting ${items.length} items");
      await Future.wait(
        items.map((item) {
          return update(item.copyWith(deletedAt: systemTime()));
        }),
      );
      return items;
    }

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
          .anyOf(
            items,
            (q, item) =>
                q.serverIdEqualTo(item.serverId).and().serverIdIsNotNull(),
          );

      final clipsWithLocalCache = await q.localPathIsNotNull().findAll();

      // Delete cached media
      _logger.i(
        () => "Deleting ${clipsWithLocalCache.length} cached media files",
      );
      for (var isarItem in clipsWithLocalCache) {
        await isarItem.toDomain().cleanUp();
      }

      // Find all items to delete at once
      final deleted = await q.findAll();

      await q.deleteAll();

      return deleted.map((e) => e.toDomain()).toList();
    });
    return result;
  }

  @override
  Future<void> deleteAll({bool soft = true}) async {
    await db.writeTxn(() => _collection.clear());
  }

  @override
  Future<ClipboardItem?> get({int? id, int? serverId}) async {
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
  Future<ClipboardItem?> getLatestFromOthers({bool? synced}) async {
    final result = await db.txn(() {
      if (synced == true) {
        final q = _collection
            .filter()
            .not()
            .deviceIdEqualTo(deviceId)
            .and()
            .lastSyncedIsNotNull()
            .sortByLastSyncedDesc();
        return q.findFirst();
      }
      final q = _collection
          .filter()
          .not()
          .deviceIdEqualTo(deviceId)
          .sortByModifiedDesc();
      return q.findFirst();
    });
    return result?.toDomain();
  }

  @override
  Future<int> fetchEncryptedCount() async {
    final count = await db.txn(() async {
      return _collection
          .filter()
          .encryptedEqualTo(true)
          .lockedEqualTo(false)
          .count();
    });
    return count;
  }

  @override
  Future<(ClipboardItem, bool)> updateOrCreate(ClipboardItem item) async {
    final decryptedItem = item.locked ? item : await item.decrypt();
    final now = systemTime();

    return await db.writeTxn(() async {
      IsarClipboardItem? existingIsar;

      if (decryptedItem.originId != null &&
          decryptedItem.originId!.trim().isNotEmpty) {
        existingIsar = await _collection
            .where()
            .originIdEqualTo(decryptedItem.originId!)
            .findFirst();
      }

      if (existingIsar == null && decryptedItem.serverId != null) {
        existingIsar = await _collection
            .filter()
            .serverIdEqualTo(decryptedItem.serverId!)
            .findFirst();
      }

      if (existingIsar != null) {
        final existingClip = existingIsar.toDomain();
        final updated = existingClip.copyWith(
          localPath: decryptedItem.localPath ?? existingClip.localPath,
          text: decryptedItem.text ?? existingClip.text,
          richData: decryptedItem.richData ?? existingClip.richData,
          modified: decryptedItem.modified,
          lastSynced: now,
          serverId: decryptedItem.serverId ?? existingClip.serverId,
          originId: decryptedItem.originId ?? existingClip.originId,
          description: decryptedItem.description ?? existingClip.description,
          title: decryptedItem.title ?? existingClip.title,
          locked: decryptedItem.locked,
          encrypted: decryptedItem.encrypted,
          iv: decryptedItem.iv ?? existingClip.iv,
          encMode: decryptedItem.encMode ?? existingClip.encMode,
        );

        final isarItem = IsarClipboardItem.fromDomain(updated);
        await _collection.put(isarItem);

        if (updated.serverId != null) {
          await _pruneDuplicatesByServerId(
            serverId: updated.serverId!,
            keepIsarId: isarItem.isarId,
          );
        }

        return (updated, false);
      }

      final newItem = decryptedItem.copyWith(lastSynced: now);
      final isarItem = IsarClipboardItem.fromDomain(newItem);
      final id = await _collection.put(isarItem);
      return (newItem.copyWith(id: id), true);
    });
  }

  @override
  Future<void> deleteAllEncrypted() async {
    // no-op
  }

  @override
  Future<int> getClipCounts([DateTime? fromTs]) async {
    final count = await db.txn(() async {
      return _collection.count();
    });
    return count;
  }

  @override
  Future<List<ClipboardItem>> updateAll(List<ClipboardItem> items) async {
    final isarItems = items.map(IsarClipboardItem.fromDomain).toList();
    await db.writeTxn(() => _collection.putAll(isarItems));
    return items;
  }

  /// Prunes legacy orphan duplicate rows in Isar that share [serverId] but have
  /// a different local ID from [keepIsarId].
  Future<void> _pruneDuplicatesByServerId({
    required int serverId,
    required int keepIsarId,
  }) async {
    final duplicates = await _collection
        .filter()
        .serverIdEqualTo(serverId)
        .and()
        .not()
        .isarIdEqualTo(keepIsarId)
        .findAll();

    if (duplicates.isNotEmpty) {
      await _collection.deleteAll(
        duplicates.map((e) => e.isarId).toList(),
      );
    }
  }
}
