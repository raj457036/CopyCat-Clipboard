import 'dart:async';

import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/data/isar/adapters/isar_clip_collection.dart';
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

typedef _Payload = List<ClipboardItem>;

/// Isolate entry point: resolves conflicts in-memory then writes in one
/// transaction. DB operations: 1 batch read + 1 batch write.
Future<void> _syncInBackground(_Payload record, Sender send) async {
  debugPrint('[ClipSyncWorker] start: ${record.length} items');
  final Isar db = Isar.getInstance(dbName)!;
  final isarCollection = db.collection<IsarClipboardItem>();

  final items = List<ClipboardItem>.from(record);

  // Phase 1: batch read by serverId.
  final serverIds = items
      .map((e) => e.serverId)
      .whereType<int>()
      .toList(growable: false);

  final originIds = items
      .map((e) => e.originId)
      .whereType<String>()
      .toList(growable: false);

  final existingItems = serverIds.isEmpty
      ? <IsarClipboardItem>[]
      : await isarCollection
            .filter()
            .anyOf(serverIds, (q, id) => q.serverIdEqualTo(id))
            .or()
            .anyOf(originIds, (q, id) => q.originIdEqualTo(id))
            .findAll();

  final existingById = <String, IsarClipboardItem>{
    for (final e in existingItems)
      if (e.serverId != null)
        e.serverId!.toString(): e
      else if (e.originId != null)
        e.originId!: e,
  };

  final events = <ClipCrossSyncEvent>[];
  final now = systemTime();

  debugPrint('[ClipSyncWorker] resolving conflicts for ${items.length} items');
  // Phase 2: in-memory conflict resolution
  for (var index = 0; index < items.length; index++) {
    var item = items[index];
    IsarClipboardItem? found;

    if (item.serverId != null &&
        existingById.containsKey(item.serverId!.toString())) {
      found = existingById[item.serverId!.toString()];
    } else if (item.originId != null &&
        existingById.containsKey(item.originId!)) {
      found = existingById[item.originId!];
    }

    if (found == null) {
      item = item.copyWith(lastSynced: now);
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
        sourceApp: found.sourceApp ?? item.sourceApp,
        sourceId: found.sourceId ?? item.sourceId,
      );
    } else {
      item = found.toDomain().copyWith(
        lastSynced: now,
        serverId: found.serverId ?? item.serverId,
        sourceApp: found.sourceApp ?? item.sourceApp,
        sourceId: found.sourceId ?? item.sourceId,
      );
    }

    items[index] = item;
    events.add((CrossSyncEventType.update, item));
  }

  debugPrint('[ClipSyncWorker] writing ${items.length} items to Isar');
  final isarItems = items
      .map(IsarClipboardItem.fromDomain)
      .toList(growable: false);

  List<int> ids = [];
  await db.writeTxn(() async {
    ids = await isarCollection.putAll(isarItems);
  }, silent: true);

  for (int i = 0; i < events.length; i++) {
    events[i] = (events[i].$1, events[i].$2.copyWith(id: ids[i]));
  }
  debugPrint('[ClipSyncWorker] done, sending ${events.length} events');
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
        await Isar.open(
          [IsarClipboardItemSchema],
          directory: dbPath,
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
  Future<List<ClipCrossSyncEvent>> syncBatch(List<ClipboardItem> items) async {
    return _worker.compute(List<ClipboardItem>.from(items));
  }
}
