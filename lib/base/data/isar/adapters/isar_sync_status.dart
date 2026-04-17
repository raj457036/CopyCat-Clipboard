import 'package:clipboard/base/domain/model/sync_status/syncstatus.dart';
import 'package:isar_community/isar.dart';

part 'isar_sync_status.g.dart';

@Name("SyncStatus")
@Collection()
class IsarSyncStatus {
  Id isarId = Isar.autoIncrement;
  DateTime? lastSyncPoint;
  DateTime? lastSyncStartPoint;
  int? lastKnownSyncCount;
  int? lastKnownTotalCount;
  bool restorationPending = true;

  SyncStatus toDomain() => SyncStatus(
        id: isarId == Isar.autoIncrement ? null : isarId,
        lastSyncPoint: lastSyncPoint,
        lastSyncStartPoint: lastSyncStartPoint,
        lastKnownSyncCount: lastKnownSyncCount,
        lastKnownTotalCount: lastKnownTotalCount,
        restorationPending: restorationPending,
      );

  static IsarSyncStatus fromDomain(SyncStatus status) => IsarSyncStatus()
    ..isarId = status.id ?? Isar.autoIncrement
    ..lastSyncPoint = status.lastSyncPoint
    ..lastSyncStartPoint = status.lastSyncStartPoint
    ..lastKnownSyncCount = status.lastKnownSyncCount
    ..lastKnownTotalCount = status.lastKnownTotalCount
    ..restorationPending = status.restorationPending;
}
