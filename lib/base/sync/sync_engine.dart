import 'dart:async';

import 'package:clipboard/base/domain/model/sync/sync_config.dart';
import 'package:dartz/dartz.dart';
import 'package:clipboard/base/domain/model/sync/sync_cursor.dart';
import 'package:clipboard/base/domain/model/sync/sync_outbox_entry.dart';
import 'package:clipboard/base/domain/model/syncable.dart';
import 'package:clipboard/base/domain/repositories/sync_cursor.dart';
import 'package:clipboard/base/domain/repositories/sync_outbox.dart';
import 'package:clipboard/base/domain/services/conflict_resolver.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:clipboard/base/domain/services/sync_adapter.dart';
import 'package:clipboard/base/domain/services/sync_event_bus.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/utils/utility.dart';

enum SyncResult { success, failed, skipped }

/// Generic sync engine for any [Syncable] entity.
///
/// Handles:
/// - Pull sync (server -> local) with cursor persistence
/// - Push sync (outbox processing with retry)
/// - Realtime sync (WebSocket with polling fallback)
/// - Conflict resolution
class SyncEngine<T extends Syncable> {
  final SyncAdapter<T> adapter;
  final SyncCursorRepository cursorRepo;
  final SyncOutboxRepository outboxRepo;
  final SyncEventBus eventBus;
  final SyncConfig config;
  final ConflictResolver<T> conflictResolver;
  final String deviceId;
  final String namespace;

  /// Engine identity that must be synced before this one.
  /// e.g., clips depend on collections.
  final List<String> dependsOn;

  Timer? _pollingTimer;
  Timer? _reconnectTimer;
  int? _pollingIntervalSeconds; // saved so realtime fallback can restore it
  bool _busy = false;
  bool _isRealtimeSubscribed = false;
  StreamSubscription? _statusSub;
  StreamSubscription? _eventSub;

  SyncEngine({
    required this.adapter,
    required this.cursorRepo,
    required this.outboxRepo,
    required this.eventBus,
    required this.config,
    required this.conflictResolver,
    required this.deviceId,
    required this.namespace,
    this.dependsOn = const [],
  });

  /// Unique identifier for this engine.
  String get identity => "${adapter.entityType}:$namespace";

  // PULL (Server -> Local)

