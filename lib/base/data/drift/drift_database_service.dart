import 'package:clipboard/base/data/drift/drift_database.dart';
import 'package:clipboard/base/domain/services/database_service.dart';

/// Drift/SQLite-specific implementation of [DatabaseService].
class DriftDatabaseService implements DatabaseService {
  final AppDatabase _db;

  DriftDatabaseService(this._db);

  @override
  Future<void> initialize() async {
    // Drift database initializes lazily or is already opened via DI.
  }

  @override
  Future<void> clearAll() async {
    await _db.transaction(() async {
      for (final table in _db.allTables) {
        await _db.delete(table).go();
      }
    });
  }

  @override
  Future<void> close() async {
    await _db.close();
  }
}
