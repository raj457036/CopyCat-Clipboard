import 'package:clipboard/base/bloc/user_devices_cubit/user_devices_cubit.dart';
import 'package:clipboard/base/bloc/user_devices_cubit/user_devices_state.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/data/services/notification_service.dart';
import 'package:clipboard/base/domain/model/notification_message.dart';
import 'package:clipboard/base/domain/model/sync/user_device_access.dart';
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

  @override
  void initState() {
    super.initState();
    _userDevicesCubit = sl<UserDevicesCubit>();
    _currentDeviceId = sl<String>(instanceName: 'device_id');
    _userDevicesCubit.fetchDevices();
  }

  void _refresh() {
    _userDevicesCubit.fetchDevices(force: true);
  }

  Future<void> _revokeDevice(SyncDeviceInfo device) async {
    final shouldRevoke = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove Sync Access'),
          content: Text(
            'This will revoke sync access for ${device.deviceId}. You can register it again later by signing in from that device.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    if (shouldRevoke != true) return;

    final success = await _userDevicesCubit.revokeDevice(device.deviceId);
    if (!success) {
      if (!mounted) return;
      InAppNotificationService.i.notify(
        NotificationMessage.builder(
          builder: (context) =>
              NotificationContent(body: 'Failed to remove sync access.'),
          id: 'revoke-device-${device.deviceId}-failure',
        ),
      );
      return;
    }

    if (!mounted) return;
    _refresh();
    InAppNotificationService.i.notify(
      NotificationMessage.builder(
        builder: (context) => NotificationContent(
          body: 'Removed ${device.deviceId} from sync devices.',
        ),
        id: 'revoke-device-${device.deviceId}-success',
      ),
    );
  }

  String _formatLastSeen(DateTime value) {
    final now = DateTime.now();
    final diff = now.difference(value);

    if (diff.inMinutes < 60) {
      return 'Active now';
    } else if (diff.inHours < 24) {
      return 'Today at ${value.toLocal().hour.toString().padLeft(2, '0')}:${value.toLocal().minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return value.toLocal().toString().split(' ')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Manage Sync Devices'),
      ),
      body: ScaffoldBody(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 980),
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
                        const Text('Failed to load devices.'),
                        height12,
                        FilledButton(
                          onPressed: _refresh,
                          child: const Text('Retry'),
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
                  return const Center(child: Text('No sync devices found.'));
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
                            message:
                                "Maximum number of devices you can sync with your current plan.",
                            child: Chip(
                              label: Text("Max Limit • ${data.limit}"),
                              color: context.colors.primaryContainer.msp,
                            ),
                          ),
                          Tooltip(
                            message: "Number of devices currently active.",
                            child: Chip(
                              label: Text("Active • ${data.activeCount}"),
                              color: context.colors.secondaryContainer.msp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async => _refresh(),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final columns = (constraints.maxWidth / 250)
                                .floor()
                                .clamp(1, 5);

                            return GridView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(padding16),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: columns,
                                    mainAxisSpacing: padding12,
                                    crossAxisSpacing: padding12,
                                    childAspectRatio: 3 / 2,
                                  ),
                              itemCount: allDevices.length,
                              itemBuilder: (context, index) {
                                final device = allDevices[index];
                                return DeviceGridCard(
                                  device: device,
                                  isCurrentDevice:
                                      device.deviceId == _currentDeviceId,
                                  lastSeenText: _formatLastSeen(
                                    device.lastSeenAt,
                                  ),
                                  onRevoke:
                                      (!device.isRevoked &&
                                          device.deviceId != _currentDeviceId)
                                      ? () => _revokeDevice(device)
                                      : null,
                                );
                              },
                            );
                          },
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
