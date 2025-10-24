import 'package:clipboard/base/db/clip_collection/clipcollection.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/paginated_results.dart';

abstract class ClipCollectionRepository {
  FailureOr<ClipCollection?> get({int? id, int? serverId});
  FailureOr<ClipCollection> create(ClipCollection collection);

  FailureOr<PaginatedResult<ClipCollection>> getList({
    int limit = 50,
    int offset = 0,
    String? search,
    bool fromServer = false,
  });

  FailureOr<ClipCollection> update(ClipCollection collection);
  FailureOr<List<ClipCollection>> updateMany(List<ClipCollection> collections);
  FailureOr<ClipCollection> updateOrCreate(ClipCollection collection);
  FailureOr<ClipCollection?> getLatestFromOthers({bool? synced});

  FailureOr<bool> delete(ClipCollection collection);
  FailureOr<List<ClipCollection>> deleteMany(List<ClipCollection> items);

  FailureOr<void> deleteAll();

  FailureOr<int> getCount({bool local = true});
}
