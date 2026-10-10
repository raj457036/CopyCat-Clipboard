import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/monetization_cubit/monetization_cubit.dart';
import 'package:clipboard/base/bloc/user_devices_cubit/user_devices_cubit.dart';
import 'package:clipboard/base/bloc/user_devices_cubit/user_devices_state.dart';
import 'package:clipboard/base/domain/model/sync/user_device_access.dart';
import 'package:clipboard/base/domain/repositories/user_devices.dart';
import 'package:clipboard/base/sync/sync_orchestrator.dart';
import 'package:clipboard/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

class _FakeSyncOrchestrator extends Fake implements SyncOrchestrator {}

class _FakeAppConfigCubit extends Fake implements AppConfigCubit {}

class _FakeMonetizationCubit extends Fake implements MonetizationCubit {}

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

  @override
  FailureOr<DeviceRegistrationResult> registerCurrentDevice({
    required String deviceId,
    required String platform,
    String? appVersion,
    String? deviceName,
  }) async {
    lastRegisteredDeviceName = deviceName;
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
}
