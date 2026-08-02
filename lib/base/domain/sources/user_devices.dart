import 'package:clipboard/base/domain/model/sync/user_device_access.dart';

abstract class UserDevicesSource {
  Future<DeviceRegistrationResult> registerDevice({
    required String userId,
    required String deviceId,
    required String platform,
    String? appVersion,
  });

  Future<DeviceListResult> listDevices({required String userId});

  Future<void> updateDeviceName({
    required String userId,
    required String deviceId,
    String? name,
  });

  Future<void> revokeDevice({required String userId, required String deviceId});
}
