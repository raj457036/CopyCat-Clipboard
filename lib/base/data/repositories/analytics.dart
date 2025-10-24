import 'package:clipboard/base/domain/model/auth_user/auth_user.dart';
import 'package:clipboard/base/domain/repositories/analytics.dart';
import 'package:clipboard/base/utils/utility.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AnalyticsRepository)
class AnalyticsRepositoryImpl implements AnalyticsRepository {
  const AnalyticsRepositoryImpl();

  @override
  Future<void> logAnalyticsEvent({
    required String name,
    required Map<String, Object> parameters,
  }) async {
    if (!isAnalyticsSupported) return;
  }

  @override
  Future<void> logFeatureUsed({
    required String feature,
    Map<String, dynamic>? parameters,
  }) async {
    if (!isAnalyticsSupported) return;
  }

  @override
  Future<void> logSignin({
    required String loginMethod,
    required Map<String, Object> parameters,
  }) async {
    if (!isAnalyticsSupported) return;
    // TODO(raj): implement it with some other provider or self host?
  }

  @override
  Future<void> logSignup({
    required String signUpMethod,
    required Map<String, Object> parameters,
  }) async {
    if (!isAnalyticsSupported) return;
    // TODO(raj): implement it with someother provider or self host?
  }

  @override
  Future<void> setAnalyticUser(AuthUser user) async {
    if (!isAnalyticsSupported) return;
    // TODO(raj): implement it with someother provider or self host?
  }
}
