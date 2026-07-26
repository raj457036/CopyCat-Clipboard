import 'package:clipboard/base/data/drift/drift_database.dart';
import 'package:clipboard/base/data/drift/services/drift_migration_service.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Drift Database & Migration Tests', () {
    late AppDatabase driftDb;

    setUp(() {
      driftDb = AppDatabase(NativeDatabase.memory());
    });

    tearDown(() async {
      await driftDb.close();
    });

    test('Drift database initializes schema v1 and tables correctly', () async {
      expect(driftDb.schemaVersion, equals(1));
      final items = await driftDb.select(driftDb.driftClipboardItemTable).get();
      expect(items, isEmpty);
    });

    test('Constant keys for database engine tracking are correct', () {
      expect(kActiveDbEngineKey, equals('active_db_engine'));
      expect(kIsarMigratedToDriftKey, equals('isar_migrated_to_drift'));
      expect(kDbEngineDrift, equals('drift'));
      expect(kDbEngineIsar, equals('isar'));
    });
  });
}
