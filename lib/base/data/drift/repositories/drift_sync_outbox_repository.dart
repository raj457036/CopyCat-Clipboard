import 'dart:async';
import 'package:clipboard/base/data/drift/drift_database.dart';
import 'package:clipboard/base/data/drift/tables/drift_sync_outbox_entry.dart';
import 'package:clipboard/base/domain/model/sync/sync_outbox_entry.dart';
import 'package:clipboard/base/domain/repositories/sync_outbox.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/utils/debounce.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@Named('drift')
@LazySingleton(as: SyncOutboxRepository)
class DriftSyncOutboxRepository implements SyncOutboxRepository {
  static const _logger = AppLogger.scoped('Drift Sync Outbox');
  final AppDatabase _db;

  DriftSyncOutboxRepository(this._db);

  final _newEntryController = StreamController<void>.broadcast();
  final _collectorDebouncer = Debouncer(
    milliseconds: Durations.medium3.inMilliseconds,
  );
  final _collector = <SyncOutboxEntry>[];

  final Set<String> _pendingEntityLocalIds = {};
  final Map<int, String> _idToEntityLocalKey = {};

  bool _initialized = false;

  String _key(String entityType, int localId) => '$entityType:$localId';

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    _initialized = true;
    final existing = await _db.select(_db.driftSyncOutboxEntryTable).get();
    for (final e in existing) {
      final key = _key(e.entityType, e.localId);
      _pendingEntityLocalIds.add(key);
      _idToEntityLocalKey[e.id] = key;
    }
    for (final e in _collector) {
      _pendingEntityLocalIds.add(_key(e.entityType, e.localId));
    }
  }

  @override
  Stream<void> get onNewEntry => _newEntryController.stream;

  @override
  Future<void> enqueue(SyncOutboxEntry entry) async {
    _logger.d(
      () => 'Enqueuing: ${entry.entityType} localId=${entry.localId} action=${entry.action}',
    );

    _collector.add(entry);
    _pendingEntityLocalIds.add(_key(entry.entityType, entry.localId));
    _collectorDebouncer(_flushCollector);
  }

  Future<void> _flushCollector() async {
    if (_collector.isEmpty) return;

    final entriesToAdd = _collapseEntries(_collector);
    _collector.clear();

    var persistedCount = 0;

    await _db.transaction(() async {
      for (final incoming in entriesToAdd) {
        final existingQuery = _db.select(_db.driftSyncOutboxEntryTable)
          ..where((tbl) => tbl.entityType.equals(incoming.entityType) & tbl.localId.equals(incoming.localId));
        final existing = await existingQuery.get();

        SyncOutboxEntry? merged = incoming;
        for (final old in existing) {
          if (merged == null) break;
          merged = _mergeEntries(DriftSyncOutboxEntryTable.toDomain(old), merged);
          _idToEntityLocalKey.remove(old.id);
        }

        if (existing.isNotEmpty) {
          final deleteQuery = _db.delete(_db.driftSyncOutboxEntryTable)
            ..where((tbl) => tbl.entityType.equals(incoming.entityType) & tbl.localId.equals(incoming.localId));
          await deleteQuery.go();
        }

        if (merged == null) {
          _pendingEntityLocalIds.remove(_key(incoming.entityType, incoming.localId));
          continue;
        }

        final companion = DriftSyncOutboxEntryTable.fromDomain(merged);
        final id = await _db.into(_db.driftSyncOutboxEntryTable).insert(companion);
        final key = _key(merged.entityType, merged.localId);
        _idToEntityLocalKey[id] = key;
        _pendingEntityLocalIds.add(key);
        persistedCount++;
      }
    });

    if (persistedCount > 0) {
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
      return null;
    }

    if (existing.action == SyncOutboxAction.create &&
        incoming.action == SyncOutboxAction.update) {
      return existing;
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
    final query = _db.select(_db.driftSyncOutboxEntryTable)
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.createdAt)])
      ..limit(limit);
    final results = await query.get();
    return results.map(DriftSyncOutboxEntryTable.toDomain).toList();
  }

  @override
  Future<void> markCompleted(int id) async {
    final entityLocalKey = _idToEntityLocalKey.remove(id);
    if (entityLocalKey != null) _pendingEntityLocalIds.remove(entityLocalKey);
    final query = _db.delete(_db.driftSyncOutboxEntryTable)..where((tbl) => tbl.id.equals(id));
    await query.go();
  }

  @override
  Future<void> removeByEntity(String entityType, int localId) async {
    final key = _key(entityType, localId);
    _pendingEntityLocalIds.remove(key);
    _idToEntityLocalKey.removeWhere((_, v) => v == key);
    final query = _db.delete(_db.driftSyncOutboxEntryTable)
      ..where((tbl) => tbl.entityType.equals(entityType) & tbl.localId.equals(localId));
    await query.go();
  }

  @override
  Future<void> clearAll() async {
    _pendingEntityLocalIds.clear();
    _idToEntityLocalKey.clear();
    _initialized = false;
    await _db.delete(_db.driftSyncOutboxEntryTable).go();
  }

  @override
  bool isLocalIdQueued(String entityType, int localId) {
    _ensureInitialized();
    return _pendingEntityLocalIds.contains(_key(entityType, localId));
  }
}