  /// Fetches changes and deletions from the server and applies them locally.
  ///
  /// If [force] is true, it will run even if a sync is already in progress.
  /// If [freshPull] is true, it will ignore the last synced cursor and pull
  /// all changes since [pullOffset] seconds ago (default 0, i.e. from now ).
  Future<SyncResult> pull({
    bool force = false,
    bool freshPull = false,
    int? pullOffset,
  }) async {
    if (_busy && !force) return SyncResult.skipped;
    _busy = true;
    eventBus.emitEngineStatus(adapter.entityType, true);

    try {
      final cursor = await cursorRepo.get(identity);
      final legacyCursor = cursor == null && identity != adapter.entityType
          ? await cursorRepo.get(adapter.entityType)
          : null;
      DateTime? lastSynced;
      final maxLookback = pullOffset != null && pullOffset > 0
          ? systemTime().subtract(Duration(seconds: pullOffset))
          : null;
      if (freshPull) {
        final freshStart = (pullOffset == null || pullOffset == 0)
            ? DateTime.fromMillisecondsSinceEpoch(0)
            : systemTime().subtract(Duration(seconds: pullOffset));
        // If a checkpoint cursor exists ahead of freshStart, resume from it
        // instead of restarting from the beginning. This allows "Try Again"
        // after a timeout to pick up where it left off.
        final checkpoint = cursor?.lastSyncedAt;
        if (pullOffset != null &&
            checkpoint != null &&
            checkpoint.isAfter(freshStart)) {
          lastSynced = checkpoint;
        } else {
          lastSynced = freshStart;
        }
      } else {
        lastSynced =
            (cursor?.lastSyncedAt ??
            legacyCursor?.lastSyncedAt ??
            await adapter.getLatestSyncTimestamp());
      }

      // Never query beyond the active plan lookback window.
      if (maxLookback != null &&
          (lastSynced == null || lastSynced.isBefore(maxLookback))) {
        lastSynced = maxLookback;
      }

      final excludeDeviceId = freshPull ? null : deviceId;

      // During Restoration, we don't need to pull deleted records
      // because the local database is already wiped clean.
      DateTime? latestDeletedModified;
      if (!freshPull) {
        // 1. Sync Deleted Items
        final (deleteResult, deletedModified) = await _pullDeleted(
          lastSynced,
          excludeDeviceId: excludeDeviceId,
        );
        if (deleteResult == SyncResult.failed) return SyncResult.failed;
        latestDeletedModified = deletedModified;
      }

      // 2. Sync Created/Updated Items
      final (changesResult, latestPulledModified) = await _pullChanges(
        lastSynced,
        excludeDeviceId: excludeDeviceId,
      );
      if (changesResult == SyncResult.failed) return SyncResult.failed;

      // 3. Persist new cursor
      DateTime? nextCursorTime = lastSynced;
      if (latestDeletedModified != null &&
          (nextCursorTime == null ||
              latestDeletedModified.isAfter(nextCursorTime))) {
        nextCursorTime = latestDeletedModified;
      }
      if (latestPulledModified != null &&
          (nextCursorTime == null ||
              latestPulledModified.isAfter(nextCursorTime))) {
        nextCursorTime = latestPulledModified;
      }
      if (nextCursorTime != null) {
        await cursorRepo.upsert(
          SyncCursor(entityType: identity, lastSyncedAt: nextCursorTime),
        );
      }

      return SyncResult.success;
    } catch (e, stack) {
      logger.e(
        "SyncEngine pull failed for ${adapter.entityType}",
        error: e,
        stackTrace: stack,
      );
      return SyncResult.failed;
    } finally {
      _busy = false;
      eventBus.emitEngineStatus(adapter.entityType, false);
    }
  }

  Future<(SyncResult, DateTime?)> _pullDeleted(
    DateTime? lastSynced, {
    String? excludeDeviceId,
  }) async {
    bool hasMore = true;
    DateTime? lastModified;

    while (hasMore) {
      final result = await adapter.fetchRemoteDeleted(
        limit: config.deleteBatchSize,
        lastModified: lastModified,
        excludeDeviceId: excludeDeviceId,
        lastSynced: lastSynced,
      );

      final success = await result.fold(
        (failure) async {
          logger.w("Failed to pull deleted ${adapter.entityType}: $failure");
          return false;
        },
        (paginated) async {
          hasMore = paginated.hasMore;
          if (paginated.results.isNotEmpty) {
            lastModified = paginated.results.last.modified;
          }

          if (paginated.results.isEmpty) return true;

          final deletedLocally = await adapter.deleteLocally(paginated.results);

          if (deletedLocally.isNotEmpty) {
            eventBus.emitBatch<T>([
              for (final item in deletedLocally)
                (CrossSyncEventType.delete, item),
            ]);
          }

          // Clear any outbox entries for these deleted items
          for (final item in deletedLocally) {
            if (item.id != null) {
              await outboxRepo.removeByEntity(adapter.entityType, item.id!);
            }
          }

          return true;
        },
      );

      if (!success) return (SyncResult.failed, lastModified);
    }
    return (SyncResult.success, lastModified);
  }

