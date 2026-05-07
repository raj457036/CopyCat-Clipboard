import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/data/isar/adapters/isar_clipboard_item.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:easy_worker/easy_worker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart' show Platform;

void isarSyncingClipsInBackground(
  (List<ClipboardItem>, Map<int, int>) record,
  Sender send,
) async {
  final Isar db = Isar.getInstance(dbName)!;
  final collection = db.collection<IsarClipboardItem>();

  var (items, collectionMap) = record;

  // Phase 1: Single batch read — fetch all existing items by their serverIds
  // in ONE query, outside the write lock. This replaces N individual queries.
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

  // Phase 2: In-memory map for O(1) conflict-resolution lookups.
  final existingByServerId = <int, IsarClipboardItem>{
    for (final e in existingItems)
      if (e.serverId != null) e.serverId!: e,
  };

  final events = <ClipCrossSyncEvent>[];
  final now = systemTime();

  // Phase 3: Pure in-memory conflict resolution — zero DB reads.
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

  // Phase 4: Single write — no reads inside the write lock.
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

typedef ClipBatchSyncWokerPayload = (List<ClipboardItem>, Map<int, int>);

class ClipBatchSyncWorker {
  final _worker =
      EasyCompute<List<ClipCrossSyncEvent>, ClipBatchSyncWokerPayload>(
        ComputeEntrypoint(
          isarSyncingClipsInBackground,
          initData: {"token": ServicesBinding.rootIsolateToken},
          onInit: (payload) async {
            if (payload is Map) {
              final token = payload["token"];
              if (token != null) {
                BackgroundIsolateBinaryMessenger.ensureInitialized(token);
              }
              String? dbPath = Platform.environment[dbPathEnvKey];
              dbPath =
                  dbPath ?? (await getApplicationDocumentsDirectory()).path;
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

  Future<void> waitUntilReady() => _worker.waitUntilReady();

  Future<List<ClipCrossSyncEvent>> syncBatch(
    List<ClipboardItem> items,
    Map<int, int> collectionMapping,
  ) {
    return _worker.compute((items, collectionMapping));
  }
}
