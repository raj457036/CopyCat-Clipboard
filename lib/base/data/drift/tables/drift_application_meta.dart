import 'package:clipboard/base/data/drift/drift_database.dart';
import 'package:clipboard/base/domain/model/application_meta/application_meta.dart';
import 'package:clipboard/base/enums/platform_os.dart';
import 'package:drift/drift.dart';

@DataClassName('DriftApplicationMetaEntry')
class DriftApplicationMetaTable extends Table {
  @override
  String get tableName => 'application_meta';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get sourceId => text().unique()();
  TextColumn get identifier => text().nullable()();
  TextColumn get appName => text().nullable()();
  TextColumn get appFilePath => text().nullable()();
  TextColumn get os => text()();
  TextColumn get iconLocalPath => text().nullable()();
  TextColumn get iconRemotePath => text().nullable()();
  DateTimeColumn get created => dateTime()();
  DateTimeColumn get modified => dateTime()();

  static ApplicationMeta toDomain(DriftApplicationMetaEntry entry) => ApplicationMeta(
        id: entry.id,
        sourceId: entry.sourceId,
        identifier: entry.identifier,
        appName: entry.appName,
        appFilePath: entry.appFilePath,
        os: PlatformOS.values.firstWhere(
          (e) => e.name == entry.os,
          orElse: () => PlatformOS.macos,
        ),
        iconLocalPath: entry.iconLocalPath,
        iconRemotePath: entry.iconRemotePath,
        created: entry.created,
        modified: entry.modified,
      );

  static DriftApplicationMetaTableCompanion fromDomain(ApplicationMeta item) => DriftApplicationMetaTableCompanion.insert(
        id: item.id != null ? Value(item.id!) : const Value.absent(),
        sourceId: item.sourceId,
        identifier: Value(item.identifier),
        appName: Value(item.appName),
        appFilePath: Value(item.appFilePath),
        os: item.os.name,
        iconLocalPath: Value(item.iconLocalPath),
        iconRemotePath: Value(item.iconRemotePath),
        created: item.created,
        modified: item.modified,
      );
}
