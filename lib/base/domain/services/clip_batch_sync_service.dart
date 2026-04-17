import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';

/// Database-agnostic service for performing batch clipboard sync
/// operations in a background isolate.
///
/// Implementations handle the specifics of finding existing items,
/// merging incoming data, and persisting the batch — all within
/// a worker isolate for performance.
abstract class ClipBatchSyncService {
  /// Wait until the background worker is initialized and ready.
  Future<void> waitUntilReady();

  /// Sync a batch of clipboard items from the server.
  ///
  /// For each item in [items]:
  /// - If it already exists locally (matched by serverId), update it.
  /// - Otherwise, create it.
  ///
  /// [collectionMapping] maps server collection IDs to local collection IDs.
  ///
  /// Returns a list of [ClipCrossSyncEvent]s describing what happened
  /// (create vs update) for each item, with local IDs assigned.
  Future<List<ClipCrossSyncEvent>> syncBatch(
    List<ClipboardItem> items,
    Map<int, int> collectionMapping,
  );
}
