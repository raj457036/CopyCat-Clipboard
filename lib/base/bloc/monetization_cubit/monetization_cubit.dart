import 'package:bloc/bloc.dart';
import 'package:clipboard/base/common/failure.dart';
import 'package:clipboard/base/common/logging.dart';
import 'package:clipboard/base/data/services/monetization_service.dart';
import 'package:clipboard/base/db/subscription/subscription.dart';
import 'package:clipboard/base/domain/repositories/subscription.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'monetization_cubit.freezed.dart';
part 'monetization_state.dart';

@singleton
class MonetizationCubit extends Cubit<MonetizationState>
    with MonetizationService {
  final SubscriptionRepository repo;

  MonetizationCubit({
    required this.repo,
  }) : super(const MonetizationState.unknown()) {
    onSubscriptionAvailable = onSubscriptionChange;
    setupListeners();
  }

  @override
  Future<void> close() async {
    await super.close();
    stopListeners();
  }

  void onSubscriptionChange(Subscription subscription) {
    emit(MonetizationState.active(subscription: subscription));
  }

  Subscription? get active =>
      state.whenOrNull(active: (subscription) => subscription);

  Future<Failure?> applyPromoCode(String code) async {
    final result = await repo.applyPromoCoupon(code);
    return result.fold((l) => l, (subscription) {
      if (subscription == null) return;
      onSubscriptionChange(subscription);
      return null;
    });
  }

  Future<void> login(String userId) async {
    final done = await setUser(userId);
    if (!done) {
      final result = await repo.get(userId: userId);
      result.fold((l) => logger.e(l), (subscription) {
        if (subscription == null) return;
        onSubscriptionChange(subscription);
      });
    }
  }

  Future<void> logout() async {
    emit(const MonetizationState.unknown());
  }
}
