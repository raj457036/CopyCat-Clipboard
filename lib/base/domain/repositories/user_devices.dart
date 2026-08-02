import 'package:clipboard/base/domain/model/sync/user_device_access.dart';
import 'package:clipboard/common/failure.dart';

abstract class UserDevicesRepository {
  /// Registers the current device for sync access.
  /// Returns the access status of the device after registration.
  FailureOr<DeviceRegistrationResult> registerCurrentDevice({
    required String deviceId,
    required String platform,
    String? appVersion,
  });

  /// Fetches the list of devices registered for the current user
  /// along with their access status.
  FailureOr<DeviceListResult> listDevices();

  /// Persists a user-facing name for the current device.
  FailureOr<void> updateDeviceName({required String deviceId, String? name});

  /// Revokes sync access for the specified device.
  FailureOr<void> revokeDevice(String deviceId);
}
