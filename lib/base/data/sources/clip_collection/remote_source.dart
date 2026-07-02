import 'package:clipboard/base/constants/strings.dart';
import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/domain/model/clip_collection/clipcollection.dart';
import 'package:clipboard/base/domain/sources/clip_collection.dart';
import 'package:clipboard/common/paginated_results.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@Named("remote")
@LazySingleton(as: ClipCollectionSource)
class RemoteClipCollectionSource implements ClipCollectionSource {
  final SupabaseClient client;

  RemoteClipCollectionSource(this.client);

  PostgrestClient get db => client.rest;
  GoTrueClient get auth => client.auth;

  @override
  Future<ClipCollection> create(ClipCollection collection) async {
    if (auth.currentUser == null) return collection;
    final result = await db
        .from(clipCollectionTable)
        .insert(collection.toJson())
        .select();

    return collection.copyWith(
      serverId: result.first["id"],
      lastSynced: systemTime(),
    );
  }

  @override
  Future<bool> delete(ClipCollection collection, {bool soft = false}) async {
    if (collection.serverId == null || collection.userId == kLocalUserId) {
      return true;
    }

    // Remote delete always writes a tombstone update.
    collection = collection.copyWith(
      deletedAt: systemTime(),
      modified: systemTime(),
    );

    await db
        .from(clipCollectionTable)
        .update(collection.toJson())
        .eq("id", collection.serverId!);
    return true;
  }

  @override
  Future<void> deleteAll() {
    throw UnimplementedError();
  }

  @override
  Future<PaginatedResult<ClipCollection>> getList({
    int limit = 50,
    int offset = 0,

    /// no-op
    String? search,
  }) async {
    final items = await db
        .from(clipCollectionTable)
        .select()
        .order("modified")
        .range(offset, limit + offset);

    final clips = items.map((e) => ClipCollection.fromJson(e)).toList();

    return PaginatedResult(results: clips, hasMore: clips.length == limit);
  }

  @override
  Future<ClipCollection> update(ClipCollection collection) async {
    if (collection.serverId == null || collection.userId == kLocalUserId) {
      return collection;
    }
    final payload = collection.toJson();
    await db
        .from(clipCollectionTable)
        .update(payload)
        .eq("id", collection.serverId!);
    final updatedCollection = collection.copyWith(lastSynced: systemTime());
    return updatedCollection;
  }

  @override
  Future<ClipCollection?> get({int? id, int? serverId}) async {
    if (serverId == null) return null;
    final result = await db
        .from(clipCollectionTable)
        .select()
        .eq("id", serverId);
    if (result.isEmpty) return null;
    return ClipCollection.fromJson(result[0]);
  }

  @override
  Future<ClipCollection> updateOrCreate(ClipCollection collection) {
    throw UnimplementedError();
  }

  @override
  Future<ClipCollection?> getLatestFromOthers({bool? synced}) {
    throw UnimplementedError();
  }

  @override
  Future<List<ClipCollection>> deleteMany(
    List<ClipCollection> items, {
    bool soft = false,
  }) async {
    // Remote deleteMany always writes tombstone updates.
    final deduped = <int, ClipCollection>{};
    for (final item in items) {
      final serverId = item.serverId;
      if (serverId == null || item.userId == kLocalUserId) continue;
      deduped[serverId] = item;
    }

    final items_ = deduped.values.map((item) {
      final json = item
          .copyWith(deletedAt: systemTime(), modified: systemTime())
          .toJson();
      return {...json, "id": item.serverId};
    }).toList();
    await db.from(clipCollectionTable).upsert(items_);
    return items;
  }

  @override
  Future<List<ClipCollection>> updateMany(List<ClipCollection> collections) {
    throw UnimplementedError();
  }

  @override
  Future<int> getCount() async {
    final count = await db
        .from(clipCollectionTable)
        .count(CountOption.exact)
        .filter("deletedAt", "is", null);
    return count;
  }
}
