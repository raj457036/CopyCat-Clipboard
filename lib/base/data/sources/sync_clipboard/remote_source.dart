import 'package:clipboard/base/domain/model/clip_collection/clipcollection.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/sources/sync_clipboard.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/common/paginated_results.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@Named("remote")
@LazySingleton(as: SyncClipboardSource)
class SyncClipboardSourceImpl implements SyncClipboardSource {
  static const _logger = AppLogger.scoped('SyncClipboardSource');

  final SupabaseClient client;
  final String clipboardItemsTable = "clipboard_items";
  final String clipCollectionsTable = "clip_collections";

  SyncClipboardSourceImpl(this.client);

  PostgrestClient get db => client.rest;

  String get _userId {
    final id = client.auth.currentUser?.id;
    if (id == null) {
      throw StateError('SyncClipboardSource used while unauthenticated');
    }
    return id;
  }

  Future<PaginatedResult<ClipboardItem>> _getLatestClipboardItems({
    int limit = 100,
    DateTime? lastModified,
    String? excludeDeviceId,
    required PostgrestFilterBuilder<List<Map<String, dynamic>>> query,
  }) async {
    if (lastModified != null) {
      query = query.gt("modified", lastModified.toUtc().toIso8601String());
    }

    if (excludeDeviceId != null && excludeDeviceId != "") {
      query = query.neq("deviceId", excludeDeviceId);
    }

    final docs = (await query.order("modified", ascending: true).limit(limit))
        .map(ClipboardItem.fromJson)
        .toList();

    _logger.d(() => "Fetched ${docs.length} clipboard items.");

    return PaginatedResult(results: docs, hasMore: docs.length >= limit);
  }

  @override
  Future<PaginatedResult<ClipboardItem>> getLatestClipboardItems({
    int limit = 100,
    DateTime? lastModified,
    String? excludeDeviceId,
  }) async {
    var query = db
        .from(clipboardItemsTable)
        .select()
        .eq("userId", _userId)
        .filter("collectionId", "is", null)
        .filter("deletedAt", "is", null);

    _logger.d(() => "Fetching latest clipboard items with no collections.");

    return await _getLatestClipboardItems(
      limit: limit,
      lastModified: lastModified,
      excludeDeviceId: excludeDeviceId,
      query: query,
    );
  }

  @override
  Future<PaginatedResult<ClipboardItem>> getLatestCollectionClipboardItems({
    int limit = 100,
    DateTime? lastModified,
    String? excludeDeviceId,
  }) async {
    var query = db
        .from(clipboardItemsTable)
        .select()
        .eq("userId", _userId)
        .not("collectionId", "is", null)
        .filter("deletedAt", "is", null);

    _logger.d(() => "Fetching latest clipboard items with collections.");

    return await _getLatestClipboardItems(
      limit: limit,
      lastModified: lastModified,
      excludeDeviceId: excludeDeviceId,
      query: query,
    );
  }

  @override
  Future<PaginatedResult<ClipCollection>> getLatestClipCollections({
    int limit = 100,
    DateTime? lastModified,
    String? excludeDeviceId,
  }) async {
    var query = db
        .from(clipCollectionsTable)
        .select()
        .eq("userId", _userId)
        .filter("deletedAt", "is", null);

    if (lastModified != null) {
      query = query.gt("modified", lastModified.toUtc().toIso8601String());
    }
    if (excludeDeviceId != null && excludeDeviceId != "") {
      query = query.neq("deviceId", excludeDeviceId);
    }
    final docs = await query.order("modified", ascending: true).limit(limit);
    final collections = docs
        .map((e) => ClipCollection.fromJson(e))
        .map((e) => e.copyWith(lastSynced: systemTime()))
        .toList();
    _logger.d(() => "Fetched ${collections.length} clip collections.");
    return PaginatedResult(
      results: collections,
      hasMore: collections.length >= limit,
    );
  }

  @override
  Future<PaginatedResult<ClipboardItem>> getDeletedClipboardItems({
    int limit = 100,
    DateTime? lastModified,
    String? excludeDeviceId,
    DateTime? lastSynced,
  }) async {
    if (lastSynced == null) return PaginatedResult.empty();
    final isoDate = lastSynced
        .subtract(const Duration(seconds: 5))
        .toUtc()
        .toIso8601String();
    var query = db
        .from(clipboardItemsTable)
        .select()
        .eq("userId", _userId)
        .gte("deletedAt", isoDate);

    if (lastModified != null) {
      query = query.gt("modified", lastModified.toUtc().toIso8601String());
    }
    if (excludeDeviceId != null && excludeDeviceId != "") {
      query = query.neq("deviceId", excludeDeviceId);
    }
    final docs = await query.order("modified", ascending: true).limit(limit);
    final deletedClips = docs.map((e) => ClipboardItem.fromJson(e)).toList();
    _logger.d(() => "Fetched ${deletedClips.length} deleted clipboard items.");
    return PaginatedResult(
      results: deletedClips,
      hasMore: deletedClips.length >= limit,
    );
  }

  @override
  Future<PaginatedResult<ClipCollection>> getDeletedClipCollections({
    int limit = 100,
    DateTime? lastModified,
    String? excludeDeviceId,
    DateTime? lastSynced,
  }) async {
    if (lastSynced == null) return PaginatedResult.empty();

    final isoDate = lastSynced
        .subtract(const Duration(seconds: 5))
        .toUtc()
        .toIso8601String();
    var query = db
        .from(clipCollectionsTable)
        .select()
        .eq("userId", _userId)
        .gte("deletedAt", isoDate);

    if (lastModified != null) {
      query = query.gt("modified", lastModified.toUtc().toIso8601String());
    }
    if (excludeDeviceId != null && excludeDeviceId != "") {
      query = query.neq("deviceId", excludeDeviceId);
    }
    final docs = await query.order("modified", ascending: true).limit(limit);
    final deletedCollections = docs
        .map((e) => ClipCollection.fromJson(e))
        .toList();
    _logger.d(
      () => "Fetched ${deletedCollections.length} deleted clip collections.",
    );
    return PaginatedResult(
      results: deletedCollections,
      hasMore: deletedCollections.length >= limit,
    );
  }
}