  Future<(SyncResult, DateTime?)> _pullChanges(
    DateTime? lastSynced, {
    String? excludeDeviceId,
  }) async {
    bool hasMore = true;
    DateTime? lastModified = lastSynced;
    DateTime? latestPulledModified;
    int syncedCount = 0;
    // Adaptive batch size: shrinks on timeout, grows on consecutive successes.
    int batchLimit = config.pullBatchSize;
    final maxBatchSize = config.pullBatchSize * 6;

    while (hasMore) {
      // Retry the same batch up to 3 times on transient server-side timeouts.
      // Each retry halves the batch limit so shorter queries are less likely
      // to hit the statement timeout.
      var result = await adapter.fetchRemoteChanges(
        limit: batchLimit,
        lastModified: lastModified,
        excludeDeviceId: excludeDeviceId,
      );
      for (int attempt = 2; attempt <= 4; attempt++) {
        final isTimeout = result.fold(
          (f) => f.message.contains('statement timeout'),
          (_) => false,
        );
        if (!isTimeout) break;
        batchLimit = (batchLimit / 2).round().clamp(1, maxBatchSize);
        logger.w(
          () =>
              '[SyncEngine:${adapter.entityType}] batch timeout, attempt $attempt/4 — retrying with limit=$batchLimit',
        );
        await wait(attempt * 1000);
        result = await adapter.fetchRemoteChanges(
          limit: batchLimit,
          lastModified: lastModified,
          excludeDeviceId: excludeDeviceId,
        );
      }

      final success = await result.fold(
        (failure) async {
          logger.w("Failed to pull changes ${adapter.entityType}: $failure");
          return false;
        },
        (paginated) async {
          hasMore = paginated.hasMore;
          syncedCount += paginated.results.length;
          if (paginated.results.isNotEmpty) {
            lastModified = paginated.results.last.modified;
            latestPulledModified = lastModified;
            // Grow batch size on success (up to maxBatchSize) so fast
            // connections naturally fetch more per round-trip over time.
            batchLimit = (batchLimit * 2).clamp(1, maxBatchSize);
            // Save a checkpoint so "Try Again" can resume from this offset
            // rather than restarting from the beginning.
            await cursorRepo.upsert(
              SyncCursor(entityType: identity, lastSyncedAt: lastModified!),
            );
          }

          if (paginated.results.isEmpty) {
            eventBus.emitProgress(
              SyncProgressParams(
                entityType: adapter.entityType,
                syncedCount: syncedCount,
                fetchCount: paginated.results.length,
                totalCount: paginated.totalCount,
              ),
            );
            return true;
          }

          final events = await adapter.applyBatch(
            paginated.results,
            conflictResolver: conflictResolver,
          );

          if (events.isNotEmpty) {
            eventBus.emitBatch(events);
          }

          eventBus.emitProgress(
            SyncProgressParams(
              entityType: adapter.entityType,
              syncedCount: syncedCount,
              fetchCount: paginated.results.length,
              totalCount: paginated.totalCount,
            ),
          );

          return true;
        },
      );

      if (!success) return (SyncResult.failed, latestPulledModified);
      await wait(config.interBatchDelayMs);
    }
    return (SyncResult.success, latestPulledModified);
  }

  // PUSH (Local -> Server via Outbox)

  /// Processes local changes waiting in the outbox.
  Future<void> processOutbox() async {
    final entries = await outboxRepo.getPending();
    logger.d(
      () =>
          '[SyncEngine:${adapter.entityType}] processOutbox: ${entries.length} pending entries total',
    );
    final relevant = entries
        .where((e) => e.entityType == adapter.entityType)
        .toList();
    logger.d(
      () =>
          '[SyncEngine:${adapter.entityType}] Relevant entries: ${relevant.length}',
    );
    if (relevant.isEmpty) return;

    eventBus.emitEngineStatus(adapter.entityType, true);
    try {
      var index = 0;
      while (index < relevant.length) {
        final entry = relevant[index];
        logger.d(
          () =>
              '[SyncEngine:${adapter.entityType}] Processing entry id=${entry.id} localId=${entry.localId} action=${entry.action}',
        );

        if (entry.action == SyncOutboxAction.delete) {
          final deleteBatch = <SyncOutboxEntry>[entry];
          var nextIndex = index + 1;
          while (nextIndex < relevant.length &&
              relevant[nextIndex].action == SyncOutboxAction.delete) {
            deleteBatch.add(relevant[nextIndex]);
            nextIndex++;
          }
          await _processDeleteBatch(deleteBatch);
          index = nextIndex;
          continue;
        }

        await _processOutboxEntry(entry);
        index++;
      }
    } finally {
      eventBus.emitEngineStatus(adapter.entityType, false);
    }
  }

