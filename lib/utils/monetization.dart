import 'package:clipboard/base/db/subscription/subscription.dart';
import 'package:clipboard/base/utils/utility.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

Future<void> presentPaywall() async {
  await RevenueCatUI.presentPaywall(
    displayCloseButton: true,
  );
}

Subscription generateFreePlan(String userId) {
  return Subscription(
    created: now(),
    modified: now(),
    userId: userId,
    planName: "Free",
    subId: "",
    source: "",
  );
}

Subscription generateProPlan(
  String userId,
  DateTime activeTill, [
  bool isPromo = false,
  String? managementUrl,
]) {
  return Subscription(
    created: now(),
    modified: now(),
    userId: userId,
    planName: "PRO ✨",
    subId: "",
    source: isPromo ? "PROMO" : "",
    activeTill: activeTill,
    ads: false,
    collections: 50,
    itemsPerCollection: 500,
    dragNdrop: true,
    theming: true,
    syncHours: 720,
    syncInterval: 5,
    maxSyncDevices: 5,
    edit: true,
    managementUrl: managementUrl,
    customExclusionRules: true,
  );
}
