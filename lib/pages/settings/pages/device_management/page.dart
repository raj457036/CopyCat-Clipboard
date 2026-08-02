import 'package:clipboard/base/bloc/user_devices_cubit/user_devices_cubit.dart';
import 'package:clipboard/base/bloc/user_devices_cubit/user_devices_state.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/data/services/notification_service.dart';
import 'package:clipboard/base/domain/model/notification_message.dart';
import 'package:clipboard/base/domain/model/sync/user_device_access.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/di/di.dart';
import 'package:clipboard/pages/settings/pages/device_management/widgets/device_grid_card.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/scaffold_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeviceManagementPage extends StatefulWidget {
  const DeviceManagementPage({super.key});

  @override
  State<DeviceManagementPage> createState() => _DeviceManagementPageState();
}

class _DeviceManagementPageState extends State<DeviceManagementPage> {
  late final UserDevicesCubit _userDevicesCubit;
  late final String _currentDeviceId;
  final Map<String, bool> _savingDeviceNames = <String, bool>{};
  final Map<String, bool> _revokingDevices = <String, bool>{};

  @override
  void initState() {
    super.initState();
    _userDevicesCubit = sl<UserDevicesCubit>();
    _currentDeviceId = sl<String>(instanceName: 'device_id');
    _userDevicesCubit.fetchDevices();
  }

  Future<void> _refresh() async {
    await _userDevicesCubit.fetchDevices(force: true);
  }

  Future<void> _renameDevice(SyncDeviceInfo device, String? name) async {
    final trimmedName = (name ?? '').trim();
    final nextName = trimmedName.isEmpty ? null : trimmedName;
    final currentName = device.name?.trim();

    if (nextName == currentName) {
      return;
    }

    if (!mounted) return;
    setState(() {
      _savingDeviceNames[device.deviceId] = true;
    });

    final success = await _userDevicesCubit.updateDeviceName(
      device.deviceId,
      nextName,
    );

    if (!mounted) return;
    setState(() {
      _savingDeviceNames.remove(device.deviceId);
    });

    if (!success) {
      InAppNotificationService.i.notify(
        NotificationMessage.builder(
          builder: (context) => NotificationContent(
            body: 'Could not save the device name. Please try again.',
          ),
          id: 'rename-device-${device.deviceId}-failure',
        ),
      );
      return;
    }

    await _refresh();
    InAppNotificationService.i.notify(
      NotificationMessage.builder(
        builder: (context) => NotificationContent(
          body: 'Device name updated successfully.',
        ),
        id: 'rename-device-${device.deviceId}-success',
      ),
    );
  }

