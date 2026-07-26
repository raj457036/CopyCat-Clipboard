import 'dart:async';
import 'package:clipboard/base/data/drift/drift_database.dart';
import 'package:clipboard/base/data/drift/tables/drift_clipboard_item.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/services/clip_batch_sync_service.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

/// Drift-backed implementation of [ClipBatchSyncService].
@Named('drift')
@LazySingleton(as: ClipBatchSyncService)
class DriftClipBatchSyncService implements ClipBatchSyncService {
  final AppDatabase _db;

  DriftClipBatchSyncService(this._db);

  @override
  Future<void> waitUntilReady() async {
    // Database connection is managed via DI
  }

  @override
  Future<List<ClipCrossSyncEvent>> syncBatch(List<ClipboardItem> incomingItems) async {
    final items = List<ClipboardItem>.from(incomingItems);
    final events = <ClipCrossSyncEvent>[];
    final now = systemTime();

    final serverIds = items.map((e) => e.serverId).whereType<int>().toList(growable: false);
    final originIds = items.map((e) => e.originId).whereType<String>().toList(growable: false);

    final existingQuery = _db.select(_db.driftClipboardItemTable)
      ..where((tbl) => tbl.serverId.isIn(serverIds) | tbl.originId.isIn(originIds));
    final existingRecords = await existingQuery.get();

    final existingById = <String, DriftClipboardItemEntry>{
      for (final e in existingRecords)
        if (e.serverId != null)
          e.serverId!.toString(): e
        else if (e.originId != null)
          e.originId!: e,
    };

    final idsToReturn = <int>[];

    await _db.transaction(() async {
      for (var index = 0; index < items.length; index++) {
        var item = items[index];
        DriftClipboardItemEntry? found;

        if (item.serverId != null && existingById.containsKey(item.serverId!.toString())) {
          found = existingById[item.serverId!.toString()];
        } else if (item.originId != null && existingById.containsKey(item.originId!)) {
          found = existingById[item.originId!];
        }

        if (found == null) {
          item = item.copyWith(lastSynced: now);
          final companion = DriftClipboardItemTable.fromDomain(item);
          final newId = await _db.into(_db.driftClipboardItemTable).insert(companion);
          item = item.copyWith(id: newId);
          events.add((CrossSyncEventType.create, item));
          idsToReturn.add(newId);
          continue;
        }

        // Conflict Resolution: Last-Modified-Wins
        if (item.modified.isAfter(found.modified)) {
          item = item.copyWith(
            id: found.id,
            lastSynced: now,
            localPath: found.localPath,
            sourceApp: found.sourceApp ?? item.sourceApp,
            sourceId: found.sourceId ?? item.sourceId,
          );
        } else {
          item = DriftClipboardItemTable.toDomain(found).copyWith(
            lastSynced: now,
            serverId: found.serverId ?? item.serverId,
            sourceApp: found.sourceApp ?? item.sourceApp,
            sourceId: found.sourceId ?? item.sourceId,
          );
        }

        final companion = DriftClipboardItemTable.fromDomain(item);
        await _db.into(_db.driftClipboardItemTable).insertOnConflictUpdate(companion);
        events.add((CrossSyncEventType.update, item));
        idsToReturn.add(found.id);
      }
    });

    return events;
  }
}