  Future<void> _processDeleteBatch(List<SyncOutboxEntry> entries) async {
    if (entries.isEmpty) return;

    final resolvable = <(SyncOutboxEntry, T)>[];

    for (final entry in entries) {
      final item = await adapter.getLocalById(entry.localId);
      if (item == null) {
        if (entry.id != null) {
          await outboxRepo.markCompleted(entry.id!);
        }
        continue;
      }
      resolvable.add((entry, item));
    }

    if (resolvable.isEmpty) return;

    final items = resolvable.map((e) => e.$2).toList(growable: false);
    final result = await adapter.deleteBatchFromRemote(items);

    final success = result.fold((_) => false, (ok) => ok);
    if (!success) {
      // Preserve existing behavior by falling back to single-entry processing.
      for (final entry in entries) {
        await _processOutboxEntry(entry);
      }
      return;
    }

    for (final entry in entries) {
      if (entry.id != null) {
        await outboxRepo.markCompleted(entry.id!);
      }
    }
  }

  Future<void> _processOutboxEntry(SyncOutboxEntry entry) async {
    final item = await adapter.getLocalById(entry.localId);
    logger.d(
      () =>
          '[SyncEngine:${adapter.entityType}] getLocalById(${entry.localId}) => ${item != null ? "found (serverId=${(item as dynamic).serverId}, userId=${(item as dynamic).userId})" : "NULL"}',
    );
    if (item == null && entry.action != SyncOutboxAction.delete) {
      // Local item missing, nothing to sync.
      logger.w(
        () =>
            '[SyncEngine:${adapter.entityType}] Item missing locally, marking completed',
      );
      await outboxRepo.markCompleted(entry.id!);
      return;
    }

    if (item != null && entry.action != SyncOutboxAction.delete) {
      final inProgress = await adapter.markSyncInProgress(
        item,
        inProgress: true,
      );
      if (inProgress != null) {
        eventBus.emit<T>((CrossSyncEventType.update, inProgress));
      }
    }

    Either<Failure, dynamic>? resultEither;

    switch (entry.action) {
      case SyncOutboxAction.create:
      case SyncOutboxAction.update:
        if (item == null) {
          resultEither = const Left(
            Failure(message: 'Item not found locally', code: 'not-found'),
          );
          break;
        }
        logger.d(
          () => '[SyncEngine:${adapter.entityType}] Calling pushToRemote...',
        );
        resultEither = await adapter.pushToRemote(item);
      case SyncOutboxAction.delete:
        // NOTE: We know the item is soft deleted locally at this point.
        if (item == null) {
          await outboxRepo.markCompleted(entry.id!);
          return;
        }
        resultEither = await adapter.deleteFromRemote(item);
    }

    await resultEither.fold(
      (failure) async {
        if (item != null && entry.action != SyncOutboxAction.delete) {
          final completed = await adapter.markSyncInProgress(
            item,
            inProgress: false,
            failure: failure,
          );
          if (completed != null) {
            eventBus.emit<T>((CrossSyncEventType.update, completed));
          }
        }
        logger.e(
          () =>
              '[SyncEngine:${adapter.entityType}] Push FAILED: ${failure.message} (${failure.code})',
        );
        await _handleOutboxFailure(entry, failure);
      },
      (result) async {
        logger.d(
          () =>
              '[SyncEngine:${adapter.entityType}] Push SUCCESS for entry id=${entry.id}. Marking completed.',
        );
        await outboxRepo.markCompleted(entry.id!);
        // Broadcast update to UI so serverId/lastSynced are reflected
        if (result is T) {
          final persisted = await adapter.persistSyncResult(
            result,
            syncedAt: systemTime(),
          );
          final completed = await adapter.markSyncInProgress(
            persisted ?? result,
            inProgress: false,
          );
          logger.d(
            () =>
                '[SyncEngine:${adapter.entityType}] Emitting update event to UI',
          );
          if (completed != null) {
            eventBus.emit<T>((CrossSyncEventType.update, completed));
          }
        }
      },
    );
  }

