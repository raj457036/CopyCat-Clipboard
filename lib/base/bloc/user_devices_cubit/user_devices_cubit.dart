import 'package:bloc/bloc.dart';
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/monetization_cubit/monetization_cubit.dart';
import 'package:clipboard/base/bloc/user_devices_cubit/user_devices_state.dart';
import 'package:clipboard/base/constants/numbers/values.dart';
import 'package:clipboard/base/data/services/notification_service.dart';
import 'package:clipboard/base/domain/model/notification_message.dart';
import 'package:clipboard/base/domain/model/sync/user_device_access.dart';
import 'package:clipboard/base/domain/repositories/user_devices.dart';
import 'package:clipboard/base/sync/sync_orchestrator.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:universal_io/io.dart';

@lazySingleton
class UserDevicesCubit extends Cubit<UserDevicesState> {
  final UserDevicesRepository repo;
  final PackageInfo packageInfo;
  final String deviceId;
  final SyncOrchestrator syncOrchestrator;
  final AppConfigCubit appConfigCubit;
  final MonetizationCubit monetizationCubit;

  UserDevicesCubit({
    required this.repo,
    required this.packageInfo,
    @Named('device_id') required this.deviceId,
    required this.syncOrchestrator,
    required this.appConfigCubit,
    required this.monetizationCubit,
  }) : super(const UserDevicesState());

  Future<DeviceAccessStatus> registerCurrentDevice() async {
    emit(
      state.copyWith(
        isRegistering: true,
        clearFailure: true,
        accessStatus: DeviceAccessStatus.unknown,
      ),
    );

    final result = await repo.registerCurrentDevice(
      deviceId: deviceId,
      platform: Platform.operatingSystem,
      appVersion: '${packageInfo.version}+${packageInfo.buildNumber}',
    );

    return result.fold(
      (failure) async {
        emit(
          state.copyWith(
            isRegistering: false,
            failure: failure,
            accessStatus: DeviceAccessStatus.verificationFailed,
          ),
        );
        syncOrchestrator.stop();
        InAppNotificationService.i.notify(
          NotificationMessage.builder(
            id: 'sync_device_verification_failed',
            builder: (context) => NotificationContent(
              body:
                  'Sync device access could not be verified right now. Please check your internet connection and try again.',
            ),
          ),
        );
        return DeviceAccessStatus.verificationFailed;
      },
      (registration) async {
        if (registration.allowed) {
          final cadence =
              monetizationCubit.active?.syncInterval ??
              defaultBestEffortSyncInterval;
          final config = appConfigCubit.state.config;
          syncOrchestrator.start(
            syncSpeed: config.syncSpeed,
            intervalSeconds: cadence,
          );
          emit(
            state.copyWith(
              isRegistering: false,
              clearFailure: true,
              accessStatus: DeviceAccessStatus.allowed,
            ),
          );
          return DeviceAccessStatus.allowed;
        }

        syncOrchestrator.stop();
        await appConfigCubit.changeSync(false);
        InAppNotificationService.i.notify(
          NotificationMessage.builder(
            id: 'sync_device_limit_reached',
            builder: (context) => NotificationContent(
              body:
                  'Sync is disabled on this device because your plan device limit is reached. Remove another device from Settings > Syncing > Manage Sync Devices.',
            ),
          ),
        );
        emit(
          state.copyWith(
            isRegistering: false,
            clearFailure: true,
            accessStatus: DeviceAccessStatus.limitReached,
          ),
        );
        return DeviceAccessStatus.limitReached;
      },
    );
  }

  Future<void> fetchDevices({bool force = false}) async {
    if (state.isLoading) return;
    if (!force && state.deviceList != null) return;

    emit(state.copyWith(isLoading: true, clearFailure: true));

    final result = await repo.listDevices();
    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, failure: failure));
      },
      (list) {
        emit(
          state.copyWith(
            isLoading: false,
            deviceList: list,
            clearFailure: true,
          ),
        );
      },
    );
  }

  Future<bool> revokeDevice(String revokeDeviceId) async {
    final result = await repo.revokeDevice(revokeDeviceId);

    return result.fold(
      (failure) {
        emit(state.copyWith(failure: failure));
        return false;
      },
      (_) {
        final current = state.deviceList;
        if (current != null) {
          final now = DateTime.now();
          final updatedDevices = current.devices
              .map((d) {
                if (d.deviceId != revokeDeviceId) return d;
                return SyncDeviceInfo(
                  deviceId: d.deviceId,
                  platform: d.platform,
                  appVersion: d.appVersion,
                  lastSeenAt: now,
                  isRevoked: true,
                );
              })
              .toList(growable: false);

          final activeCount = updatedDevices.where((d) => !d.isRevoked).length;
          emit(
            state.copyWith(
              deviceList: DeviceListResult(
                devices: updatedDevices,
                limit: current.limit,
                activeCount: activeCount,
              ),
              clearFailure: true,
            ),
          );
        }
        return true;
      },
    );
  }

  void clear() {
    emit(const UserDevicesState());
  }
}
