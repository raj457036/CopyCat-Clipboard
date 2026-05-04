import 'package:clipboard/base/domain/model/subscription/subscription.dart';
import 'package:isar_community/isar.dart';

part 'isar_subscription.g.dart';

@Name("Subscription")
@Collection()
class IsarSubscription {
  Id isarId = Isar.autoIncrement;
  int? serverId;
  late DateTime created;
  late DateTime modified;
  late String userId;
  late String planName;
  late String subId;
  late String source;
  DateTime? trialStart;
  DateTime? trialEnd;
  int collections = 3;
  int itemsPerCollection = 50;
  bool dragNdrop = false;
  bool theming = false;
  int syncHours = 24;
  bool ads = true;
  int syncInterval = 45;
  bool edit = false;
  DateTime? activeTill;
  int maxSyncDevices = 3;
  bool customExclusionRules = false;
  int pasteStackLimit = 10;
  int grants = 0;
  String? tkn;

  Subscription toDomain() => Subscription(
    id: isarId == Isar.autoIncrement ? null : isarId,
    serverId: serverId,
    created: created,
    modified: modified,
    userId: userId,
    planName: planName,
    subId: subId,
    source: source,
    trialStart: trialStart,
    trialEnd: trialEnd,
    collections: collections,
    itemsPerCollection: itemsPerCollection,
    dragNdrop: dragNdrop,
    theming: theming,
    syncHours: syncHours,
    ads: ads,
    syncInterval: syncInterval,
    edit: edit,
    activeTill: activeTill,
    maxSyncDevices: maxSyncDevices,
    customExclusionRules: customExclusionRules,
    pasteStackLimit: pasteStackLimit,
    grants: grants,
    tkn: tkn,
  );

  static IsarSubscription fromDomain(Subscription sub) => IsarSubscription()
    ..isarId = sub.id ?? Isar.autoIncrement
    ..serverId = sub.serverId
    ..created = sub.created
    ..modified = sub.modified
    ..userId = sub.userId
    ..planName = sub.planName
    ..subId = sub.subId
    ..source = sub.source
    ..trialStart = sub.trialStart
    ..trialEnd = sub.trialEnd
    ..collections = sub.collections
    ..itemsPerCollection = sub.itemsPerCollection
    ..dragNdrop = sub.dragNdrop
    ..theming = sub.theming
    ..syncHours = sub.syncHours
    ..ads = sub.ads
    ..syncInterval = sub.syncInterval
    ..edit = sub.edit
    ..activeTill = sub.activeTill
    ..maxSyncDevices = sub.maxSyncDevices
    ..customExclusionRules = sub.customExclusionRules
    ..pasteStackLimit = sub.pasteStackLimit
    ..grants = sub.grants
    ..tkn = sub.tkn;
}
