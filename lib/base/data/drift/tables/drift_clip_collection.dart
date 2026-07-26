import 'package:clipboard/base/data/drift/drift_database.dart';
import 'package:clipboard/base/domain/model/clip_collection/clipcollection.dart';
import 'package:drift/drift.dart';

@DataClassName('DriftClipCollectionEntry')
class DriftClipCollectionTable extends Table {
  @override
  String get tableName => 'clip_collection';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get serverId => integer().nullable()();
  DateTimeColumn get lastSynced => dateTime().nullable()();
  DateTimeColumn get created => dateTime()();
  DateTimeColumn get modified => dateTime()();
  TextColumn get userId => text()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  TextColumn get deviceId => text().nullable()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get emoji => text()();

  static ClipCollection toDomain(DriftClipCollectionEntry entry) => ClipCollection(
        id: entry.id,
        serverId: entry.serverId,
        lastSynced: entry.lastSynced,
        created: entry.created,
        modified: entry.modified,
        userId: entry.userId,
        deletedAt: entry.deletedAt,
        deviceId: entry.deviceId,
        title: entry.title,
        description: entry.description,
        emoji: entry.emoji,
      );

  static DriftClipCollectionTableCompanion fromDomain(ClipCollection collection) => DriftClipCollectionTableCompanion.insert(
        id: collection.id != null ? Value(collection.id!) : const Value.absent(),
        serverId: Value(collection.serverId),
        lastSynced: Value(collection.lastSynced),
        created: collection.created,
        modified: collection.modified,
        userId: collection.userId,
        deletedAt: Value(collection.deletedAt),
        deviceId: Value(collection.deviceId),
        title: collection.title,
        description: Value(collection.description),
        emoji: collection.emoji,
      );
}