  Future<void> _handleOutboxFailure(
    SyncOutboxEntry entry,
    Failure failure,
  ) async {
    logger.w(
      () =>
          "Failed to sync outbox entry ${entry.id} (${adapter.entityType}): $failure",
    );

    if (entry.id != null) {
      eventBus.emitOutboxFailure(
        entityType: adapter.entityType,
        outboxEntryId: entry.id!,
        failure: failure,
      );
      // Drop failed jobs immediately so they do not keep retrying and
      // users can re-trigger sync manually from the item action.
      await outboxRepo.markCompleted(entry.id!);
    }
  }

  // POLLING & REALTIME

  void startPolling({int? intervalSeconds}) {
    stopPolling();
    final cadence = intervalSeconds ?? config.pollingIntervalSeconds;
    _pollingIntervalSeconds = cadence;
    // Don't start the timer if realtime is currently connected.
    if (_isRealtimeSubscribed || _pollingTimer != null) return;
    _pollingTimer = Timer.periodic(Duration(seconds: cadence), (_) => pull());
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  void startRealtime() {
    logger.d(
      () => "Attempting to start realtime listener for ${adapter.entityType}",
    );
    final listener = adapter.realtimeListener;
    if (_isRealtimeSubscribed || listener == null) return;

    stopPolling();
    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    _statusSub = listener.onStatusChange.listen(_onRealtimeStatusChange);
    _eventSub = listener.onChangeEvent.listen(_onRealtimeEvent);

    listener.start();
    _isRealtimeSubscribed = true;
  }

  void _onRealtimeStatusChange(CrossSyncStatusEvent event) {
    final status = event.$1;
    switch (status) {
      case CrossSyncListenerStatus.connected:
        _reconnectTimer?.cancel();
        _reconnectTimer = null;
        stopPolling();
        return;
      case CrossSyncListenerStatus.disconnected:
      case CrossSyncListenerStatus.error:
        logger.i(
          () =>
              "Realtime listener for ${adapter.entityType} disconnected with status: $status",
        );
        if (_pollingIntervalSeconds != null) {
          startPolling(intervalSeconds: _pollingIntervalSeconds);
        }
        _scheduleReconnect();
        return;
      default:
        return;
    }
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(
      Duration(seconds: config.reconnectDelaySeconds),
      () => adapter.realtimeListener?.reconnect(),
    );
  }

  Future<void> _onRealtimeEvent(CrossSyncEvent<T> event) async {
    try {
      logger.d(() => "Received realtime event: $event");
      final (type, item) = event;

      if (type == CrossSyncEventType.delete) {
        final deleted = await adapter.deleteLocally([item]);
        if (deleted.isEmpty) {
          eventBus.emit<T>((CrossSyncEventType.delete, item));
        } else {
          for (final d in deleted) {
            eventBus.emit<T>((CrossSyncEventType.delete, d));
          }
        }
      } else {
        final results = await adapter.applyBatch([
          item,
        ], conflictResolver: conflictResolver);
        eventBus.emitBatch<T>(results);
      }
    } catch (e, stack) {
      logger.e(
        "Fast-path ingestion failed for ${adapter.entityType}",
        error: e,
        stackTrace: stack,
      );
    }
  }

  void stopRealtime() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _statusSub?.cancel();
    _eventSub?.cancel();
    adapter.realtimeListener?.stop();
    _isRealtimeSubscribed = false;
  }
}
