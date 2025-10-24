import 'package:clipboard/base/db/clip_collection/clipcollection.dart';
import 'package:clipboard/common/paginated_results.dart';

abstract class ClipCollectionSource {
  Future<ClipCollection?> get({int? id, int? serverId});
  Future<ClipCollection> create(ClipCollection collection);

  Future<PaginatedResult<ClipCollection>> getList({
    int limit = 50,
    int offset = 0,
    String? search,
  });

  Future<ClipCollection> update(ClipCollection collection);
  Future<List<ClipCollection>> updateMany(List<ClipCollection> collections);
  Future<ClipCollection> updateOrCreate(ClipCollection collection);
  Future<ClipCollection?> getLatestFromOthers({bool? synced});

  Future<bool> delete(ClipCollection collection);
  Future<List<ClipCollection>> deleteMany(List<ClipCollection> items);

  Future<void> deleteAll();

  Future<int> getCount();
}
