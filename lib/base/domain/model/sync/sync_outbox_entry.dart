import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_outbox_entry.freezed.dart';

enum SyncOutboxAction { create, update, delete }

/// Represents a pending sync operation in the local outbox.
///
/// When a user creates/updates/deletes an item offline, an outbox entry is
/// enqueued. The SyncEngine asynchronously processes the outbox to push
/// changes to the server.
@freezed
class SyncOutboxEntry with _$SyncOutboxEntry {
  const factory SyncOutboxEntry({
    /// Local database ID of the outbox entry (not the entity).
    @JsonKey(includeToJson: false, includeFromJson: false) int? id,

    /// The type of entity being synced (e.g., 'clip', 'collection').
    required String entityType,

    /// The local ID of the target entity.
    required int localId,

    /// The action to perform on the server.
    required SyncOutboxAction action,

    /// When this entry was enqueued.
    required DateTime createdAt,

    /// Number of times we've tried to process this entry.
    @Default(0) int retryCount,

    /// Time until which we should back off.
    DateTime? nextRetryAt,

    /// The last failure message, if any.
    String? lastError,
  }) = _SyncOutboxEntry;
}
