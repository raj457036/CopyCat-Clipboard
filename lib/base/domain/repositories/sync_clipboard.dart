import 'package:clipboard/base/db/clip_collection/clipcollection.dart';
import 'package:clipboard/base/db/clipboard_item/clipboard_item.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/paginated_results.dart';

abstract class SyncRepository {
  FailureOr<PaginatedResult<ClipCollection>> getLatestClipCollections({
    int limit = 100,
    int offset = 0,
    String? excludeDeviceId,
    DateTime? lastSynced,
  });

  FailureOr<PaginatedResult<ClipboardItem>> getLatestClipboardItems({
    int limit = 100,
    int offset = 0,
    String? excludeDeviceId,
    DateTime? from,
    DateTime? lastSynced,
    bool havingCollection = false,
  });

  FailureOr<PaginatedResult<ClipCollection>> getDeletedClipCollections({
    int limit = 100,
    int offset = 0,
    String? excludeDeviceId,
    DateTime? lastSynced,
  });

  FailureOr<PaginatedResult<ClipboardItem>> getDeletedClipboardItems({
    int limit = 100,
    int offset = 0,
    String? excludeDeviceId,
    DateTime? lastSynced,
  });
}
