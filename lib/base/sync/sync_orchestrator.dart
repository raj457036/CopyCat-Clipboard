import 'dart:async';

import 'package:clipboard/base/constants/numbers/values.dart';
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
import 'package:clipboard/common/logging.dart' show AppLogger;
import 'package:clipboard/utils/utility.dart';
import 'package:injectable/injectable.dart';
import 'package:synchronized/extension.dart';
import 'package:synchronized/synchronized.dart' show Lock;

/// Manages all registered [SyncEngine]s and coordinates the sync lifecycle.
///
/// This singleton orchestrator is responsible for:
/// - Enforcing dependency order (e.g. syncing collections before clips)
/// - Starting/stopping all engines together
/// - Periodically triggering the global outbox processor pipeline
/// - Adapting outbox processing speed based on sync mode (realtime vs balanced)
@singleton
class SyncOrchestrator {
  static const _logger = AppLogger.scoped('SyncOrchestrator');
  final Map<String, SyncEngine> _engines = {};
  final SyncOutboxRepository _outboxRepo;
  Timer? _outboxTimer;
  StreamSubscription? _outboxStreamSub;

  bool _isRunning = false;

  bool get isRunning => _isRunning;

  SyncOrchestrator(
    @Named("non_collection_clips") SyncAdapter<ClipboardItem> clipAdapter,
    @Named("collection_clips") SyncAdapter<ClipboardItem> collectionClipAdapter,
    SyncAdapter<ClipCollection> collectionAdapter,
    SyncCursorRepository cursorRepo,
    this._outboxRepo,
    SyncEventBus eventBus,
    @Named('device_id') String deviceId,
  ) {
    _bootstrapEngine(
      clipAdapter,
      cursorRepo,
      _outboxRepo,
      eventBus,
      deviceId,
      config: const SyncConfig(freshPullOffsetEnabled: true),
      namespace: "clip",
    );

    final collectionEngine = _bootstrapEngine(
      collectionAdapter,
      cursorRepo,
      _outboxRepo,
      eventBus,
      deviceId,
      namespace: "collection",
    );

    _bootstrapEngine(
      collectionClipAdapter,
      cursorRepo,
      _outboxRepo,
      eventBus,
      deviceId,
      namespace: "collection-clip",
      dependsOn: [collectionEngine.identity],
    );
  }

  SyncEngine<T> _bootstrapEngine<T extends Syncable>(
    SyncAdapter<T> adapter,
    SyncCursorRepository cursorRepo,
    SyncOutboxRepository outboxRepo,
    SyncEventBus eventBus,
    String deviceId, {
    SyncConfig config = const SyncConfig(),
    String namespace = '',
    List<String> dependsOn = const [],
  }) {
    final engine = SyncEngine<T>(
      adapter: adapter,
      cursorRepo: cursorRepo,
      outboxRepo: outboxRepo,
      eventBus: eventBus,
      config: config,
      conflictResolver: LastModifiedWinsResolver<T>(),
      deviceId: deviceId,
      namespace: namespace,
      dependsOn: dependsOn,
    );
    register(engine);
    return engine;
  }

  /// Register an engine.
  void register<T extends Syncable>(SyncEngine<T> engine) {
    _engines[engine.identity] = engine;
  }

  /// Resolve dependency order of engines.
  List<SyncEngine> _getSortedEngines() {
    final sorted = <SyncEngine>[];
    final visited = <String>{};
    final visiting = <String>{};

    void visit(String engineId) {
      if (visited.contains(engineId)) return;
      if (visiting.contains(engineId)) {
        _logger.e(
          () =>
              "Circular dependency detected in sync adapters for engine: $engineId",
        );
        return;
      }

      visiting.add(engineId);

      final engine = _engines[engineId];
      if (engine != null) {
        for (final dep in engine.dependsOn) {
          visit(dep);
        }
        sorted.add(engine);
      }

      visiting.remove(engineId);
      visited.add(engineId);
    }

    for (final engine in _engines.values) {
      visit(engine.identity);
    }

    return sorted;
  }

