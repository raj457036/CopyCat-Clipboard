import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/monetization_cubit/monetization_cubit.dart';
import 'package:clipboard/base/bloc/user_devices_cubit/user_devices_cubit.dart';
import 'package:clipboard/base/bloc/user_devices_cubit/user_devices_state.dart';
import 'package:clipboard/base/domain/model/sync/user_device_access.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/domain/model/subscription/subscription.dart';
import 'package:clipboard/base/domain/repositories/user_devices.dart';
import 'package:clipboard/base/sync/sync_orchestrator.dart';
import 'package:clipboard/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

class _FakeSyncOrchestrator extends Fake implements SyncOrchestrator {}

class _FakeAppConfigCubit extends Fake implements AppConfigCubit {}

class _FakeMonetizationCubit extends Fake implements MonetizationCubit {}

class _ReadyOrchestrator extends Fake implements SyncOrchestrator {
  bool running = false;
  int starts = 0;
  @override
  bool get isRunning => running;
  @override
  void start({SyncSpeed syncSpeed = SyncSpeed.balanced, int? intervalSeconds}) {
    running = true;
    starts++;
  }
}

class _ReadyConfig extends Fake implements AppConfigCubit {
  bool enabled = true;
  @override
  AppConfigState get state =>
      AppConfigState.loaded(config: AppConfig(enableSync: enabled));
  @override
  Future<AppConfigState> load([Subscription? subscription]) async => state;
}

class _ReadyMonetization extends Fake implements MonetizationCubit {
  Subscription? subscription;
  Failure? failure;
  int refreshes = 0;
  @override
  Subscription? get active => subscription;
  @override
  Future<Failure?> refreshSubscription(String userId) async {
    refreshes++;
    if (failure != null) return failure;
    subscription = Subscription(
      created: DateTime.now(),
      modified: DateTime.now(),
      userId: userId,
      planName: 'Core',
      subId: 'core',
      source: 'test',
    );
    return null;
  }
}

class _MockUserDevicesRepo implements UserDevicesRepository {
  DeviceRegistrationResult registrationResult = const DeviceRegistrationResult(
    allowed: true,
    limit: 5,
    activeCount: 1,
    devices: [],
  );

  DeviceListResult listResult = const DeviceListResult(
    devices: [],
    limit: 5,
    activeCount: 1,
  );

  final List<String?> updatedNames = [];
  String? lastRegisteredDeviceName;
  int listDevicesCallCount = 0;
  int registrationCalls = 0;
  Failure? registrationFailure;

  @override
  FailureOr<DeviceRegistrationResult> registerCurrentDevice({
    required String deviceId,
    required String platform,
    String? appVersion,
    String? deviceName,
  }) async {
    lastRegisteredDeviceName = deviceName;
    registrationCalls++;
    if (registrationFailure case final failure?) return left(failure);
    return right(registrationResult);
  }

  @override
  FailureOr<DeviceListResult> listDevices() async {
    listDevicesCallCount++;
    return right(listResult);
  }

  @override
  FailureOr<void> updateDeviceName({
    required String deviceId,
    String? name,
  }) async {
    updatedNames.add(name);
    return right(null);
  }

