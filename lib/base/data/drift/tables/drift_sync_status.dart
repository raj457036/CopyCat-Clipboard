import 'package:clipboard/base/data/drift/drift_database.dart';
import 'package:clipboard/base/domain/model/sync_status/syncstatus.dart';
import 'package:drift/drift.dart';

@DataClassName('DriftSyncStatusEntry')
class DriftSyncStatusTable extends Table {
  @override
  String get tableName => 'sync_status';

  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get lastSyncPoint => dateTime().nullable()();
  DateTimeColumn get lastSyncStartPoint => dateTime().nullable()();
  IntColumn get lastKnownSyncCount => integer().nullable()();
  IntColumn get lastKnownTotalCount => integer().nullable()();
  BoolColumn get restorationPending => boolean().withDefault(const Constant(true))();

  static SyncStatus toDomain(DriftSyncStatusEntry entry) => SyncStatus(
        id: entry.id,
        lastSyncPoint: entry.lastSyncPoint,
        lastSyncStartPoint: entry.lastSyncStartPoint,
        lastKnownSyncCount: entry.lastKnownSyncCount,
        lastKnownTotalCount: entry.lastKnownTotalCount,
        restorationPending: entry.restorationPending,
      );

  static DriftSyncStatusTableCompanion fromDomain(SyncStatus status) => DriftSyncStatusTableCompanion.insert(
        id: status.id != null ? Value(status.id!) : const Value.absent(),
        lastSyncPoint: Value(status.lastSyncPoint),
        lastSyncStartPoint: Value(status.lastSyncStartPoint),
        lastKnownSyncCount: Value(status.lastKnownSyncCount),
        lastKnownTotalCount: Value(status.lastKnownTotalCount),
        restorationPending: Value(status.restorationPending),
      );
}