  /// Triggers a full push and pull sync across all engines, respecting dependencies.
  Future<bool> syncAll({
    bool force = false,
    bool freshPull = false,
    int? pullOffset,
  }) async {
    final sortedEngines = _getSortedEngines();

    for (final engine in sortedEngines) {
      if (isRunning) await engine.processOutbox();
      final pullOffset_ = engine.config.freshPullOffsetEnabled
          ? pullOffset
          : null;
      final result = await engine.pull(
        force: force,
        freshPull: freshPull,
        pullOffset: pullOffset_,
      );
      if (result == SyncResult.failed) {
        _logger.w(
          () =>
              "Sync failed for ${engine.adapter.entityType}. Stopping cascade.",
        );
        return false;
      }
      await wait(1000);
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
  final Lock _outboxLock = Lock();

  void _teardownEngines() {
    for (final engine in _engines.values) {
      engine.stopPolling();
      engine.stopRealtime();
    }
  }

  Future<void> _processOutboxSynchronized() async {
    _logger.d('_processOutboxSynchronized triggered');
    await _outboxLock.synchronized(() async {
      _logger.d('synchronized lock acquired, calling processOutboxes()');
      await processOutboxes();
      _logger.d('processOutboxes() completed');
    });
  }

  /// Start scheduled tasks (polling, outbox) with the given [syncSpeed].
  ///
  /// - [SyncSpeed.realtime]: Subscribes to the outbox notification stream
  ///   for instant push on every new entry.
  /// - [SyncSpeed.balanced]: Polls the outbox every [AppConfig.pollingIntervalSeconds] seconds.
  void start({SyncSpeed syncSpeed = SyncSpeed.balanced, int? intervalSeconds}) {
    _logger.d(() => 'start() called with syncSpeed=$syncSpeed');
    _teardownEngines();
    _startOutboxProcessor(syncSpeed, intervalSeconds: intervalSeconds);
    switch (syncSpeed) {
      case SyncSpeed.realtime:
        _startRealtime();
      case SyncSpeed.balanced:
        _startPolling(intervalSeconds: intervalSeconds);
    }
    _isRunning = true;
  }

  /// Stop all scheduled tasks and realtime subscriptions.
  void stop() {
    _outboxTimer?.cancel();
    _outboxTimer = null;
    _outboxStreamSub?.cancel();
    _outboxStreamSub = null;

    _teardownEngines();
    _isRunning = false;
  }

  void _startRealtime() {
    for (final engine in _engines.values) {
      engine.startRealtime();
    }
  }

  void _startPolling({int? intervalSeconds}) {
    for (final engine in _engines.values) {
      engine.startPolling(intervalSeconds: intervalSeconds);
    }
  }

  void _startOutboxProcessor(SyncSpeed syncSpeed, {int? intervalSeconds}) {
    _logger.d(() => '_startOutboxProcessor: mode=$syncSpeed');
    // Cancel existing processors
    _outboxTimer?.cancel();
    _outboxTimer = null;
    _outboxStreamSub?.cancel();
    _outboxStreamSub = null;

    switch (syncSpeed) {
      case SyncSpeed.realtime:
        // Push instantly on every new outbox entry
        _logger.d('Subscribing to outbox stream for realtime push');
        _outboxStreamSub = _outboxRepo.onNewEntry.listen((_) {
          _logger.d('Stream notification received! Triggering push...');
          _processOutboxSynchronized();
        });
      case SyncSpeed.balanced:
        final balancedInterval =
            intervalSeconds ?? defaultBestEffortSyncInterval;
        _logger.d(() => 'Starting ${balancedInterval}s balanced timer');
        _outboxTimer = Timer.periodic(Duration(seconds: balancedInterval), (_) {
          _logger.d(
            () => '${balancedInterval}s timer fired, triggering push...',
          );
          _processOutboxSynchronized();
        });
    }
  }
}