  Future<void> _revokeDevice(SyncDeviceInfo device) async {
    final shouldRevoke = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.locale.settings__device_mgmt__dialog_title),
          content: Text(
            'This will revoke sync access for ${device.name ?? device.deviceId}. You can register it again later by signing in from that device.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(context.locale.settings__device_mgmt__dialog_cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(context.locale.settings__device_mgmt__dialog_remove),
            ),
          ],
        );
      },
    );

    if (shouldRevoke != true) return;

    if (!mounted) return;
    setState(() {
      _revokingDevices[device.deviceId] = true;
    });

    final success = await _userDevicesCubit.revokeDevice(device.deviceId);
    if (!mounted) return;
    setState(() {
      _revokingDevices.remove(device.deviceId);
    });

    if (!success) {
      InAppNotificationService.i.notify(
        NotificationMessage.builder(
          builder: (context) => NotificationContent(
            body: context.locale.settings__device_mgmt__revoke_failed,
          ),
          id: 'revoke-device-${device.deviceId}-failure',
        ),
      );
      return;
    }

    await _refresh();
    InAppNotificationService.i.notify(
      NotificationMessage.builder(
        builder: (context) => NotificationContent(
          body: 'Removed ${device.name ?? device.deviceId} from sync devices.',
        ),
        id: 'revoke-device-${device.deviceId}-success',
      ),
    );
  }

  String _formatLastSeen(BuildContext context, DateTime value) {
    final now = DateTime.now();
    final diff = now.difference(value);

    if (diff.inMinutes < 60) {
      return context.locale.settings__device_mgmt__active_now;
    } else if (diff.inHours < 24) {
      final t = value.toLocal();
      final hh = t.hour.toString().padLeft(2, '0');
      final mm = t.minute.toString().padLeft(2, '0');
      return context.locale.settings__device_mgmt__today_at(time: '$hh:$mm');
    } else if (diff.inDays < 7) {
      return context.locale.settings__device_mgmt__days_ago(count: diff.inDays);
    } else {
      return value.toLocal().toString().split(' ')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(context.locale.settings__device_mgmt__app_bar_title),
      ),
      body: ScaffoldBody(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: BlocBuilder<UserDevicesCubit, UserDevicesState>(
              bloc: _userDevicesCubit,
              builder: (context, state) {
                if (state.isLoading && state.deviceList == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.failure != null && state.deviceList == null) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(context.locale.settings__device_mgmt__load_failed),
                        height12,
                        FilledButton(
                          onPressed: _refresh,
                          child: Text(
                            context.locale.settings__device_mgmt__retry,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final data =
                    state.deviceList ??
                    const DeviceListResult(
                      devices: [],
                      limit: 0,
                      activeCount: 0,
                    );
                final devices = data.devices;

                if (devices.isEmpty) {
                  return Center(
                    child: Text(context.locale.settings__device_mgmt__empty),
                  );
                }

                final allDevices = devices.toList(growable: false)
                  ..sort((a, b) {
                    int score(SyncDeviceInfo d) {
                      if (d.deviceId == _currentDeviceId) return 0;
                      if (!d.isRevoked) return 1;
                      return 2;
                    }

                    final byStatus = score(a).compareTo(score(b));
                    if (byStatus != 0) return byStatus;
                    return b.lastSeenAt.compareTo(a.lastSeenAt);
                  });

                final visibleDevices = allDevices
                    .where((d) => !d.isRevoked)
                    .toList(growable: false);
                final revokedDevices = allDevices
                    .where((d) => d.isRevoked)
                    .toList(growable: false);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: padding16,
                        left: padding16,
                      ),
                      child: OverflowBar(
                        spacing: padding8,
                        children: [
                          Tooltip(
                            message: context
                                .locale
                                .settings__device_mgmt__max_limit_tooltip,
                            child: Chip(
                              label: Text(
                                context.locale
                                    .settings__device_mgmt__max_limit_label(
                                      count: data.limit,
                                    ),
                              ),
                              color: context.colors.primaryContainer.wsp,
                            ),
                          ),
                          Tooltip(
                            message: context
                                .locale
                                .settings__device_mgmt__active_count_tooltip,
                            child: Chip(
                              label: Text(
                                context.locale
                                    .settings__device_mgmt__active_count_label(
                                      count: data.activeCount,
                                    ),
                              ),
                              color: context.colors.secondaryContainer.wsp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _refresh,
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(padding16),
                          children: [
                            for (final device in visibleDevices) ...[
                              DeviceGridCard(
                                device: device,
                                isCurrentDevice: device.deviceId == _currentDeviceId,
                                lastSeenText: _formatLastSeen(context, device.lastSeenAt),
                                onRename: (name) => _renameDevice(device, name),
                                isSavingName:
                                    _savingDeviceNames[device.deviceId] ?? false,
                                isRevoking: _revokingDevices[device.deviceId] ?? false,
                                onRevoke:
                                    device.deviceId != _currentDeviceId
                                    ? () => _revokeDevice(device)
                                    : null,
                              ),
                              const SizedBox(height: 8),
                            ],
                            if (revokedDevices.isNotEmpty)
                              ExpansionTile(
                                tilePadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                childrenPadding: const EdgeInsets.only(
                                  left: 8,
                                  right: 8,
                                  bottom: 8,
                                ),
                                initiallyExpanded: false,
                                title: Text(
                                  'Revoked devices (${revokedDevices.length})',
                                ),
                                children: [
                                  for (final device in revokedDevices) ...[
                                    DeviceGridCard(
                                      device: device,
                                      isCurrentDevice:
                                          device.deviceId == _currentDeviceId,
                                      lastSeenText: _formatLastSeen(
                                        context,
                                        device.lastSeenAt,
                                      ),
                                      onRename: (name) => _renameDevice(device, name),
                                      isSavingName:
                                          _savingDeviceNames[device.deviceId] ?? false,
                                      isRevoking:
                                          _revokingDevices[device.deviceId] ?? false,
                                      onRevoke: null,
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
