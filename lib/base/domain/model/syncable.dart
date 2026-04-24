import 'package:clipboard/base/domain/model/base.dart';

/// Mixin for domain models that participate in cross-device sync.
///
/// This provides the common contract required by the sync engine, ensuring that
/// all syncable models have standard identifiers and timestamps.
abstract mixin class Syncable implements Identifiable {
  @override
  int? get id;

  /// The server-side identifier of this entity. Null meaning it is not synced yet.
  int? get serverId;

  /// The timestamp when this entity was last modified (locally or remotely).
  DateTime get modified;

  /// The timestamp when this entity was last successfully synced.
  DateTime? get lastSynced;

  /// The device ID that created or last updated this entry.
  String? get deviceId;

  /// The deletion timestamp for soft-deleted items.
  DateTime? get deletedAt;

  /// Returns a copy of the entity with updated sync metadata.
  Syncable copyWithSyncMetadata({int? id, DateTime? lastSynced});

  /// Returns true if this entity has unsynced local changes.
  bool get hasUnsyncedChanges =>
      serverId == null || lastSynced == null || modified.isAfter(lastSynced!);
}
