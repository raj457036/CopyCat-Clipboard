import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/bloc/monetization_cubit/monetization_cubit.dart';
import 'package:clipboard/base/bloc/sync_status_cubit/sync_status_cubit.dart';
import 'package:clipboard/base/bloc/user_devices_cubit/user_devices_cubit.dart';
import 'package:clipboard/base/data/services/notification_service.dart';
import 'package:clipboard/base/data/services/post_sync_decryption_service.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/domain/model/subscription/subscription.dart';
import 'package:clipboard/base/domain/model/sync_status/syncstatus.dart';
import 'package:clipboard/base/domain/repositories/restoration_status.dart';
import 'package:clipboard/base/domain/services/sync_event_bus.dart';
import 'package:clipboard/base/sync/sync_orchestrator.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/globals.dart';
import 'package:clipboard/di/di.dart';
import 'package:clipboard/routes/routes.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _Config extends Fake implements AppConfigCubit {
  @override
  AppConfigState get state =>
      AppConfigState.loaded(config: AppConfig(enableSync: true));
}

class _Auth extends Fake implements AuthCubit {
  @override
  String? get userId => 'user';
}

class _Monetization extends Fake implements MonetizationCubit {
  @override
  Subscription? get active => null;
  @override
  MonetizationState get state => const MonetizationState.unknown();
}

class _Devices extends Fake implements UserDevicesCubit {
  Failure? failure;
  int checks = 0;
  @override
  Future<Failure?> ensureSyncReady({String? userId}) async {
    expect(userId, 'user');
    checks++;
    return failure;
  }
}

class _Orchestrator extends Fake implements SyncOrchestrator {
  int pushes = 0;
  int syncs = 0;
  @override
  Future<void> processOutboxes() async => pushes++;
  @override
  Future<bool> syncAll({
    bool force = false,
    bool freshPull = false,
    int? pullOffset,
  }) async {
    syncs++;
    return true;
  }
}

class _Decryption extends Fake implements PostSyncDecryptionService {
  @override
  bool get canDecrypt => false;
}

class _Restoration extends Fake implements RestorationStatusRepository {
  @override
  FailureOr<SyncStatus> setStatus(SyncStatus status) async => Right(status);
}

void main() {
  late _Devices devices;
  late _Orchestrator orchestrator;
  late SyncStatusCubit cubit;
  late SyncEventBus events;

  setUp(() async {
    await sl.reset();
    devices = _Devices();
    orchestrator = _Orchestrator();
    sl.registerSingleton<AppConfigCubit>(_Config());
    sl.registerSingleton<AuthCubit>(_Auth());
    sl.registerSingleton<UserDevicesCubit>(devices);
    events = SyncEventBus();
    cubit = SyncStatusCubit(
      orchestrator,
      events,
      _Monetization(),
      _Decryption(),
      _Restoration(),
    );
    await windowSizeStabilized.set(true);
  });

  tearDown(() async {
    InAppNotificationService.i.dismissAll();
    await cubit.close();
    events.dispose();
    await sl.reset();
  });

  testWidgets(
    'Sync now reports startup failure and allows immediate recovery',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: rootNavigationKey,
          scaffoldMessengerKey: InAppNotificationService.scaffoldMessengerKey,
          home: const Scaffold(body: SizedBox()),
        ),
      );
      devices.failure = const Failure(
        message: 'Account could not be verified',
        code: 'account-failed',
      );
      await cubit.syncAll(const SyncAllParams(force: true));
      await tester.pump();
      expect(cubit.state, isA<SyncStatusFailed>());
      expect(find.text('Account could not be verified'), findsOneWidget);
      expect(orchestrator.syncs, 0);

      devices.failure = null;
      final recovered = cubit.syncAll(const SyncAllParams(force: true));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await recovered;
      expect(devices.checks, 2);
      expect(orchestrator.syncs, 1);
      expect(cubit.state, isA<SyncStatusComplete>());
      InAppNotificationService.i.dismissAll();
      await tester.pump(const Duration(seconds: 5));
    },
  );

  test(
    'per-clip manual sync checks readiness and directly drains pending uploads',
    () async {
      await cubit.pushPending();
      expect(devices.checks, 1);
      expect(orchestrator.pushes, 1);
      expect(orchestrator.syncs, 0);
    },
  );

  testWidgets(
    'a pending idle-completion check cannot hide a manual sync failure',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: rootNavigationKey,
          scaffoldMessengerKey: InAppNotificationService.scaffoldMessengerKey,
          home: const Scaffold(body: SizedBox()),
        ),
      );
      events.emitEngineStatus('clip', false);
      await tester.pump();
      devices.failure = const Failure(
        message: 'Device access failed',
        code: 'device',
      );
      await cubit.pushPending();
      await tester.pump();
      expect(cubit.state, isA<SyncStatusFailed>());
      expect(orchestrator.pushes, 0);

      // Let the idle check (a real timer started before the failure) elapse;
      // it must not overwrite the failure with "complete".
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 600)),
      );
      await tester.pump();
      expect(cubit.state, isA<SyncStatusFailed>());

      devices.failure = null;
      await cubit.pushPending();
      expect(orchestrator.pushes, 1);
      InAppNotificationService.i.dismissAll();
      await tester.pump(const Duration(seconds: 5));
    },
  );

  testWidgets('background sync after a failure still reaches complete', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: rootNavigationKey,
        scaffoldMessengerKey: InAppNotificationService.scaffoldMessengerKey,
        home: const Scaffold(body: SizedBox()),
      ),
    );
    devices.failure = const Failure(message: 'Offline', code: 'offline');
    await cubit.pushPending();
    await tester.pump();
    expect(cubit.state, isA<SyncStatusFailed>());

    events.emitEngineStatus('clip', true);
    await tester.pump();
    expect(cubit.state, isA<SyncingStatus>());
    events.emitEngineStatus('clip', false);
    // The cubit's idle delay runs on a real timer (created in setUp), so let
    // wall-clock time pass instead of pumping the fake clock.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 600)),
    );
    await tester.pump();
    expect(cubit.state, isA<SyncStatusComplete>());
    InAppNotificationService.i.dismissAll();
    await tester.pump(const Duration(seconds: 5));
  });
}
