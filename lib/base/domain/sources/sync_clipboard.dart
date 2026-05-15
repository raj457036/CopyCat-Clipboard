import 'package:clipboard/base/domain/model/clip_collection/clipcollection.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/common/paginated_results.dart';

abstract class SyncClipboardSource {
  /// Fetches collections
  Future<PaginatedResult<ClipCollection>> getLatestClipCollections({
    int limit = 100,
    int offset = 0,
    String? excludeDeviceId,
    DateTime? lastSynced,
  });

  /// Fetches clipboard items without collection.
  Future<PaginatedResult<ClipboardItem>> getLatestClipboardItems({
    int limit = 100,
    int offset = 0,
    String? excludeDeviceId,
    DateTime? lastSynced,
  });

  /// Fetches clipboard items that belong to collections.
  Future<PaginatedResult<ClipboardItem>> getLatestCollectionClipboardItems({
    int limit = 100,
    int offset = 0,
    String? excludeDeviceId,
    DateTime? lastSynced,
  });

  /// Fetches deleted collections.
  Future<PaginatedResult<ClipCollection>> getDeletedClipCollections({
    int limit = 100,
    int offset = 0,
    String? excludeDeviceId,
    DateTime? lastSynced,
  });

  /// Fetches deleted clipboard items.
  Future<PaginatedResult<ClipboardItem>> getDeletedClipboardItems({
    int limit = 100,
    int offset = 0,
    String? excludeDeviceId,
    DateTime? lastSynced,
  });
}
