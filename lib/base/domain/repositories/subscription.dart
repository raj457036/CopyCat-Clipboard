import 'package:clipboard/base/domain/model/subscription/subscription.dart';
import 'package:clipboard/common/failure.dart';

abstract class SubscriptionRepository {
  FailureOr<Subscription?> get({required String userId});
  FailureOr<Subscription?> applyPromoCoupon(String code);
}
