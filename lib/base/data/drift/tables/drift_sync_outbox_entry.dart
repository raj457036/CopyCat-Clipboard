import 'package:clipboard/base/data/drift/drift_database.dart';
import 'package:clipboard/base/domain/model/sync/sync_outbox_entry.dart';
import 'package:drift/drift.dart';

@DataClassName('DriftSyncOutboxEntryRecord')
class DriftSyncOutboxEntryTable extends Table {
  @override
  String get tableName => 'sync_outbox_entry';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text()();
  IntColumn get localId => integer()();
  TextColumn get action => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get lastError => text().nullable()();

  static SyncOutboxEntry toDomain(DriftSyncOutboxEntryRecord entry) => SyncOutboxEntry(
        id: entry.id,
        entityType: entry.entityType,
        localId: entry.localId,
        action: SyncOutboxAction.values.firstWhere(
          (e) => e.name == entry.action,
          orElse: () => SyncOutboxAction.create,
        ),
        createdAt: entry.createdAt,
        lastError: entry.lastError,
      );

  static DriftSyncOutboxEntryTableCompanion fromDomain(SyncOutboxEntry entry) => DriftSyncOutboxEntryTableCompanion.insert(
        id: entry.id != null ? Value(entry.id!) : const Value.absent(),
        entityType: entry.entityType,
        localId: entry.localId,
        action: entry.action.name,
        createdAt: entry.createdAt,
        lastError: Value(entry.lastError),
      );
}
