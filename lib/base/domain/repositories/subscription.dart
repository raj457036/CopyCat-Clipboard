import 'package:clipboard/base/common/failure.dart';
import 'package:clipboard/base/db/subscription/subscription.dart';

abstract class SubscriptionRepository {
  FailureOr<Subscription?> get({required String userId});
  FailureOr<Subscription?> applyPromoCoupon(String code);
}
