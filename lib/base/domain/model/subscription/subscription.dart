import 'package:clipboard/base/constants/numbers/values.dart'
    show
        defaultPasteStackLimit,
        defaultSyncHourOffset,
        defaultMaxItemPerCollection,
        defaultCollectionCount,
        defaultNoOfSyncedDevices,
        defaultBestEffortSyncInterval;
import 'package:clipboard/base/domain/model/base.dart';
import 'package:clipboard/base/domain/model/json_converters/datetime_converters.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription.freezed.dart';
part 'subscription.g.dart';

@freezed
abstract class Subscription with _$Subscription, Identifiable {
  Subscription._();

  factory Subscription({
    @JsonKey(includeToJson: false, includeFromJson: false) int? id,
    @JsonKey(name: "id", includeToJson: false) int? serverId,
    @JsonKey(name: "created") @DateTimeConverter() required DateTime created,
    @JsonKey(name: "modified") @DateTimeConverter() required DateTime modified,
    required String userId,
    required String planName,
    required String subId,
    required String source,
    @DateTimeConverter() DateTime? trialStart,
    @DateTimeConverter() DateTime? trialEnd,
    @Default(defaultCollectionCount) int collections,
    @Default(defaultMaxItemPerCollection) int itemsPerCollection,
    @JsonKey(name: "drag_n_drop") @Default(false) bool dragNdrop,
    @Default(false) bool theming,
    @JsonKey(name: "syncHr") @Default(defaultSyncHourOffset) int syncHours,
    @Default(true) bool ads,
    @JsonKey(name: "syncInt")
    @Default(defaultBestEffortSyncInterval)
    int syncInterval,
    @DateTimeConverter() DateTime? activeTill,
    @JsonKey(name: "devices")
    @Default(defaultNoOfSyncedDevices)
    int maxSyncDevices,
    @JsonKey(name: "cers") @Default(false) bool customExclusionRules,
    @JsonKey(name: "ps_limit")
    @Default(defaultPasteStackLimit)
    int pasteStackLimit,
    @Default(0) int grants,
    String? tkn,
    // local state
    @JsonKey(includeFromJson: false, includeToJson: false)
    String? managementUrl,
  }) = _Subscription;

  bool get isTrial {
    return trialStart != null && trialEnd != null && subId == "Trial";
  }

  bool get isFree => planName == "Free";

  /// Returns true if the subscription is active, false otherwise.
  bool get isActive {
    if (planName == "Free") return true;
    if (subId == "Trial") {
      return (trialStart != null && trialStart!.isBefore(systemTime())) &&
          (trialEnd != null && trialEnd!.isAfter(systemTime()));
    }
    return (activeTill != null && activeTill!.isAfter(systemTime()));
  }

  bool isSameAs(Subscription other) {
    return planName == other.planName &&
        subId == other.subId &&
        source == other.source &&
        trialStart == other.trialStart &&
        trialEnd == other.trialEnd &&
        collections == other.collections &&
        itemsPerCollection == other.itemsPerCollection &&
        dragNdrop == other.dragNdrop &&
        theming == other.theming &&
        syncHours == other.syncHours &&
        ads == other.ads &&
        syncInterval == other.syncInterval &&
        activeTill == other.activeTill &&
        maxSyncDevices == other.maxSyncDevices &&
        customExclusionRules == other.customExclusionRules &&
        tkn == other.tkn &&
        grants == other.grants &&
        userId == other.userId;
  }

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);
}
