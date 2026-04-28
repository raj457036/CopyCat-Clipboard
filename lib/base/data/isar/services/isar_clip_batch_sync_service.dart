import 'package:clipboard/base/background/clip_batch_sync_worker.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/services/clip_batch_sync_service.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:injectable/injectable.dart';

/// Isar-backed implementation of [ClipBatchSyncService].
///
/// Uses an [EasyCompute] background isolate worker to perform
/// batch sync operations without blocking the UI thread.
@LazySingleton(as: ClipBatchSyncService)
class IsarClipBatchSyncService implements ClipBatchSyncService {
  final _worker = ClipBatchSyncWorker();

  @override
  Future<void> waitUntilReady() => _worker.waitUntilReady();

  @override
  Future<List<ClipCrossSyncEvent>> syncBatch(
    List<ClipboardItem> items,
    Map<int, int> collectionMapping,
  ) {
    return _worker.syncBatch(items, collectionMapping);
  }
}
