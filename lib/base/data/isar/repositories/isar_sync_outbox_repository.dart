import 'dart:async';

import 'package:clipboard/base/data/isar/adapters/isar_sync_outbox_entry.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/base/domain/model/sync/sync_outbox_entry.dart';
import 'package:clipboard/base/domain/repositories/sync_outbox.dart';
import 'package:clipboard/utils/debounce.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';
import 'package:clipboard/base/constants/strings/strings.dart';

@LazySingleton(as: SyncOutboxRepository)
class IsarSyncOutboxRepository implements SyncOutboxRepository {
  Isar get _db => Isar.getInstance(dbName)!;
  IsarCollection<IsarSyncOutboxEntry> get _collection =>
      _db.collection<IsarSyncOutboxEntry>();

  final _newEntryController = StreamController<void>.broadcast();
  final _collectorDebouncer = Debouncer(
    milliseconds: Durations.short4.inMilliseconds,
  );
  final _collector = <SyncOutboxEntry>[];

  @override
  Stream<void> get onNewEntry => _newEntryController.stream;

  @override
  Future<void> enqueue(SyncOutboxEntry entry) async {
    logger.i(
      '[Outbox] Enqueuing: ${entry.entityType} localId=${entry.localId} action=${entry.action}',
    );

    _collector.add(entry);
    logger.i(
      '[Outbox] Added to collector. Collector size: ${_collector.length}',
    );
    _collectorDebouncer(_flushCollector);
  }

  Future<void> _flushCollector() async {
    if (_collector.isEmpty) return;

    logger.i(
      '[Outbox] Flushing collector with ${_collector.length} entries to Isar',
    );
    final entriesToAdd = List<SyncOutboxEntry>.from(_collector);
    _collector.clear();

    final isarEntries = entriesToAdd
        .map((e) => IsarSyncOutboxEntry.fromDomain(e))
        .toList();

    await _db.writeTxn(() async {
      await _collection.putAll(isarEntries);
    });

    logger.i('[Outbox] Flushed ${isarEntries.length} entries to Isar');

    logger.i('[Outbox] Enqueued. Notifying stream listeners...');
    _newEntryController.add(null);
  }

  @override
  Future<List<SyncOutboxEntry>> getPending({int limit = 50}) async {
    final results = await _collection
        .where()
        .sortByCreatedAt()
        .limit(limit)
        .findAll();
    return results.map((e) => e.toDomain()).toList();
  }

  @override
  Future<void> markCompleted(int id) async {
    await _db.writeTxn(() async {
      await _collection.delete(id);
    });
  }

  @override
  Future<void> removeByEntity(String entityType, int localId) async {
    await _db.writeTxn(() async {
      await _collection
          .filter()
          .entityTypeEqualTo(entityType)
          .and()
          .localIdEqualTo(localId)
          .deleteAll();
    });
  }

  @override
  Future<void> clearAll() async {
    await _db.writeTxn(() async {
      await _collection.clear();
    });
  }
}
