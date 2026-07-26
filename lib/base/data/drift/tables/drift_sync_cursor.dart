import 'package:clipboard/base/data/drift/drift_database.dart';
import 'package:clipboard/base/domain/model/sync/sync_cursor.dart';
import 'package:drift/drift.dart';

@DataClassName('DriftSyncCursorEntry')
class DriftSyncCursorTable extends Table {
  @override
  String get tableName => 'sync_cursor';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text().unique()();
  DateTimeColumn get lastSyncedAt => dateTime()();
  IntColumn get lastOffset => integer().withDefault(const Constant(0))();

  static SyncCursor toDomain(DriftSyncCursorEntry entry) => SyncCursor(
        entityType: entry.entityType,
        lastSyncedAt: entry.lastSyncedAt,
        lastOffset: entry.lastOffset,
      );

  static DriftSyncCursorTableCompanion fromDomain(SyncCursor cursor) => DriftSyncCursorTableCompanion.insert(
        entityType: cursor.entityType,
        lastSyncedAt: cursor.lastSyncedAt,
        lastOffset: Value(cursor.lastOffset),
      );
}
