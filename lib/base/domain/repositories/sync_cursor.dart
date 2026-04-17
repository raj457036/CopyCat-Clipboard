import 'package:clipboard/base/domain/model/sync/sync_cursor.dart';

/// Repository interface for persisting sync cursors.
abstract class SyncCursorRepository {
  /// Get the cursor for the given entity type.
  Future<SyncCursor?> get(String entityType);

  /// Create or update a cursor.
  Future<void> upsert(SyncCursor cursor);

  /// Delete a cursor (e.g., when resetting sync state).
  Future<void> delete(String entityType);
}
