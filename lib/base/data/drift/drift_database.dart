import 'dart:io';
import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/data/drift/tables/drift_app_config.dart';
import 'package:clipboard/base/data/drift/tables/drift_application_meta.dart';
import 'package:clipboard/base/data/drift/tables/drift_clip_collection.dart';
import 'package:clipboard/base/data/drift/tables/drift_clipboard_item.dart';
import 'package:clipboard/base/data/drift/tables/drift_exclusion_rules.dart';
import 'package:clipboard/base/data/drift/tables/drift_subscription.dart';
import 'package:clipboard/base/data/drift/tables/drift_sync_cursor.dart';
import 'package:clipboard/base/data/drift/tables/drift_sync_outbox_entry.dart';
import 'package:clipboard/base/data/drift/tables/drift_sync_status.dart';
import 'package:clipboard/base/domain/model/exclusion_rules/exclusion_rules.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'drift_database.g.dart';

@DriftDatabase(
  tables: [
    DriftAppConfigTable,
    DriftApplicationMetaTable,
    DriftClipCollectionTable,
    DriftClipboardItemTable,
    DriftSubscriptionTable,
    DriftSyncCursorTable,
    DriftSyncOutboxEntryTable,
    DriftSyncStatusTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    String? dbPath = Platform.environment[dbPathEnvKey];
    dbPath = dbPath ?? (await getApplicationDocumentsDirectory()).path;
    final file = File(p.join(dbPath, 'copycat_database.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
