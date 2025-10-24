import 'package:clipboard/base/common/logging.dart';
import 'package:clipboard/base/common/paginated_results.dart';
import 'package:clipboard/base/db/clip_collection/clipcollection.dart';
import 'package:clipboard/base/db/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/sources/sync_clipboard.dart';
import 'package:clipboard/base/utils/utility.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@Named("remote")
@LazySingleton(as: SyncClipboardSource)
class SyncClipboardSourceImpl implements SyncClipboardSource {
  final SupabaseClient client;

  final String clipboardItemsTable = "clipboard_items";
  final String clipCollectionsTable = "clip_collections";

  SyncClipboardSourceImpl(this.client);

  PostgrestClient get db => client.rest;

  @override
  Future<PaginatedResult<ClipboardItem>> getLatestClipboardItems({
    int limit = 100,
    int offset = 0,
    String? excludeDeviceId,
    DateTime? from,
    DateTime? lastSynced,
    bool havingCollection = false,
  }) async {
    var query =
        db.from(clipboardItemsTable).select().isFilter("deletedAt", null);

    if (havingCollection) {
      query = query.not("collectionId", "is", "null");
    }
    if (from != null) {
      final isoDate = from.toUtc().toIso8601String();
      query = query.lt("modified", isoDate);
    }
    if (lastSynced != null) {
      final isoDate = lastSynced.toUtc().toIso8601String();
      query = query.gt("modified", isoDate);
    }

    if (excludeDeviceId != null && excludeDeviceId != "") {
      query = query.neq("deviceId", excludeDeviceId);
    }

    final docs = await query.order("modified").range(offset, offset + limit);
    final clips = await Future.wait(
        (docs.map((e) => ClipboardItem.fromJson(e)).map((e) async {
      try {
        return await e.decrypt();
      } catch (e_) {
        logger.e(e_);
        return e;
      }
    })).toList());
    return PaginatedResult(
      results: clips,
      hasMore: clips.length >= limit,
    );
  }

  @override
  Future<PaginatedResult<ClipCollection>> getLatestClipCollections({
    int limit = 100,
    int offset = 0,
    String? excludeDeviceId,
    DateTime? lastSynced,
  }) async {
    var query =
        db.from(clipCollectionsTable).select().isFilter("deletedAt", null);

    if (lastSynced != null) {
      final isoDate = lastSynced
          .subtract(const Duration(seconds: 5))
          .toUtc()
          .toIso8601String();
      query = query.gt(
        "modified",
        isoDate,
      );
    }
    if (excludeDeviceId != null && excludeDeviceId != "") {
      query = query.neq("deviceId", excludeDeviceId);
    }
    final docs = await query.order("modified").range(offset, offset + limit);
    final collections = docs
        .map((e) => ClipCollection.fromJson(e))
        .map((e) => e.copyWith(lastSynced: now()))
        .toList();
    return PaginatedResult(
      results: collections,
      hasMore: collections.length >= limit,
    );
  }

  @override
  Future<PaginatedResult<ClipboardItem>> getDeletedClipboardItems({
    int limit = 100,
    int offset = 0,
    String? excludeDeviceId,
    DateTime? lastSynced,
  }) async {
    if (lastSynced == null) return PaginatedResult.empty();
    final isoDate = lastSynced
        .subtract(const Duration(seconds: 5))
        .toUtc()
        .toIso8601String();
    var query = db.from(clipboardItemsTable).select().gte("deletedAt", isoDate);

    if (excludeDeviceId != null && excludeDeviceId != "") {
      query = query.neq("deviceId", excludeDeviceId);
    }
    final docs = await query.order("modified").range(offset, offset + limit);
    final deletedClips = docs.map((e) => ClipboardItem.fromJson(e)).toList();
    return PaginatedResult(
      results: deletedClips,
      hasMore: deletedClips.length >= limit,
    );
  }

  @override
  Future<PaginatedResult<ClipCollection>> getDeletedClipCollections({
    int limit = 100,
    int offset = 0,
    String? excludeDeviceId,
    DateTime? lastSynced,
  }) async {
    if (lastSynced == null) return PaginatedResult.empty();

    final isoDate = lastSynced
        .subtract(const Duration(seconds: 5))
        .toUtc()
        .toIso8601String();
    var query =
        db.from(clipCollectionsTable).select().gte("deletedAt", isoDate);

    if (excludeDeviceId != null && excludeDeviceId != "") {
      query = query.neq("deviceId", excludeDeviceId);
    }
    final docs = await query.order("modified").range(offset, offset + limit);
    final deletedCollections =
        docs.map((e) => ClipCollection.fromJson(e)).toList();
    return PaginatedResult(
      results: deletedCollections,
      hasMore: deletedCollections.length >= limit,
    );
  }
}
