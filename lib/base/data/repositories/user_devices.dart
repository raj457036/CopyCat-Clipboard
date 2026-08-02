import 'package:clipboard/base/domain/model/sync/user_device_access.dart';
import 'package:clipboard/base/domain/repositories/user_devices.dart';
import 'package:clipboard/base/domain/sources/user_devices.dart';
import 'package:clipboard/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@LazySingleton(as: UserDevicesRepository)
class UserDevicesRepositoryImpl implements UserDevicesRepository {
  final UserDevicesSource remote;
  final SupabaseClient client;

  UserDevicesRepositoryImpl(@Named('remote') this.remote, this.client);

  String _currentUserId() {
    final uid = client.auth.currentUser?.id;
    if (uid == null) throw authFailure;
    return uid;
  }

  @override
  FailureOr<DeviceRegistrationResult> registerCurrentDevice({
    required String deviceId,
    required String platform,
    String? appVersion,
  }) async {
    try {
      final userId = _currentUserId();
      final result = await remote.registerDevice(
        userId: userId,
        deviceId: deviceId,
        platform: platform,
        appVersion: appVersion,
      );
      return Right(result);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<DeviceListResult> listDevices() async {
    try {
      final userId = _currentUserId();
      final result = await remote.listDevices(userId: userId);
      return Right(result);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<void> updateDeviceName({
    required String deviceId,
    String? name,
  }) async {
    try {
      final userId = _currentUserId();
      final result = await remote.updateDeviceName(
        userId: userId,
        deviceId: deviceId,
        name: name,
      );
      return Right(result);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<void> revokeDevice(String deviceId) async {
    try {
      final userId = _currentUserId();
      final result = await remote.revokeDevice(
        userId: userId,
        deviceId: deviceId,
      );
      return Right(result);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
