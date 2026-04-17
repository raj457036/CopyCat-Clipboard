import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_cursor.freezed.dart';

/// Tracks the last successful sync timestamp per entity type.
///
/// This serves as a persistent cursor so that the sync engine knows exactly
/// where to resume fetching from the server, even across app restarts.
@freezed
class SyncCursor with _$SyncCursor {
  const factory SyncCursor({
    /// Unique identifier for the entity type (e.g., 'clip', 'collection').
    required String entityType,

    /// The timestamp of the last successful pull sync.
    required DateTime lastSyncedAt,

    /// Offset for pagination, useful if the sync stopped mid-batch.
    @Default(0) int lastOffset,
  }) = _SyncCursor;
}
