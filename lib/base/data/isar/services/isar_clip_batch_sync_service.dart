import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/data/isar/adapters/isar_clipboard_item.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/services/clip_batch_sync_service.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:easy_worker/easy_worker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart' show Platform;

/// Top-level function for the background isolate.
/// Must be top-level (not a closure) for isolate compatibility.
void _syncingClips(
  (List<ClipboardItem>, Map<int, int>) record,
  Sender send,
) async {
  final Isar db = Isar.getInstance(dbName)!;
  final collection = db.collection<IsarClipboardItem>();

  final events = <ClipCrossSyncEvent>[];
  var (items, collectionMap) = record;

  db.writeTxnSync(() {
    for (var index = 0; index < items.length; index++) {
      var item = items[index];
      final found = collection
          .filter()
          .serverIdEqualTo(item.serverId)
          .findFirstSync();
      final collectionId = collectionMap[item.serverCollectionId];
      if (found == null) {
        item = item.copyWith(
          collectionId: collectionId,
          lastSynced: now(),
        );
        items[index] = item;
        events.add((CrossSyncEventType.create, item));
        continue;
      }
      item = item.copyWith(
        id: found.isarId == Isar.autoIncrement ? null : found.isarId,
        lastSynced: now(),
        localPath: found.localPath,
        collectionId: collectionId,
      );
      items[index] = item;
      events.add((CrossSyncEventType.update, item));
    }

    final isarItems = items.map(IsarClipboardItem.fromDomain).toList();
    final ids = collection.putAllSync(isarItems);
    for (int i = 0; i < events.length; i++) {
      events[i] = (events[i].$1, events[i].$2.copyWith(id: ids[i]));
    }
  });

  send(events);
}

/// Isar-backed implementation of [ClipBatchSyncService].
///
/// Uses an [EasyCompute] background isolate worker to perform
/// batch sync operations without blocking the UI thread.
@LazySingleton(as: ClipBatchSyncService)
class IsarClipBatchSyncService implements ClipBatchSyncService {
  final _worker = EasyCompute<List<ClipCrossSyncEvent>,
      (List<ClipboardItem>, Map<int, int>)>(
    ComputeEntrypoint(
      _syncingClips,
      initData: {
        "token": ServicesBinding.rootIsolateToken,
      },
      onInit: (payload) async {
        if (payload is Map) {
          final token = payload["token"];
          if (token != null) {
            BackgroundIsolateBinaryMessenger.ensureInitialized(token);
          }
          String? dbPath = Platform.environment[dbPathEnvKey];
          dbPath = dbPath ?? (await getApplicationDocumentsDirectory()).path;
          Isar.openSync(
            [IsarClipboardItemSchema],
            directory: dbPath,
            relaxedDurability: true,
            inspector: kDebugMode,
            name: dbName,
          );
        }
      },
    ),
    workerName: "ClipSyncWorker",
  );

  @override
  Future<void> waitUntilReady() => _worker.waitUntilReady();

  @override
  Future<List<ClipCrossSyncEvent>> syncBatch(
    List<ClipboardItem> items,
    Map<int, int> collectionMapping,
  ) {
    return _worker.compute((items, collectionMapping));
  }
}
