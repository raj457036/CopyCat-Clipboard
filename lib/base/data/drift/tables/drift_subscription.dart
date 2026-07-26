import 'package:clipboard/base/data/drift/drift_database.dart';
import 'package:clipboard/base/domain/model/subscription/subscription.dart';
import 'package:drift/drift.dart';

@DataClassName('DriftSubscriptionEntry')
class DriftSubscriptionTable extends Table {
  @override
  String get tableName => 'subscription';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get serverId => integer().nullable()();
  DateTimeColumn get created => dateTime()();
  DateTimeColumn get modified => dateTime()();
  TextColumn get userId => text()();
  TextColumn get planName => text()();
  TextColumn get subId => text()();
  TextColumn get source => text()();
  DateTimeColumn get trialStart => dateTime().nullable()();
  DateTimeColumn get trialEnd => dateTime().nullable()();
  IntColumn get collections => integer().withDefault(const Constant(3))();
  IntColumn get itemsPerCollection => integer().withDefault(const Constant(50))();
  BoolColumn get dragNdrop => boolean().withDefault(const Constant(false))();
  BoolColumn get theming => boolean().withDefault(const Constant(false))();
  IntColumn get syncHours => integer().withDefault(const Constant(24))();
  BoolColumn get ads => boolean().withDefault(const Constant(true))();
  IntColumn get syncInterval => integer().withDefault(const Constant(45))();
  BoolColumn get edit => boolean().withDefault(const Constant(false))();
  DateTimeColumn get activeTill => dateTime().nullable()();
  IntColumn get maxSyncDevices => integer().withDefault(const Constant(3))();
  BoolColumn get customExclusionRules => boolean().withDefault(const Constant(false))();
  IntColumn get pasteStackLimit => integer().withDefault(const Constant(10))();
  IntColumn get grants => integer().withDefault(const Constant(0))();
  TextColumn get tkn => text().nullable()();

  static Subscription toDomain(DriftSubscriptionEntry entry) => Subscription(
        id: entry.id,
        serverId: entry.serverId,
        created: entry.created,
        modified: entry.modified,
        userId: entry.userId,
        planName: entry.planName,
        subId: entry.subId,
        source: entry.source,
        trialStart: entry.trialStart,
        trialEnd: entry.trialEnd,
        collections: entry.collections,
        itemsPerCollection: entry.itemsPerCollection,
        dragNdrop: entry.dragNdrop,
        theming: entry.theming,
        syncHours: entry.syncHours,
        ads: entry.ads,
        syncInterval: entry.syncInterval,
        edit: entry.edit,
        activeTill: entry.activeTill,
        maxSyncDevices: entry.maxSyncDevices,
        customExclusionRules: entry.customExclusionRules,
        pasteStackLimit: entry.pasteStackLimit,
        grants: entry.grants,
        tkn: entry.tkn,
      );

  static DriftSubscriptionTableCompanion fromDomain(Subscription sub) => DriftSubscriptionTableCompanion.insert(
        id: sub.id != null ? Value(sub.id!) : const Value.absent(),
        serverId: Value(sub.serverId),
        created: sub.created,
        modified: sub.modified,
        userId: sub.userId,
        planName: sub.planName,
        subId: sub.subId,
        source: sub.source,
        trialStart: Value(sub.trialStart),
        trialEnd: Value(sub.trialEnd),
        collections: Value(sub.collections),
        itemsPerCollection: Value(sub.itemsPerCollection),
        dragNdrop: Value(sub.dragNdrop),
        theming: Value(sub.theming),
        syncHours: Value(sub.syncHours),
        ads: Value(sub.ads),
        syncInterval: Value(sub.syncInterval),
        edit: Value(sub.edit),
        activeTill: Value(sub.activeTill),
        maxSyncDevices: Value(sub.maxSyncDevices),
        customExclusionRules: Value(sub.customExclusionRules),
        pasteStackLimit: Value(sub.pasteStackLimit),
        grants: Value(sub.grants),
        tkn: Value(sub.tkn),
      );
}
