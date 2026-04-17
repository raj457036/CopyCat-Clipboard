import 'package:clipboard/base/domain/model/sync/sync_outbox_entry.dart';

/// Repository interface for managing the sync outbox.
abstract class SyncOutboxRepository {
  /// Enqueue a new operation.
  Future<void> enqueue(SyncOutboxEntry entry);

  /// Get pending entries, optionally limited. Order by created ascending.
  Future<List<SyncOutboxEntry>> getPending({int limit = 50});

  /// Mark an entry as completed (usually deletes it).
  Future<void> markCompleted(int id);

  /// Mark an entry as failed with a permanent error.
  Future<void> markFailed(int id, String error);

  /// Increment the retry count and set the next retry time.
  Future<void> incrementRetry(int id, {required DateTime nextRetryAt});

  /// Remove all entries related to a specific local entity (e.g. if it was deleted locally).
  Future<void> removeByEntity(String entityType, int localId);

  /// Clear all entries from the outbox (e.g. on logout).
  Future<void> clearAll();
}
