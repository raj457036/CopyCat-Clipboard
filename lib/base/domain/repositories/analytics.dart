import 'package:clipboard/base/domain/model/auth_user/auth_user.dart';

abstract class AnalyticsRepository {
  Future<void> setAnalyticUser(AuthUser user);
  Future<void> logFeatureUsed({
    required String feature,
    Map<String, dynamic>? parameters,
  });
  Future<void> logAnalyticsEvent({
    required String name,
    required Map<String, Object> parameters,
  });
  Future<void> logSignup({
    required String signUpMethod,
    required Map<String, Object> parameters,
  });
  Future<void> logSignin({
    required String loginMethod,
    required Map<String, Object> parameters,
  });
}
