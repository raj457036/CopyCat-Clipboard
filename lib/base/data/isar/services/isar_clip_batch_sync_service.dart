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

typedef _Payload = (List<ClipboardItem>, Map<int, int>);

/// Isolate entry point: resolves conflicts in-memory then writes in one
/// transaction. DB operations: 1 batch read + 1 batch write.
void _syncInBackground(_Payload record, Sender send) async {
  final Isar db = Isar.getInstance(dbName)!;
  final collection = db.collection<IsarClipboardItem>();

  var (items, collectionMap) = record;

  // Phase 1: one batch read, outside the write lock.
  final serverIds = items
      .map((e) => e.serverId)
      .whereType<int>()
      .toList(growable: false);

  final existingItems = serverIds.isEmpty
      ? <IsarClipboardItem>[]
      : collection
            .filter()
            .anyOf(serverIds, (q, id) => q.serverIdEqualTo(id))
            .findAllSync();

  // Phase 2: in-memory lookup map.
  final existingByServerId = <int, IsarClipboardItem>{
    for (final e in existingItems)
      if (e.serverId != null) e.serverId!: e,
  };

  final events = <ClipCrossSyncEvent>[];
  final now = systemTime();

  // Phase 3: in-memory conflict resolution
  for (var index = 0; index < items.length; index++) {
    var item = items[index];
    final collectionId = collectionMap[item.serverCollectionId];
    final found = item.serverId != null
        ? existingByServerId[item.serverId]
        : null;

    if (found == null) {
      item = item.copyWith(collectionId: collectionId, lastSynced: now);
      items[index] = item;
      events.add((CrossSyncEventType.create, item));
      continue;
    }

    // Conflict Resolution: Last-Modified-Wins
    if (item.modified.isAfter(found.modified)) {
      item = item.copyWith(
        id: found.isarId == Isar.autoIncrement ? null : found.isarId,
        lastSynced: now,
        localPath: found.localPath,
        collectionId: collectionId,
      );
    } else {
      item = found.toDomain().copyWith(lastSynced: now);
    }

    items[index] = item;
    events.add((CrossSyncEventType.update, item));
  }

  // Phase 4: one write — lock held only for inserts.
  db.writeTxnSync(() {
    final isarItems = items
        .map(IsarClipboardItem.fromDomain)
        .toList(growable: false);
    final ids = collection.putAllSync(isarItems);
    for (int i = 0; i < events.length; i++) {
      events[i] = (events[i].$1, events[i].$2.copyWith(id: ids[i]));
    }
  });

  send(events);
}

/// Isar-backed implementation of [ClipBatchSyncService].
///
/// Offloads Isar writes to a dedicated background isolate so the UI thread
/// is never blocked during large sync batches.
@LazySingleton(as: ClipBatchSyncService)
class IsarClipBatchSyncService implements ClipBatchSyncService {
  final _worker = EasyCompute<List<ClipCrossSyncEvent>, _Payload>(
    ComputeEntrypoint(
      _syncInBackground,
      initData: {"token": ServicesBinding.rootIsolateToken},
      onInit: (payload) async {
        if (payload is! Map) return;
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
