import 'package:clipboard/base/data/drift/drift_database.dart';
import 'package:clipboard/base/data/drift/tables/drift_sync_cursor.dart';
import 'package:clipboard/base/domain/model/sync/sync_cursor.dart';
import 'package:clipboard/base/domain/repositories/sync_cursor.dart';
import 'package:injectable/injectable.dart';

@Named('drift')
@LazySingleton(as: SyncCursorRepository)
class DriftSyncCursorRepository implements SyncCursorRepository {
  final AppDatabase _db;

  DriftSyncCursorRepository(this._db);

  @override
  Future<SyncCursor?> get(String entityType) async {
    final query = _db.select(_db.driftSyncCursorTable)
      ..where((tbl) => tbl.entityType.equals(entityType));
    final entry = await query.getSingleOrNull();
    return entry != null ? DriftSyncCursorTable.toDomain(entry) : null;
  }

  @override
  Future<void> upsert(SyncCursor cursor) async {
    final companion = DriftSyncCursorTable.fromDomain(cursor);
    await _db.into(_db.driftSyncCursorTable).insertOnConflictUpdate(companion);
  }

  @override
  Future<void> delete(String entityType) async {
    final query = _db.delete(_db.driftSyncCursorTable)
      ..where((tbl) => tbl.entityType.equals(entityType));
    await query.go();
  }
}
