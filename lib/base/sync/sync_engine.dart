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
/// - Pull sync (server → local) with cursor persistence
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

  Timer? _pollingTimer;
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
  });

  // ─── PULL (Server → Local) ────────────────────────────────────────────────

  /// Fetches changes and deletions from the server and applies them locally.
  Future<SyncResult> pull({bool force = false, bool freshPull = false}) async {
    if (_busy && !force) return SyncResult.skipped;
    _busy = true;
    eventBus.emitEngineStatus(adapter.entityType, true);

    try {
      final cursor = await cursorRepo.get(adapter.entityType);
      final lastSynced = freshPull
          ? DateTime.fromMillisecondsSinceEpoch(0)
          : (cursor?.lastSyncedAt ?? await adapter.getLatestSyncTimestamp());
      final excludeDeviceId = freshPull ? null : deviceId;

      // 1. Sync Deleted Items
      final deleteResult = await _pullDeleted(
        lastSynced,
        excludeDeviceId: excludeDeviceId,
      );
      if (deleteResult == SyncResult.failed) return SyncResult.failed;

      // 2. Sync Created/Updated Items
      final changesResult = await _pullChanges(
        lastSynced,
        freshPull ? 0 : (cursor?.lastOffset ?? 0),
        excludeDeviceId: excludeDeviceId,
      );
      if (changesResult == SyncResult.failed) return SyncResult.failed;

      // 3. Persist new cursor
      await cursorRepo.upsert(
        SyncCursor(entityType: adapter.entityType, lastSyncedAt: now()),
      );

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

  Future<SyncResult> _pullDeleted(
    DateTime? lastSynced, {
    String? excludeDeviceId,
  }) async {
    bool hasMore = true;
    int offset = 0;

    while (hasMore) {
      final result = await adapter.fetchRemoteDeleted(
        limit: config.deleteBatchSize,
        offset: offset,
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
          offset += paginated.results.length;

          if (paginated.results.isEmpty) return true;

          final deletedLocally = await adapter.deleteLocally(paginated.results);

          // Clear any outbox entries for these deleted items
          for (final item in deletedLocally) {
            if (item.id != null) {
              await outboxRepo.removeByEntity(adapter.entityType, item.id!);
            }
          }

          return true;
        },
      );

      if (!success) return SyncResult.failed;
    }
    return SyncResult.success;
  }

  Future<SyncResult> _pullChanges(
    DateTime? lastSynced,
    int initialOffset,
    {
    String? excludeDeviceId,
  }
  ) async {
    bool hasMore = true;
    int offset = initialOffset;

    while (hasMore) {
      final result = await adapter.fetchRemoteChanges(
        limit: config.pullBatchSize,
        offset: offset,
        excludeDeviceId: excludeDeviceId,
        lastSynced: lastSynced,
      );

      final success = await result.fold(
        (failure) async {
          logger.w("Failed to pull changes ${adapter.entityType}: $failure");
          return false;
        },
        (paginated) async {
          hasMore = paginated.hasMore;
          offset += paginated.results.length;

          if (paginated.results.isEmpty) {
            eventBus.emitProgress(
              SyncProgressParams(
                entityType: adapter.entityType,
                syncedCount: offset,
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
              syncedCount: offset,
            ),
          );

          // If we stopped mid-batch, we'd persist the cursor here with the offset
          // But currently we process sequentially.

          return true;
        },
      );

      if (!success) return SyncResult.failed;
      await wait(config.interBatchDelayMs);
    }
    return SyncResult.success;
  }

  // ─── PUSH (Local → Server via Outbox) ────────────────────────────────────

  /// Processes local changes waiting in the outbox.
  Future<void> processOutbox() async {
    final entries = await outboxRepo.getPending();
    final relevant = entries.where((e) => e.entityType == adapter.entityType);
    if (relevant.isEmpty) return;

    eventBus.emitEngineStatus(adapter.entityType, true);
    try {
      for (final entry in relevant) {
        await _processOutboxEntry(entry);
      }
    } finally {
      eventBus.emitEngineStatus(adapter.entityType, false);
    }
  }

  Future<void> _processOutboxEntry(SyncOutboxEntry entry) async {
    final item = await adapter.getLocalById(entry.localId);
    if (item == null && entry.action != SyncOutboxAction.delete) {
      // Local item missing, nothing to sync.
      await outboxRepo.markCompleted(entry.id!);
      return;
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
        resultEither = await adapter.pushToRemote(item);
      case SyncOutboxAction.delete:
        if (item == null) {
          await outboxRepo.markCompleted(entry.id!);
          return;
        }
        resultEither = await adapter.deleteFromRemote(item);
    }

    await resultEither.fold(
      (failure) async => await _handleOutboxFailure(entry, failure),
      (_) async => await outboxRepo.markCompleted(entry.id!),
    );
  }

  Future<void> _handleOutboxFailure(
    SyncOutboxEntry entry,
    Failure failure,
  ) async {
    logger.w(
      "Failed to sync outbox entry ${entry.id} (${adapter.entityType}): $failure",
    );
    if (entry.retryCount >= config.maxOutboxRetries) {
      await outboxRepo.markFailed(entry.id!, failure.message);
    } else {
      // Simple exponential backoff: 30s, 60s, 120s...
      final backoffSeconds = 30 * (1 << entry.retryCount);
      final nextRetryAt = now().add(Duration(seconds: backoffSeconds));
      await outboxRepo.incrementRetry(entry.id!, nextRetryAt: nextRetryAt);
    }
  }

  // ─── POLLING & REALTIME ──────────────────────────────────────────────────

  void startPolling() {
    stopPolling();
    _pollingTimer = Timer.periodic(
      Duration(seconds: config.pollingIntervalSeconds),
      (_) => pull(),
    );
  }

  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  void startRealtime() {
    final listener = adapter.realtimeListener;
    if (_isRealtimeSubscribed || listener == null) return;

    _statusSub = listener.onStatusChange.listen(_onRealtimeStatusChange);
    _eventSub = listener.onChangeEvent.listen(_onRealtimeEvent);

    listener.start();
    _isRealtimeSubscribed = true;
  }

  void _onRealtimeStatusChange(CrossSyncStatusEvent event) {
    final status = event.$1;
    if (status == CrossSyncListenerStatus.disconnected ||
        status == CrossSyncListenerStatus.error) {
      Future.delayed(
        Duration(seconds: config.reconnectDelaySeconds),
        () => adapter.realtimeListener?.reconnect(),
      );
    }
  }

  Future<void> _onRealtimeEvent(CrossSyncEvent<T> event) async {
    try {
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

    _triggerThrottledPull();
  }

  Timer? _throttleTimer;
  void _triggerThrottledPull() {
    _throttleTimer?.cancel();
    _throttleTimer = Timer(const Duration(seconds: 2), () => pull());
  }

  void stopRealtime() {
    _throttleTimer?.cancel();
    _statusSub?.cancel();
    _eventSub?.cancel();
    adapter.realtimeListener?.stop();
    _isRealtimeSubscribed = false;
  }
}
