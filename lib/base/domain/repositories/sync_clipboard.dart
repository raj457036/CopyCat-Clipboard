import 'package:clipboard/base/domain/model/clip_collection/clipcollection.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/paginated_results.dart';

abstract class SyncRepository {
  FailureOr<PaginatedResult<ClipCollection>> getLatestClipCollections({
    int limit = 100,
    DateTime? lastModified,
    String? excludeDeviceId,
  });

  FailureOr<PaginatedResult<ClipboardItem>> getLatestClipboardItems({
    int limit = 100,
    DateTime? lastModified,
    String? excludeDeviceId,
  });

  FailureOr<PaginatedResult<ClipboardItem>> getLatestCollectionClipboardItems({
    int limit = 100,
    DateTime? lastModified,
    String? excludeDeviceId,
  });

  FailureOr<PaginatedResult<ClipCollection>> getDeletedClipCollections({
    int limit = 100,
    DateTime? lastModified,
    String? excludeDeviceId,
    DateTime? lastSynced,
  });

  FailureOr<PaginatedResult<ClipboardItem>> getDeletedClipboardItems({
    int limit = 100,
    DateTime? lastModified,
    String? excludeDeviceId,
    DateTime? lastSynced,
  });
}
