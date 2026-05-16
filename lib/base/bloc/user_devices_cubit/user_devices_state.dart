import 'package:clipboard/base/domain/model/sync/user_device_access.dart';
import 'package:clipboard/common/failure.dart';

enum DeviceAccessStatus { unknown, allowed, limitReached, verificationFailed }

class UserDevicesState {
  final bool isLoading;
  final bool isRegistering;
  final DeviceListResult? deviceList;
  final Failure? failure;
  final DeviceAccessStatus accessStatus;

  const UserDevicesState({
    this.isLoading = false,
    this.isRegistering = false,
    this.deviceList,
    this.failure,
    this.accessStatus = DeviceAccessStatus.unknown,
  });

  UserDevicesState copyWith({
    bool? isLoading,
    bool? isRegistering,
    DeviceListResult? deviceList,
    bool clearDeviceList = false,
    Failure? failure,
    bool clearFailure = false,
    DeviceAccessStatus? accessStatus,
  }) {
    return UserDevicesState(
      isLoading: isLoading ?? this.isLoading,
      isRegistering: isRegistering ?? this.isRegistering,
      deviceList: clearDeviceList ? null : (deviceList ?? this.deviceList),
      failure: clearFailure ? null : (failure ?? this.failure),
      accessStatus: accessStatus ?? this.accessStatus,
    );
  }
}
