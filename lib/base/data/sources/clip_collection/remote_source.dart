import 'package:clipboard/base/common/paginated_results.dart';
import 'package:clipboard/base/constants/strings.dart';
import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/db/clip_collection/clipcollection.dart';
import 'package:clipboard/base/domain/sources/clip_collection.dart';
import 'package:clipboard/base/utils/utility.dart';
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
    final result =
        await db.from(clipCollectionTable).insert(collection.toJson()).select();

    return collection.copyWith(
      serverId: result.first["id"],
      lastSynced: now(),
    )..applyId(collection);
  }

  @override
  Future<bool> delete(ClipCollection collection) async {
    if (collection.serverId == null || collection.userId == kLocalUserId) {
      return true;
    }

    collection = collection.copyWith(deletedAt: now(), modified: now());
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
    final updatedCollection = collection.copyWith(
      lastSynced: now(),
    )..applyId(collection);
    return updatedCollection;
  }

  @override
  Future<ClipCollection?> get({int? id, int? serverId}) async {
    if (serverId == null) return null;
    final result =
        await db.from(clipCollectionTable).select().eq("id", serverId);
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
  Future<List<ClipCollection>> deleteMany(List<ClipCollection> items) {
    throw UnimplementedError();
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
        .isFilter("deletedAt", null);
    return count;
  }
}
