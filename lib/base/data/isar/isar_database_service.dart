import 'package:clipboard/base/domain/services/database_service.dart';
import 'package:isar_community/isar.dart';

/// Isar-specific implementation of [DatabaseService].
class IsarDatabaseService implements DatabaseService {
  final Isar _db;

  IsarDatabaseService(this._db);

  @override
  Future<void> initialize() async {
    // Isar is already initialized via DI, nothing to do here.
  }

  @override
  Future<void> clearAll() async {
    await _db.writeTxn(() => _db.clear());
  }

  @override
  Future<void> close() async {
    if (_db.isOpen) {
      await _db.close();
    }
  }
}
