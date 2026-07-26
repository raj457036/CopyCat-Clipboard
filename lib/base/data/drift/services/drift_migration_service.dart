import 'package:clipboard/base/data/drift/drift_database.dart';
import 'package:clipboard/base/data/drift/tables/drift_app_config.dart';
import 'package:clipboard/base/data/drift/tables/drift_application_meta.dart';
import 'package:clipboard/base/data/drift/tables/drift_clip_collection.dart';
import 'package:clipboard/base/data/drift/tables/drift_clipboard_item.dart';
import 'package:clipboard/base/data/drift/tables/drift_subscription.dart';
import 'package:clipboard/base/data/drift/tables/drift_sync_cursor.dart';
import 'package:clipboard/base/data/drift/tables/drift_sync_outbox_entry.dart';
import 'package:clipboard/base/data/drift/tables/drift_sync_status.dart';
import 'package:clipboard/base/data/isar/adapters/isar_app_config.dart';
import 'package:clipboard/base/data/isar/adapters/isar_application_meta.dart';
import 'package:clipboard/base/data/isar/adapters/isar_clip_collection.dart';
import 'package:clipboard/base/data/isar/adapters/isar_clipboard_item.dart';
import 'package:clipboard/base/data/isar/adapters/isar_subscription.dart';
import 'package:clipboard/base/data/isar/adapters/isar_sync_cursor.dart';
import 'package:clipboard/base/data/isar/adapters/isar_sync_outbox_entry.dart';
import 'package:clipboard/base/data/isar/adapters/isar_sync_status.dart';
import 'package:clipboard/common/logging.dart';
import 'package:drift/drift.dart';
import 'package:isar_community/isar.dart';
import 'package:tiny_storage/tiny_storage.dart';

const String kActiveDbEngineKey = 'active_db_engine';
const String kIsarMigratedToDriftKey = 'isar_migrated_to_drift';
const String kDbEngineDrift = 'drift';
const String kDbEngineIsar = 'isar';

/// Service responsible for 1:1 migration of data from Isar to Drift (SQLite).
class IsarToDriftMigrator {
  static const _logger = AppLogger.scoped('IsarToDriftMigrator');

  final Isar _isar;
  final AppDatabase _drift;
  final TinyStorage _storage;

  IsarToDriftMigrator(this._isar, this._drift, this._storage);

  /// Executes complete 1:1 batch migration from Isar to Drift.
  Future<bool> migrate() async {
    _logger.i('Starting 1:1 Isar to Drift data migration...');

    try {
      // 1. Migrate Clipboard Items
      final isarClips = await _isar.collection<IsarClipboardItem>().where().findAll();
      _logger.d(() => 'Migrating ${isarClips.length} IsarClipboardItem entries...');

      await _drift.transaction(() async {
        for (final clip in isarClips) {
          final domain = clip.toDomain();
          final companion = DriftClipboardItemTable.fromDomain(domain);
          await _drift.into(_drift.driftClipboardItemTable).insert(
                companion,
                mode: InsertMode.insertOrReplace,
              );
        }

        // 2. Migrate Clip Collections
        final isarCollections = await _isar.collection<IsarClipCollection>().where().findAll();
        for (final col in isarCollections) {
          final domain = col.toDomain();
          final companion = DriftClipCollectionTable.fromDomain(domain);
          await _drift.into(_drift.driftClipCollectionTable).insert(
                companion,
                mode: InsertMode.insertOrReplace,
              );
        }

        // 3. Migrate App Config
        final isarConfigs = await _isar.collection<IsarAppConfig>().where().findAll();
        for (final cfg in isarConfigs) {
          final domain = cfg.toDomain();
          final companion = DriftAppConfigTable.fromDomain(domain);
          await _drift.into(_drift.driftAppConfigTable).insert(
                companion,
                mode: InsertMode.insertOrReplace,
              );
        }

        // 4. Migrate Application Meta
        final isarAppMetas = await _isar.collection<IsarApplicationMeta>().where().findAll();
        for (final meta in isarAppMetas) {
          final domain = meta.toDomain();
          final companion = DriftApplicationMetaTable.fromDomain(domain);
          await _drift.into(_drift.driftApplicationMetaTable).insert(
                companion,
                mode: InsertMode.insertOrReplace,
              );
        }

        // 5. Migrate Subscriptions
        final isarSubs = await _isar.collection<IsarSubscription>().where().findAll();
        for (final sub in isarSubs) {
          final domain = sub.toDomain();
          final companion = DriftSubscriptionTable.fromDomain(domain);
          await _drift.into(_drift.driftSubscriptionTable).insert(
                companion,
                mode: InsertMode.insertOrReplace,
              );
        }

        // 6. Migrate Sync Cursors
        final isarCursors = await _isar.collection<IsarSyncCursor>().where().findAll();
        for (final cursor in isarCursors) {
          final domain = cursor.toDomain();
          final companion = DriftSyncCursorTable.fromDomain(domain);
          await _drift.into(_drift.driftSyncCursorTable).insert(
                companion,
                mode: InsertMode.insertOrReplace,
              );
        }

        // 7. Migrate Sync Outbox Entries
        final isarOutbox = await _isar.collection<IsarSyncOutboxEntry>().where().findAll();
        for (final entry in isarOutbox) {
          final domain = entry.toDomain();
          final companion = DriftSyncOutboxEntryTable.fromDomain(domain);
          await _drift.into(_drift.driftSyncOutboxEntryTable).insert(
                companion,
                mode: InsertMode.insertOrReplace,
              );
        }

        // 8. Migrate Sync Status
        final isarStatuses = await _isar.collection<IsarSyncStatus>().where().findAll();
        for (final status in isarStatuses) {
          final domain = status.toDomain();
          final companion = DriftSyncStatusTable.fromDomain(domain);
          await _drift.into(_drift.driftSyncStatusTable).insert(
                companion,
                mode: InsertMode.insertOrReplace,
              );
        }
      });

      _storage.set(kActiveDbEngineKey, kDbEngineDrift);
      _storage.set(kIsarMigratedToDriftKey, true);

      _logger.i('Isar to Drift migration successfully completed!');
      return true;
    } catch (e, st) {
      _logger.e('Failed to migrate data from Isar to Drift', error: e, stackTrace: st);
      return false;
    }
  }
}
