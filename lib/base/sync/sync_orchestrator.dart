import 'dart:async';

import 'package:clipboard/base/domain/model/syncable.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/model/clip_collection/clipcollection.dart';
import 'package:clipboard/base/domain/repositories/sync_cursor.dart';
import 'package:clipboard/base/domain/repositories/sync_outbox.dart';
import 'package:clipboard/base/domain/services/conflict_resolver.dart';
import 'package:clipboard/base/domain/services/sync_adapter.dart';
import 'package:clipboard/base/domain/services/sync_event_bus.dart';
import 'package:clipboard/base/domain/model/sync/sync_config.dart';
import 'package:clipboard/base/sync/sync_engine.dart';
import 'package:clipboard/common/logging.dart';
import 'package:injectable/injectable.dart';

/// Manages all registered [SyncEngine]s and coordinates the sync lifecycle.
///
/// This singleton orchestrator is responsible for:
/// - Enforcing dependency order (e.g. syncing collections before clips)
/// - Starting/stopping all engines together
/// - Periodically triggering the global outbox processor pipeline
@singleton
class SyncOrchestrator {
  final Map<String, SyncEngine> _engines = {};
  Timer? _outboxTimer;

  SyncOrchestrator(
    SyncAdapter<ClipboardItem> clipAdapter,
    SyncAdapter<ClipCollection> collectionAdapter,
    SyncCursorRepository cursorRepo,
    SyncOutboxRepository outboxRepo,
    SyncEventBus eventBus,
    @Named('device_id') String deviceId,
  ) {
    _bootstrapEngine(clipAdapter, cursorRepo, outboxRepo, eventBus, deviceId);
    _bootstrapEngine(
      collectionAdapter,
      cursorRepo,
      outboxRepo,
      eventBus,
      deviceId,
    );
  }

  void _bootstrapEngine<T extends Syncable>(
    SyncAdapter<T> adapter,
    SyncCursorRepository cursorRepo,
    SyncOutboxRepository outboxRepo,
    SyncEventBus eventBus,
    String deviceId,
  ) {
    final engine = SyncEngine<T>(
      adapter: adapter,
      cursorRepo: cursorRepo,
      outboxRepo: outboxRepo,
      eventBus: eventBus,
      config: const SyncConfig(),
      conflictResolver: LastModifiedWinsResolver<T>(),
      deviceId: deviceId,
    );
    register(engine);
  }

  /// Register an engine.
  void register<T extends Syncable>(SyncEngine<T> engine) {
    _engines[engine.adapter.entityType] = engine;
  }

  /// Resolve dependency order of engines.
  List<SyncEngine> _getSortedEngines() {
    final sorted = <SyncEngine>[];
    final visited = <String>{};
    final visiting = <String>{};

    void visit(String entityType) {
      if (visited.contains(entityType)) return;
      if (visiting.contains(entityType)) {
        logger.e(
          "Circular dependency detected in sync adapters for: $entityType",
        );
        return;
      }

      visiting.add(entityType);

      final engine = _engines[entityType];
      if (engine != null) {
        for (final dep in engine.adapter.dependsOn) {
          visit(dep);
        }
        sorted.add(engine);
      }

      visiting.remove(entityType);
      visited.add(entityType);
    }

    for (final entityType in _engines.keys) {
      visit(entityType);
    }

    return sorted;
  }

  /// Triggers a full push and pull sync across all engines, respecting dependencies.
  Future<bool> syncAll({bool force = false, bool freshPull = false}) async {
    final sortedEngines = _getSortedEngines();

    for (final engine in sortedEngines) {
      await engine.processOutbox();
      final result = await engine.pull(force: force, freshPull: freshPull);
      if (result == SyncResult.failed) {
        logger.w(
          "Sync failed for ${engine.adapter.entityType}. Stopping cascade.",
        );
        return false;
      }
    }

    return true;
  }

  /// Triggers a push sync (outbox processing) across all engines.
  Future<void> processOutboxes() async {
    final sortedEngines = _getSortedEngines();
    for (final engine in sortedEngines) {
      await engine.processOutbox();
    }
  }

  /// Start scheduled tasks (polling, outbox).
  void start() {
    _startOutboxProcessor();
    _startPolling();
  }

  /// Stop all scheduled tasks and realtime subscriptions.
  void stop() {
    _outboxTimer?.cancel();
    _outboxTimer = null;

    for (final engine in _engines.values) {
      engine.stopPolling();
      engine.stopRealtime();
    }
  }

  void startRealtime() {
    for (final engine in _engines.values) {
      engine.startRealtime();
    }
  }

  void _startPolling() {
    for (final engine in _engines.values) {
      engine.startPolling();
    }
  }

  void _startOutboxProcessor() {
    _outboxTimer?.cancel();
    // Process outbox globally every 30 seconds
    _outboxTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => processOutboxes(),
    );
  }
}
