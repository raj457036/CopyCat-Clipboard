import 'package:clipboard/base/constants/numbers/duration.dart';
import 'package:clipboard/base/db/base.dart';
import 'package:clipboard/base/db/json_converters/datetime_converters.dart';
import 'package:clipboard/base/utils/utility.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar_community/isar.dart';

part 'subscription.freezed.dart';
part 'subscription.g.dart';

@Collection(ignore: {"copyWith"})
@freezed
class Subscription with _$Subscription, IsarIdMixin {
  Subscription._();

  factory Subscription({
    @JsonKey(name: "id", includeToJson: false) int? serverId,
    @JsonKey(name: "created") @DateTimeConverter() required DateTime created,
    @JsonKey(name: "modified") @DateTimeConverter() required DateTime modified,
    required String userId,
    required String planName,
    required String subId,
    required String source,
    @DateTimeConverter() DateTime? trialStart,
    @DateTimeConverter() DateTime? trialEnd,
    @Default(3) int collections,
    @Default(50) int itemsPerCollection,
    @Default(false) bool dragNdrop,
    @Default(false) bool theming,
    @JsonKey(name: "syncHr") @Default(24) int syncHours,
    @Default(true) bool ads,
    @JsonKey(name: "syncInt") @Default($45S) int syncInterval,
    @Default(false) bool edit,
    @DateTimeConverter() DateTime? activeTill,
    @JsonKey(name: "devices") @Default(3) int maxSyncDevices,
    @JsonKey(name: "cers") @Default(false) bool customExclusionRules,
    @Default(0) int grants,
    String? tkn,
    // local state
    @ignore
    @JsonKey(includeFromJson: false, includeToJson: false)
    String? managementUrl,
  }) = _Subscription;

  @ignore
  bool get isTrial {
    return trialStart != null && trialEnd != null && subId == "Trial";
  }

  @ignore
  bool get isFree => planName == "Free";

  @ignore
  bool get isActive {
    if (planName == "Free") return true;
    if (subId == "Trial") {
      return (trialStart != null && trialStart!.isBefore(now())) &&
          (trialEnd != null && trialEnd!.isAfter(now()));
    }
    return (activeTill != null && activeTill!.isAfter(now()));
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
        edit == other.edit &&
        activeTill == other.activeTill &&
        maxSyncDevices == other.maxSyncDevices &&
        customExclusionRules == other.customExclusionRules &&
        tkn == other.tkn &&
        grants == other.grants;
  }

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);
}