  @override
  FailureOr<void> revokeDevice(String deviceId) async {
    return right(null);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockUserDevicesRepo repo;
  late PackageInfo packageInfo;
  const testDeviceId = 'test-device-123456';

  setUp(() {
    repo = _MockUserDevicesRepo();
    packageInfo = PackageInfo(
      appName: 'CopyCat',
      packageName: 'com.copycat',
      version: '2.0.14',
      buildNumber: '108',
    );
  });

  UserDevicesCubit createCubit() {
    return UserDevicesCubit(
      repo: repo,
      packageInfo: packageInfo,
      deviceId: testDeviceId,
      syncOrchestrator: _FakeSyncOrchestrator(),
      appConfigCubit: _FakeAppConfigCubit(),
      monetizationCubit: _FakeMonetizationCubit(),
    );
  }

  group('UserDevicesCubit - Device Registration & Naming', () {
    test(
      'passes default platform name to registerCurrentDevice without calling updateDeviceName',
      () async {
        final cubit = createCubit();

        final status = await cubit.registerCurrentDevice();

        expect(status, equals(DeviceAccessStatus.allowed));
        expect(repo.lastRegisteredDeviceName, isNotEmpty);
        // registration itself should not trigger an extra updateDeviceName call
        expect(repo.updatedNames, isEmpty);
        await cubit.close();
      },
    );

    test(
      'getDeviceName returns the custom name when present in deviceList',
      () async {
        final cubit = createCubit();

        repo.listResult = DeviceListResult(
          devices: [
            SyncDeviceInfo(
              deviceId: testDeviceId,
              platform: 'macos',
              appVersion: '2.0.14+108',
              name: 'My Custom MacBook',
              lastSeenAt: DateTime.now(),
              isRevoked: false,
            ),
          ],
          limit: 5,
          activeCount: 1,
        );

        await cubit.fetchDevices();

        expect(cubit.getDeviceName(testDeviceId), equals('My Custom MacBook'));
        await cubit.close();
      },
    );

    test(
      'getDeviceName returns null when device has no name in deviceList',
      () async {
        final cubit = createCubit();

        repo.listResult = DeviceListResult(
          devices: [
            SyncDeviceInfo(
              deviceId: testDeviceId,
              platform: 'macos',
              appVersion: '2.0.14+108',
              name: null,
              lastSeenAt: DateTime.now(),
              isRevoked: false,
            ),
          ],
          limit: 5,
          activeCount: 1,
        );

        await cubit.fetchDevices();

        expect(cubit.getDeviceName(testDeviceId), isNull);
        await cubit.close();
      },
    );
  });

  group('Sync readiness recovery', () {
    late _ReadyOrchestrator orchestrator;
    late _ReadyConfig config;
    late _ReadyMonetization monetization;
    late UserDevicesCubit cubit;

    setUp(() {
      orchestrator = _ReadyOrchestrator();
      config = _ReadyConfig();
      monetization = _ReadyMonetization();
      cubit = UserDevicesCubit(
        repo: repo,
        packageInfo: packageInfo,
        deviceId: testDeviceId,
        syncOrchestrator: orchestrator,
        appConfigCubit: config,
        monetizationCubit: monetization,
      );
    });

    tearDown(() => cubit.close());

    test(
      'manual recovery refreshes account, verifies device, then starts',
      () async {
        expect(await cubit.ensureSyncReady(userId: 'user'), isNull);
        expect(monetization.refreshes, 1);
        expect(repo.registrationCalls, 1);
        expect(orchestrator.running, isTrue);
      },
    );

    test('concurrent startup and manual recovery only start once', () async {
      expect(
        await Future.wait([
          cubit.ensureSyncReady(userId: 'user'),
          cubit.ensureSyncReady(userId: 'user'),
        ]),
        [null, null],
      );
      expect(orchestrator.starts, 1);
      expect(repo.registrationCalls, 1);
    });

    test(
      'account failure is explicit and a later attempt can recover',
      () async {
        monetization.failure = const Failure(
          message: 'Account fetch failed',
          code: 'account-failed',
        );
        expect(
          (await cubit.ensureSyncReady(userId: 'user'))!.code,
          'account-failed',
        );
        expect(orchestrator.running, isFalse);
        expect(repo.registrationCalls, 0);
        monetization.failure = null;
        expect(await cubit.ensureSyncReady(userId: 'user'), isNull);
        expect(orchestrator.running, isTrue);
      },
    );

    test('device rejection never starts the processor', () async {
      repo.registrationResult = const DeviceRegistrationResult(
        allowed: false,
        limit: 1,
        activeCount: 1,
        devices: [],
      );
      expect(
        (await cubit.ensureSyncReady(userId: 'user'))!.code,
        'sync-device-not-allowed',
      );
      expect(orchestrator.running, isFalse);
    });

    test('disabled sync is not bypassed by manual recovery', () async {
      config.enabled = false;
      expect(
        (await cubit.ensureSyncReady(userId: 'user'))!.code,
        'sync-disabled',
      );
      expect(monetization.refreshes, 0);
      expect(repo.registrationCalls, 0);
      expect(orchestrator.running, isFalse);
    });
  });
}
