import 'package:clipboard/base/data/isar/adapters/isar_sync_cursor.dart';
import 'package:clipboard/base/domain/model/sync/sync_cursor.dart';
import 'package:clipboard/base/domain/repositories/sync_cursor.dart';
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';
import 'package:clipboard/base/constants/strings/strings.dart';

@LazySingleton(as: SyncCursorRepository)
class IsarSyncCursorRepository implements SyncCursorRepository {
  Isar get _db => Isar.getInstance(dbName)!;
  IsarCollection<IsarSyncCursor> get _collection =>
      _db.collection<IsarSyncCursor>();

  @override
  Future<SyncCursor?> get(String entityType) async {
    final result = await _collection
        .filter()
        .entityTypeEqualTo(entityType)
        .findFirst();
    return result?.toDomain();
  }

  @override
  Future<void> upsert(SyncCursor cursor) async {
    final entry = IsarSyncCursor.fromDomain(cursor);
    await _db.writeTxn(() async {
      await _collection.put(entry);
    });
  }

  @override
  Future<void> delete(String entityType) async {
    await _db.writeTxn(() async {
      await _collection.filter().entityTypeEqualTo(entityType).deleteAll();
    });
  }
}
