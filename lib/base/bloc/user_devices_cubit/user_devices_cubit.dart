import 'package:bloc/bloc.dart';
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/monetization_cubit/monetization_cubit.dart';
import 'package:clipboard/base/bloc/user_devices_cubit/user_devices_state.dart';
import 'package:clipboard/base/constants/numbers/values.dart';
import 'package:clipboard/base/data/services/notification_service.dart';
import 'package:clipboard/base/domain/model/notification_message.dart';
import 'package:clipboard/base/domain/repositories/user_devices.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/base/sync/sync_orchestrator.dart';
import 'package:clipboard/common/logging.dart';
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

  String? getDeviceName(String deviceId) {
    try {
      final device = state.deviceList?.devices.firstWhere(
        (d) => d.deviceId == deviceId,
        orElse: () => throw StateError('Device not found'),
      );
      return device?.name;
    } catch (e) {
      logger.w('Error getting device name for $deviceId: $e');
      return null;
    }
  }

  String _resolveDeviceName() {
    final hostname = Platform.localHostname.trim();
    if (hostname.isEmpty) {
      return 'Device ${deviceId.substring(0, 6)}';
    }
    return hostname;
  }

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
        logger.e('Device registration failed: $failure');
        emit(
          state.copyWith(
            isRegistering: false,
            failure: failure,
            accessStatus: DeviceAccessStatus.verificationFailed,
          ),
        );
        return DeviceAccessStatus.verificationFailed;
      },
      (registration) async {
        if (registration.allowed) {
          final existingName = getDeviceName(deviceId);

          if (existingName == null || existingName.trim().isEmpty) {
            await repo.updateDeviceName(
              deviceId: deviceId,
              name: _resolveDeviceName(),
            );
          }

          emit(
            state.copyWith(
              isRegistering: false,
              clearFailure: true,
              accessStatus: DeviceAccessStatus.allowed,
            ),
          );
          return DeviceAccessStatus.allowed;
        }

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

  Future<void> setupSyncOrchestrator() async {
    final accessStatus = state.accessStatus;
    final subscription = monetizationCubit.active;
    final syncInterval = subscription?.syncInterval;

    if (subscription == null) {
      syncOrchestrator.stop();
      return;
    }

    final active = monetizationCubit.active;
    if (active == null || !active.isSameAs(subscription)) return;

    switch (accessStatus) {
      case DeviceAccessStatus.allowed:
        final config = appConfigCubit.state.config;
        if (!config.enableSync) return;
        final cadence =
            syncInterval ??
            monetizationCubit.active?.syncInterval ??
            defaultBestEffortSyncInterval;
        syncOrchestrator.start(
          syncSpeed: config.syncSpeed,
          intervalSeconds: cadence,
        );
        return;
      case DeviceAccessStatus.verificationFailed:
        syncOrchestrator.stop();
        InAppNotificationService.i.notify(
          NotificationMessage.builder(
            id: 'sync_device_verification_failed',
            builder: (context) => NotificationContent(
              body: context.locale.device_mgmt_verification_failed,
            ),
          ),
        );
        return;
      case DeviceAccessStatus.limitReached:
        syncOrchestrator.stop();
        await appConfigCubit.changeSync(false);
        InAppNotificationService.i.notify(
          NotificationMessage.builder(
            id: 'sync_device_limit_reached',
            builder: (context) => NotificationContent(
              body: context.locale.device_mgmt_limit_reached,
            ),
            persistent: true,
          ),
        );

        return;
      case DeviceAccessStatus.unknown:
        return;
    }
  }

  Future<void> fetchDevices({bool force = false}) async {
    if (state.isLoading) return;
    if (!force && state.deviceList != null) return;

    emit(state.copyWith(isLoading: true, clearFailure: true));

    final result = await repo.listDevices();
    result.fold(
      (failure) {
        logger.e('Failed to fetch devices: $failure');
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

  Future<bool> updateDeviceName(String deviceId, String? name) async {
    final result = await repo.updateDeviceName(deviceId: deviceId, name: name);

    return result.fold(
      (failure) {
        emit(state.copyWith(failure: failure));
        return false;
      },
      (_) async {
        await fetchDevices(force: true);
        return true;
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
      (_) async {
        final accessStatus = await registerCurrentDevice();
        await setupSyncOrchestrator();

        if (accessStatus == DeviceAccessStatus.allowed &&
            appConfigCubit.state.config.enableSync) {
          await syncOrchestrator.syncAll(force: true);
        }

        await fetchDevices(force: true);
        InAppNotificationService.i.dismiss('sync_device_limit_reached');
        return true;
      },
    );
  }

  void clear() {
    emit(const UserDevicesState());
  }
}
