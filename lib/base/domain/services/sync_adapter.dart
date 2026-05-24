import 'package:clipboard/base/domain/model/syncable.dart';
import 'package:clipboard/base/domain/services/conflict_resolver.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/paginated_results.dart';
import 'package:dartz/dartz.dart';

/// Per-entity adapter that the generic SyncEngine uses to sync a specific model.
///
/// To add sync for a new entity type (e.g., Notification):
/// 1. Make the model implement [Syncable]
/// 2. Implement [SyncAdapter<Notification>]
/// 3. Register it with the SyncOrchestrator
abstract class SyncAdapter<T extends Syncable> {
  /// Unique name for this entity type (e.g., 'clip', 'collection').
  String get entityType;

  // Fetching state

  /// Find latest synced item timestamp for cursor reconstruction.
  Future<DateTime?> getLatestSyncTimestamp();

  // Pull (Server → Local)

  /// Fetch changed items from server since [lastModified] (keyset cursor).
  FailureOr<PaginatedResult<T>> fetchRemoteChanges({
    required int limit,
    DateTime? lastModified,
    String? excludeDeviceId,
  });

  /// Fetch deleted items from server since [lastSynced], paged by [lastModified] cursor.
  FailureOr<PaginatedResult<T>> fetchRemoteDeleted({
    required int limit,
    DateTime? lastModified,
    String? excludeDeviceId,
    DateTime? lastSynced,
  });

  /// Apply a batch of incoming items to the local DB.
  /// Should handle create-or-update logic internally.
  /// Returns sync events describing what happened.
  Future<List<CrossSyncEvent<T>>> applyBatch(
    List<T> items, {
    required ConflictResolver<T> conflictResolver,
  });

  /// Delete items locally.
  Future<List<T>> deleteLocally(List<T> items);

  // Push (Local → Server)

  /// Get a local item by ID (for outbox processing).
  Future<T?> getLocalById(int localId);

  /// Push a single item to the server (create or update).
  FailureOr<T> pushToRemote(T item);

  /// Persist sync metadata locally after a successful push.
  ///
  /// Default implementation is a no-op.
  Future<T?> persistSyncResult(T item, {DateTime? syncedAt}) async {
    return item;
  }

  /// Delete a single item from the server.
  FailureOr<bool> deleteFromRemote(T item);

  /// Delete multiple items from the server in one operation when supported.
  ///
  /// Default implementation falls back to one-by-one deletion.
  FailureOr<bool> deleteBatchFromRemote(List<T> items) async {
    for (final item in items) {
      final result = await deleteFromRemote(item);
      final ok = result.fold((_) => false, (value) => value);
      if (!ok) {
        return result;
      }
    }
    return const Right(true);
  }

  /// Allows adapters to expose transient per-item sync state for UI.
  ///
  /// Default implementation is a no-op and returns the same item.
  Future<T?> markSyncInProgress(
    T item, {
    required bool inProgress,
    Failure? failure,
  }) async {
    return item;
  }

  // Realtime

  /// Optional realtime listener for this entity type.
  CrossSyncListener<T>? get realtimeListener => null;
}
