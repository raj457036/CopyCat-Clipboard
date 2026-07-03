import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/domain/model/subscription/subscription.dart';
import 'package:clipboard/common/logging.dart' show logger;
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:universal_io/io.dart';

mixin MonetizationService {
  bool _setupDone = false;
  bool _listenersSetup = false;

  Future<void> onSubscriptionAvailable(Subscription subscription) {
    throw UnimplementedError(
      "onSubscriptionAvailable must be implemented in the class that mixes in MonetizationService",
    );
  }

  void setupListeners() {
    if (iapCatSupportedPlatform && !_listenersSetup) {
      Purchases.addCustomerInfoUpdateListener(onCustomerInfoUpdate);
      _listenersSetup = true;
    }
  }

  void stopListeners() {
    if (iapCatSupportedPlatform && _listenersSetup) {
      Purchases.removeCustomerInfoUpdateListener(onCustomerInfoUpdate);
      _listenersSetup = false;
    }
  }

  void onCustomerInfoUpdate(CustomerInfo info) {
    if (!_listenersSetup) return;
    final subscription = info.toSubscription();
    onSubscriptionAvailable(subscription);
  }

  Future<void> setupRevenuCat(String userId) async {
    await Purchases.setLogLevel(kDebugMode ? LogLevel.debug : LogLevel.info);

    PurchasesConfiguration? configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(revenueCatAndroidPublicKey)
        ..appUserID = userId;
    } else if (Platform.isIOS || Platform.isMacOS) {
      configuration = PurchasesConfiguration(revenueCatApplePublicKey)
        ..appUserID = userId;
    }
    if (configuration != null) {
      await Purchases.configure(configuration);
      _setupDone = true;
    }
  }

  Future<bool> setUser(String userId) async {
    if (iapCatSupportedPlatform) {
      if (!_setupDone) {
        await setupRevenuCat(userId);
      }

      if (!_setupDone) return false;

      try {
        final loginResult = await Purchases.logIn(userId);
        final result = loginResult.customerInfo;
        onCustomerInfoUpdate(result);
      } catch (e) {
        logger.e("Couldn't get customer info", error: e);
        return false;
      }
      return true;
    }
    return false;
  }
}
