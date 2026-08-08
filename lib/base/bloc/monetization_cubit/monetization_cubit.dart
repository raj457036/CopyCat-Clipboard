import 'package:bloc/bloc.dart';
import 'package:clipboard/base/data/services/monetization_service.dart';
import 'package:clipboard/base/domain/model/subscription/subscription.dart';
import 'package:clipboard/base/domain/repositories/subscription.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/logging.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'monetization_cubit.freezed.dart';
part 'monetization_state.dart';

@singleton
class MonetizationCubit extends Cubit<MonetizationState>
    with MonetizationService {
  final SubscriptionRepository repo;

  bool _isListenersSetUp = false;

  MonetizationCubit({required this.repo})
    : super(const MonetizationState.unknown());

  @override
  Future<void> onSubscriptionAvailable(Subscription subscription) async {
    onSubscriptionChange(subscription);
  }

  @override
  Future<void> close() async {
    await super.close();
    stopListeners();
  }

  void onSubscriptionChange(Subscription subscription) {
    if (state is MonetizationActive) {
      final currentSubscription = (state as MonetizationActive).subscription;
      if (currentSubscription == subscription) return;
    }
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
    final result = await repo.get(userId: userId);
    result.fold(
      (l) {
        logger.e(l);
        return null;
      },
      (subscription) {
        if (subscription == null) return null;
        onSubscriptionChange(subscription);
      },
    );

    if (_isListenersSetUp) return;
    setupListeners();
    final done = await setUser(userId);

    if (!done) return;
    _isListenersSetUp = true;
  }

  Future<void> logout() async {
    emit(const MonetizationState.unknown());
    stopListeners();
    _isListenersSetUp = false;
  }
}
