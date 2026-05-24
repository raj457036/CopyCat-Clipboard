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
    final entriesToAdd = _collapseEntries(_collector);
    _collector.clear();

    var persistedCount = 0;

    await _db.writeTxn(() async {
      for (final incoming in entriesToAdd) {
        final existing = await _collection
            .filter()
            .entityTypeEqualTo(incoming.entityType)
            .and()
            .localIdEqualTo(incoming.localId)
            .findAll();

        SyncOutboxEntry? merged = incoming;
        for (final old in existing) {
          if (merged == null) break;
          merged = _mergeEntries(old.toDomain(), merged);
          _idToLocalId.remove(old.id);
        }

        if (existing.isNotEmpty) {
          await _collection.deleteAll(existing.map((e) => e.id).toList());
        }

        if (merged == null) {
          _pendingLocalIds.remove(incoming.localId);
          continue;
        }

        final isarEntry = IsarSyncOutboxEntry.fromDomain(merged);
        final id = await _collection.put(isarEntry);
        _idToLocalId[id] = merged.localId;
        _pendingLocalIds.add(merged.localId);
        persistedCount++;
      }
    });

    _logger.d(() => 'Flushed $persistedCount entries to Isar');
    if (persistedCount > 0) {
      _logger.d(() => 'Enqueued. Notifying stream listeners...');
      _newEntryController.add(null);
    }
  }

  List<SyncOutboxEntry> _collapseEntries(List<SyncOutboxEntry> entries) {
    final merged = <String, SyncOutboxEntry>{};

    for (final entry in entries) {
      final key = '${entry.entityType}:${entry.localId}';
      final existing = merged[key];
      if (existing == null) {
        merged[key] = entry;
        continue;
      }

      final next = _mergeEntries(existing, entry);
      if (next == null) {
        merged.remove(key);
      } else {
        merged[key] = next;
      }
    }

    return merged.values.toList(growable: false);
  }

  SyncOutboxEntry? _mergeEntries(
    SyncOutboxEntry existing,
    SyncOutboxEntry incoming,
  ) {
    if (existing.action == SyncOutboxAction.create &&
        incoming.action == SyncOutboxAction.delete) {
      return null; // Net no-op.
    }

    if (existing.action == SyncOutboxAction.create &&
        incoming.action == SyncOutboxAction.update) {
      return existing; // Keep create with oldest createdAt.
    }

    if (existing.action == SyncOutboxAction.update &&
        incoming.action == SyncOutboxAction.update) {
      return incoming.copyWith(createdAt: existing.createdAt);
    }

    if (existing.action == SyncOutboxAction.update &&
        incoming.action == SyncOutboxAction.delete) {
      return incoming.copyWith(createdAt: existing.createdAt);
    }

    if (existing.action == SyncOutboxAction.delete &&
        incoming.action == SyncOutboxAction.create) {
      // Treat as update on same local row after undelete-style mutation.
      return incoming.copyWith(
        action: SyncOutboxAction.update,
        createdAt: existing.createdAt,
      );
    }

    if (existing.action == SyncOutboxAction.delete &&
        incoming.action == SyncOutboxAction.update) {
      return incoming.copyWith(createdAt: existing.createdAt);
    }

    return incoming.copyWith(createdAt: existing.createdAt);
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
