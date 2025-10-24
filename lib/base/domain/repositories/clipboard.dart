import 'package:clipboard/base/db/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/sources/clipboard.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/base/enums/sort.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/paginated_results.dart';

abstract class ClipboardRepository {
  FailureOr<ClipboardItem?> get({int? id, int? serverId});
  FailureOr<ClipboardItem> create(ClipboardItem item);

  FailureOr<PaginatedResult<ClipboardItem>> getList({
    int limit = 50,
    int offset = 0,
    String? search,
    Set<TextCategory>? category,
    Set<ClipItemType>? types,
    int? collectionId,
    ClipboardSortKey? sortBy,
    SortOrder order = SortOrder.desc,
    DateTime? from,
    DateTime? to,
    bool? encrypted,
  });

  FailureOr<ClipboardItem> update(ClipboardItem item);
  FailureOr<List<ClipboardItem>> updateAll(List<ClipboardItem> items);
  FailureOr<ClipboardItem> updateOrCreate(ClipboardItem item);

  FailureOr<bool> delete(ClipboardItem item);
  FailureOr<List<ClipboardItem>> deleteMany(List<ClipboardItem> items);

  FailureOr<void> deleteAll();

  FailureOr<ClipboardItem?> getLatestFromOthers({bool? synced});

  FailureOr<int> fetchEncryptedCount();

  FailureOr<void> deleteAllEncrypted();

  FailureOr<int> getClipCounts([DateTime? fromTs]);
}
