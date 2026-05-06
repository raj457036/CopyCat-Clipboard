import 'package:clipboard/base/domain/model/syncable.dart';
import 'package:clipboard/base/domain/services/conflict_resolver.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/paginated_results.dart';

/// Per-entity adapter that the generic SyncEngine uses to sync a specific model.
///
/// To add sync for a new entity type (e.g., Notification):
/// 1. Make the model implement [Syncable]
/// 2. Implement [SyncAdapter<Notification>]
/// 3. Register it with the SyncOrchestrator
abstract class SyncAdapter<T extends Syncable> {
  /// Unique name for this entity type (e.g., 'clip', 'collection').
  String get entityType;

  /// Entity types that must be synced before this one.
  /// e.g., clips depend on collections.
  List<String> get dependsOn => const [];

  // ─── Fetching state ───────────────────────────────

  /// Find latest synced item timestamp for cursor reconstruction.
  Future<DateTime?> getLatestSyncTimestamp();

  // ─── Pull (Server → Local) ─────────────────────────

  /// Fetch changed items from server since [lastSynced].
  FailureOr<PaginatedResult<T>> fetchRemoteChanges({
    required int limit,
    required int offset,
    String? excludeDeviceId,
    DateTime? lastSynced,
  });

  /// Fetch deleted items from server since [lastSynced].
  FailureOr<PaginatedResult<T>> fetchRemoteDeleted({
    required int limit,
    required int offset,
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

  /// Apply a transformation to an incoming item before it is saved locally.
  ///
  /// For example, decryption, cleanup, or masking. This is optional and can be a no-op.
  Future<T> beforeLocalWrite(T item);

  /// Delete items locally.
  Future<List<T>> deleteLocally(List<T> items);

  // ─── Push (Local → Server) ─────────────────────────

  /// Get a local item by ID (for outbox processing).
  Future<T?> getLocalById(int localId);

  /// Push a single item to the server (create or update).
  FailureOr<T> pushToRemote(T item);

  /// Delete a single item from the server.
  FailureOr<bool> deleteFromRemote(T item);

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

  // ─── Realtime ──────────────────────────────────────

  /// Optional realtime listener for this entity type.
  CrossSyncListener<T>? get realtimeListener => null;
}
