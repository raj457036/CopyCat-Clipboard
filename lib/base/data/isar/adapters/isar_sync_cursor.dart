import 'package:clipboard/base/domain/model/sync/sync_cursor.dart';
import 'package:isar_community/isar.dart';

part 'isar_sync_cursor.g.dart';

@Name("SyncCursor")
@Collection()
class IsarSyncCursor {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String entityType;

  late DateTime lastSyncedAt;

  int lastOffset = 0;

  SyncCursor toDomain() => SyncCursor(
    entityType: entityType,
    lastSyncedAt: lastSyncedAt,
    lastOffset: lastOffset,
  );

  static IsarSyncCursor fromDomain(SyncCursor cursor) => IsarSyncCursor()
    ..entityType = cursor.entityType
    ..lastSyncedAt = cursor.lastSyncedAt
    ..lastOffset = cursor.lastOffset;
}
