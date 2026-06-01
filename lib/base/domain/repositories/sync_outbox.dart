import 'package:clipboard/base/domain/model/sync/sync_outbox_entry.dart';

/// Repository interface for managing the sync outbox.
abstract class SyncOutboxRepository {
  /// Stream that emits whenever a new entry is enqueued.
  ///
  /// Used by [SyncOrchestrator] to trigger immediate outbox processing
  /// in realtime sync mode.
  Stream<void> get onNewEntry;

  /// Enqueue a new operation.
  Future<void> enqueue(SyncOutboxEntry entry);

  /// Get pending entries, optionally limited. Order by created ascending.
  Future<List<SyncOutboxEntry>> getPending({int limit = 50});

  /// Mark an entry as completed (usually deletes it).
  Future<void> markCompleted(int id);

  /// Remove all entries related to a specific local entity (e.g. if it was deleted locally).
  Future<void> removeByEntity(String entityType, int localId);

  /// Clear all entries from the outbox (e.g. on logout).
  Future<void> clearAll();

  /// Returns true if the given entity/local ID pair has a pending outbox entry.
  /// O(1) — backed by an in-memory set maintained alongside all mutations.
  bool isLocalIdQueued(String entityType, int localId);
}
