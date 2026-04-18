import 'dart:async';

import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
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
import 'package:synchronized/extension.dart';

/// Manages all registered [SyncEngine]s and coordinates the sync lifecycle.
///
/// This singleton orchestrator is responsible for:
/// - Enforcing dependency order (e.g. syncing collections before clips)
/// - Starting/stopping all engines together
/// - Periodically triggering the global outbox processor pipeline
/// - Adapting outbox processing speed based on sync mode (realtime vs balanced)
@singleton
class SyncOrchestrator {
  final Map<String, SyncEngine> _engines = {};
  final SyncOutboxRepository _outboxRepo;
  Timer? _outboxTimer;
  StreamSubscription? _outboxStreamSub;

  SyncOrchestrator(
    SyncAdapter<ClipboardItem> clipAdapter,
    SyncAdapter<ClipCollection> collectionAdapter,
    SyncCursorRepository cursorRepo,
    this._outboxRepo,
    SyncEventBus eventBus,
    @Named('device_id') String deviceId,
  ) {
    _bootstrapEngine(clipAdapter, cursorRepo, _outboxRepo, eventBus, deviceId);
    _bootstrapEngine(
      collectionAdapter,
      cursorRepo,
      _outboxRepo,
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

  /// Process the outbox with [synchronized] to ensure only one push
  /// operation runs at a time, preventing race conditions.
  Future<void> _processOutboxSynchronized() async {
    logger.i('[SyncOrch] _processOutboxSynchronized triggered');
    await synchronized(() async {
      logger.i('[SyncOrch] synchronized lock acquired, calling processOutboxes()');
      await processOutboxes();
      logger.i('[SyncOrch] processOutboxes() completed');
    });
  }

  /// Start scheduled tasks (polling, outbox) with the given [syncSpeed].
  ///
  /// - [SyncSpeed.realtime]: Subscribes to the outbox notification stream
  ///   for instant push on every new entry.
  /// - [SyncSpeed.balanced]: Polls the outbox every 10 seconds.
  void start({SyncSpeed syncSpeed = SyncSpeed.balanced}) {
    logger.i('[SyncOrch] start() called with syncSpeed=$syncSpeed');
    _startOutboxProcessor(syncSpeed);
    _startPolling();
  }

  /// Update the outbox processing mode without restarting polling/realtime pull.
  void updateSyncMode(SyncSpeed syncSpeed) {
    _startOutboxProcessor(syncSpeed);
  }

  /// Stop all scheduled tasks and realtime subscriptions.
  void stop() {
    _outboxTimer?.cancel();
    _outboxTimer = null;
    _outboxStreamSub?.cancel();
    _outboxStreamSub = null;

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

  void _startOutboxProcessor(SyncSpeed syncSpeed) {
    logger.i('[SyncOrch] _startOutboxProcessor: mode=$syncSpeed');
    // Cancel existing processors
    _outboxTimer?.cancel();
    _outboxTimer = null;
    _outboxStreamSub?.cancel();
    _outboxStreamSub = null;

    switch (syncSpeed) {
      case SyncSpeed.realtime:
        // Push instantly on every new outbox entry
        logger.i('[SyncOrch] Subscribing to outbox stream for realtime push');
        _outboxStreamSub = _outboxRepo.onNewEntry.listen(
          (_) {
            logger.i('[SyncOrch] Stream notification received! Triggering push...');
            _processOutboxSynchronized();
          },
        );
      case SyncSpeed.balanced:
        // Poll every 10 seconds
        logger.i('[SyncOrch] Starting 10s balanced timer');
        _outboxTimer = Timer.periodic(
          const Duration(seconds: 10),
          (_) {
            logger.i('[SyncOrch] 10s timer fired, triggering push...');
            _processOutboxSynchronized();
          },
        );
    }
  }
}
