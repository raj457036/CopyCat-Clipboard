import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/bloc/clip_collection_cubit/clip_collection_cubit.dart';
import 'package:clipboard/base/bloc/monetization_cubit/monetization_cubit.dart';
import 'package:clipboard/base/constants/numbers/values.dart';
import 'package:clipboard/base/domain/model/clip_collection/clipcollection.dart';
import 'package:clipboard/base/domain/model/subscription/subscription.dart';
import 'package:clipboard/base/domain/repositories/clip_collection.dart';
import 'package:clipboard/base/domain/repositories/subscription.dart';
import 'package:clipboard/base/domain/services/sync_event_bus.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/utils/monetization.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeSubscriptionRepo implements SubscriptionRepository {
  @override
  FailureOr<Subscription?> get({required String userId}) async => const Right(null);

  @override
  FailureOr<Subscription?> applyPromoCoupon(String code) async => const Right(null);
}

class _FakeAuthCubit extends Fake implements AuthCubit {}

class _FakeClipCollectionRepo extends Fake implements ClipCollectionRepository {}

void main() {
  group('ClipCollectionCubit - Plan Limit and Reset', () {
    late SyncEventBus syncEventBus;
    late MonetizationCubit monetizationCubit;
    late ClipCollectionCubit cubit;

    setUp(() {
      syncEventBus = SyncEventBus();
      monetizationCubit = MonetizationCubit(repo: _FakeSubscriptionRepo());
      cubit = ClipCollectionCubit(
        syncEventBus,
        _FakeAuthCubit(),
        _FakeClipCollectionRepo(),
        'test_device',
        monetizationCubit,
      );
    });

    tearDown(() async {
      await cubit.close();
      await monetizationCubit.close();
      syncEventBus.dispose();
    });

    test('initializes activeLimit to defaultCollectionCount when monetization is unknown', () {
      expect(cubit.state.activeLimit, defaultCollectionCount);
    });

    test('updates activeLimit when monetization emits an active Pro plan', () async {
      final proPlan = generateProPlan(
        'user_123',
        systemTime().add(const Duration(days: 30)),
      );

      monetizationCubit.onSubscriptionChange(proPlan);
      // Wait for stream event to propagate
      await pumpEventQueue();

      expect(cubit.state.activeLimit, 50);
    });

    test('reset clears collections and keeps monetization activeLimit intact', () async {
      final proPlan = generateProPlan(
        'user_123',
        systemTime().add(const Duration(days: 30)),
      );

      monetizationCubit.onSubscriptionChange(proPlan);
      await pumpEventQueue();
      expect(cubit.state.activeLimit, 50);

      // Simulate collections loaded
      cubit.emit(
        cubit.state.copyWith(
          collections: [
            ClipCollection(
              title: 'Collection 1',
              deviceId: 'test_device',
              userId: 'user_123',
              created: systemTime(),
              modified: systemTime(),
              description: '',
              emoji: '📁',
            ),
          ],
        ),
      );
      expect(cubit.state.collections.length, 1);

      // Call reset (e.g. on logout)
      cubit.reset();

      expect(cubit.state.collections, isEmpty);
      expect(cubit.state.activeLimit, 50);

      // Verify stream is still alive and responds to further monetization events
      final freePlan = generateFreePlan('user_123');
      monetizationCubit.onSubscriptionChange(freePlan);
      await pumpEventQueue();

      expect(cubit.state.activeLimit, defaultCollectionCount);
    });
  });
}
