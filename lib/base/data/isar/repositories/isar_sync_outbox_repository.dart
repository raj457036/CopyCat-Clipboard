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
  static const _logger = AppLogger.scoped('Sync Outbox');
  Isar get _db => Isar.getInstance(dbName)!;
  IsarCollection<IsarSyncOutboxEntry> get _collection =>
      _db.collection<IsarSyncOutboxEntry>();

  final _newEntryController = StreamController<void>.broadcast();
  final _collectorDebouncer = Debouncer(
    milliseconds: Durations.short4.inMilliseconds,
  );
  final _collector = <SyncOutboxEntry>[];

  /// In-memory index of pending local entity IDs for O(1) [isLocalIdQueued] lookup.
  final Set<int> _pendingLocalIds = {};

  /// Maps Isar outbox-entry IDs → local entity IDs so [markCompleted] can
  /// remove the right entry from [_pendingLocalIds] without an extra DB read.
  final Map<int, int> _idToLocalId = {};

  bool _initialized = false;

  /// Populates [_pendingLocalIds] and [_idToLocalId] from Isar synchronously
  /// (safe on the main isolate after the DB is open) plus any collector items
  /// that haven't been flushed yet. Called at most once.
  void _ensureInitialized() {
    if (_initialized) return;
    _initialized = true;
    final existing = _collection.where().findAllSync();
    for (final e in existing) {
      _pendingLocalIds.add(e.localId);
      _idToLocalId[e.id] = e.localId;
    }
    // Items sitting in the collector are pending but not yet in Isar.
    for (final e in _collector) {
      _pendingLocalIds.add(e.localId);
    }
  }

  @override
  Stream<void> get onNewEntry => _newEntryController.stream;

  @override
  Future<void> enqueue(SyncOutboxEntry entry) async {
    _logger.d(
      () =>
          'Enqueuing: ${entry.entityType} localId=${entry.localId} action=${entry.action}',
    );

    _collector.add(entry);
    _pendingLocalIds.add(entry.localId); // track immediately, before flush
    _logger.d(() => 'Added to collector. Collector size: ${_collector.length}');
    _collectorDebouncer(_flushCollector);
  }

  Future<void> _flushCollector() async {
    if (_collector.isEmpty) return;

    _logger.d(
      () => 'Flushing collector with ${_collector.length} entries to Isar',
    );
    final entriesToAdd = List<SyncOutboxEntry>.from(_collector);
    _collector.clear();

    final isarEntries = entriesToAdd
        .map((e) => IsarSyncOutboxEntry.fromDomain(e))
        .toList();

    await _db.writeTxn(() async {
      await _collection.putAll(isarEntries);
    });

    // After putAll the isarEntries have their auto-incremented IDs assigned.
    for (final e in isarEntries) {
      _idToLocalId[e.id] = e.localId;
    }

    _logger.d(() => 'Flushed ${isarEntries.length} entries to Isar');
    _logger.d(() => 'Enqueued. Notifying stream listeners...');
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
    final localId = _idToLocalId.remove(id);
    if (localId != null) _pendingLocalIds.remove(localId);
    await _db.writeTxn(() async {
      await _collection.delete(id);
    });
  }

  @override
  Future<void> removeByEntity(String entityType, int localId) async {
    _pendingLocalIds.remove(localId);
    _idToLocalId.removeWhere((_, v) => v == localId);
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
    _pendingLocalIds.clear();
    _idToLocalId.clear();
    _initialized = false;
    await _db.writeTxn(() async {
      await _collection.clear();
    });
  }

  @override
  bool isLocalIdQueued(int localId) {
    _ensureInitialized();
    return _pendingLocalIds.contains(localId);
  }
}
