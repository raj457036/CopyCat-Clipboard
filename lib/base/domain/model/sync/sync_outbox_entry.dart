import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_outbox_entry.freezed.dart';

enum SyncOutboxAction { create, update, delete }

/// Defines the type of entity being synced.
class SyncEntityType {
  SyncEntityType._();

  static const clip = 'clip';
  static const collection = 'collection';
}

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

    /// The last failure message, if any.
    String? lastError,
  }) = _SyncOutboxEntry;
}
