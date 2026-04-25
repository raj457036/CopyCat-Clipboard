import 'package:clipboard/base/domain/model/sync/sync_outbox_entry.dart';
import 'package:isar_community/isar.dart';

part 'isar_sync_outbox_entry.g.dart';

@Name("SyncOutboxEntry")
@Collection()
class IsarSyncOutboxEntry {
  Id id = Isar.autoIncrement;

  @Index()
  late String entityType;

  @Index()
  late int localId;

  @Enumerated(EnumType.name)
  late SyncOutboxAction action;

  late DateTime createdAt;

  String? lastError;

  SyncOutboxEntry toDomain() => SyncOutboxEntry(
    id: id == Isar.autoIncrement ? null : id,
    entityType: entityType,
    localId: localId,
    action: action,
    createdAt: createdAt,
    lastError: lastError,
  );

  static IsarSyncOutboxEntry fromDomain(SyncOutboxEntry entry) =>
      IsarSyncOutboxEntry()
        ..id = entry.id ?? Isar.autoIncrement
        ..entityType = entry.entityType
        ..localId = entry.localId
        ..action = entry.action
        ..createdAt = entry.createdAt
        ..lastError = entry.lastError;
}
