import 'dart:async';

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

typedef _Payload = List<ClipboardItem>;

/// Isolate entry point: resolves conflicts in-memory then writes in one
/// transaction. DB operations: 1 batch read + 1 batch write.
Future<void> _syncInBackground(_Payload record, Sender send) async {
  debugPrint('[ClipSyncWorker] start: ${record.length} items');
  final Isar db = Isar.getInstance(dbName)!;
  final isarCollection = db.collection<IsarClipboardItem>();

  // Collapse incoming items so identical originId/serverId
  // items within the same batch are merged (latest modified wins) before processing.
  final collapsed = IsarClipBatchSyncService.collapseBatch(record);

  final items = collapsed.values.toList();
  if (items.isEmpty) {
    send(<ClipCrossSyncEvent>[]);
    return;
  }

  // Phase 1: batch read existing items. Prefer originId, with serverId fallback for older clips.
  final existingItems = await isarCollection.filter().anyOf(items, (q, item) {
    final hasOrigin = item.originId != null && item.originId!.isNotEmpty;
    if (hasOrigin && item.serverId != null) {
      return q
          .originIdEqualTo(item.originId!)
          .or()
          .serverIdEqualTo(item.serverId!);
    } else if (hasOrigin) {
      return q.originIdEqualTo(item.originId!);
    } else if (item.serverId != null) {
      return q.serverIdEqualTo(item.serverId!);
    }
    return q.isarIdEqualTo(-1);
  }).findAll();

  final existingById = <String, IsarClipboardItem>{};
  for (final e in existingItems) {
    if (e.originId != null && e.originId!.isNotEmpty) {
      existingById[e.originId!] = e;
    }
    if (e.serverId != null) existingById[e.serverId!.toString()] = e;
  }

  final events = <ClipCrossSyncEvent>[];
  final now = systemTime();

  debugPrint('[ClipSyncWorker] resolving conflicts for ${items.length} items');
  // Phase 2: in-memory conflict resolution
  for (var index = 0; index < items.length; index++) {
    var item = items[index];
    IsarClipboardItem? found;

    final hasOrigin = item.originId != null && item.originId!.isNotEmpty;
    if (hasOrigin && existingById.containsKey(item.originId!)) {
      found = existingById[item.originId!];
    } else if (item.serverId != null &&
        existingById.containsKey(item.serverId!.toString())) {
      found = existingById[item.serverId!.toString()];
    }

    if (found == null) {
      item = item.copyWith(lastSynced: now);
      items[index] = item;
      events.add((CrossSyncEventType.create, item));

      final placeholder = IsarClipboardItem.fromDomain(item);
      if (hasOrigin) {
        existingById[item.originId!] = placeholder;
      }
      if (item.serverId != null) {
        existingById[item.serverId!.toString()] = placeholder;
      }
      continue;
    }

    // Conflict Resolution: Last-Modified-Wins
    if (item.modified.isAfter(found.modified)) {
      item = item.copyWith(
        id: found.isarId == Isar.autoIncrement ? null : found.isarId,
        lastSynced: now,
        localPath: found.localPath,
        serverId: item.serverId ?? found.serverId,
        originId: item.originId ?? found.originId,
        sourceApp: found.sourceApp ?? item.sourceApp,
        sourceId: found.sourceId ?? item.sourceId,
      );
    } else {
      item = found.toDomain().copyWith(
        lastSynced: now,
        serverId: found.serverId ?? item.serverId,
        originId: found.originId ?? item.originId,
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

  /// Collapses incoming batch items so duplicates within the same batch are
  /// merged with last-modified-wins before touching the database.
  ///
  /// Prefers `originId` as the unique invariant key for new clips, falling back
  /// to `serverId` for legacy clips where `originId` is null.
  @visibleForTesting
  static Map<String, ClipboardItem> collapseBatch(
    Iterable<ClipboardItem> items,
  ) {
    final collapsed = <String, ClipboardItem>{};
    for (final item in items) {
      final hasOrigin = item.originId != null && item.originId!.isNotEmpty;
      final key = hasOrigin
          ? 'origin:${item.originId}'
          : (item.serverId != null ? 'server:${item.serverId}' : null);
      if (key == null) {
        collapsed['unique:${item.hashCode}_${systemTime().microsecondsSinceEpoch}'] =
            item;
        continue;
      }
      final existing = collapsed[key];
      if (existing == null || item.modified.isAfter(existing.modified)) {
        collapsed[key] = item;
      }
    }
    return collapsed;
  }
}
