import 'package:android_background_clipboard/android_background_clipboard.dart';
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/user_devices_cubit/user_devices_cubit.dart';
import 'package:clipboard/base/bloc/user_devices_cubit/user_devices_state.dart';
import 'package:clipboard/base/data/services/lan_sync_service.dart';
import 'package:clipboard/base/domain/model/sync/user_device_access.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universal_io/io.dart';

class LanMeshPage extends StatefulWidget {
  const LanMeshPage({super.key});

  @override
  State<LanMeshPage> createState() => _LanMeshPageState();
}

class _LanMeshPageState extends State<LanMeshPage> {
  late final UserDevicesCubit _userDevicesCubit;
  late final bool _isDesktop;

  @override
  void initState() {
    super.initState();
    _isDesktop = !Platform.isAndroid && !Platform.isIOS;
    _userDevicesCubit = sl<UserDevicesCubit>();
    // Ensure the device list is loaded so peers can be labelled by platform.
    // fetchDevices() is a no-op when the list is already cached.
    _userDevicesCubit.fetchDevices();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AppConfigCubit, AppConfigState, bool>(
      selector: (state) {
        switch (state) {
          case AppConfigLoaded(:final config):
            return config.lanInstantSync;
          default:
            return false;
        }
      },
      builder: (context, lanInstantSync) {
        return Scaffold(
          appBar: AppBar(
            title: Text(context.locale.settings__lan_mesh__app_bar_title),
          ),
          body: Column(
            children: [
              if (!lanInstantSync) const _DisabledBanner(),
              Expanded(
                child: !lanInstantSync
                    ? const SizedBox.shrink()
                    : BlocBuilder<UserDevicesCubit, UserDevicesState>(
                        bloc: _userDevicesCubit,
                        builder: (context, devicesState) {
                          final deviceMap = {
                            for (final d
                                in devicesState.deviceList?.devices ??
                                    <SyncDeviceInfo>[])
                              d.deviceId: d,
                          };
                          return !_isDesktop
                              // Android: subscribe to the NSD peer stream from
                              // the background service via the plugin EventChannel.
                              ? StreamBuilder<List<LanPeer>>(
                                  stream: sl<AndroidBackgroundClipboard>()
                                      .lanPeersStream()
                                      .map(
                                        (list) => list
                                            .map(
                                              (m) => LanPeer(
                                                m['deviceId'] as String,
                                                m['host'] as String,
                                                int.parse(m['port'] as String),
                                                // NSD only resolves active
                                                // services so all peers are
                                                // reachable by definition.
                                                reachable: true,
                                              ),
                                            )
                                            .toList(),
                                      ),
                                  initialData: const [],
                                  builder: (context, snapshot) {
                                    final peers = snapshot.data ?? [];
                                    if (peers.isEmpty) {
                                      return const _ScanningEmpty();
                                    }
                                    return _PeerList(
                                      peers: peers,
                                      deviceMap: deviceMap,
                                    );
                                  },
                                )
                              : StreamBuilder<List<LanPeer>>(
                                  stream: sl<LanSyncService>().peersStream,
                                  initialData:
                                      sl<LanSyncService>().currentPeers,
                                  builder: (context, snapshot) {
                                    final peers = snapshot.data ?? [];
                                    if (peers.isEmpty) {
                                      return const _ScanningEmpty();
                                    }
                                    return _PeerList(
                                      peers: peers,
                                      deviceMap: deviceMap,
                                    );
                                  },
                                );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// MARK: - Device Display Helpers

IconData _deviceIcon(String platform) {
  final p = platform.toLowerCase();
  if (p.contains('android')) return Icons.smartphone_rounded;
  if (p.contains('ipad')) return Icons.tablet_mac_rounded;
  if (p.contains('ios') || p.contains('iphone')) {
    return Icons.phone_iphone_rounded;
  }
  if (p.contains('macos') || p.contains('darwin')) {
    return Icons.laptop_mac_rounded;
  }
  if (p.contains('windows')) return Icons.desktop_windows_rounded;
  if (p.contains('linux')) return Icons.computer_rounded;
  return Icons.devices_other_rounded;
}

String? _deviceLabel(String platform) {
  final p = platform.toLowerCase();
  if (p.contains('android')) return 'Android';
  if (p.contains('ipad')) return 'iPad';
  if (p.contains('ios') || p.contains('iphone')) return 'iPhone';
  if (p.contains('macos')) return 'Mac';
  if (p.contains('windows')) return 'Windows';
  if (p.contains('linux')) return 'Linux';
  return null;
}

// MARK: - Peer List

class _PeerList extends StatelessWidget {
  final List<LanPeer> peers;
  final Map<String, SyncDeviceInfo> deviceMap;

  const _PeerList({required this.peers, required this.deviceMap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView.separated(
      itemCount: peers.length,
      separatorBuilder: (_, _) => const Divider(height: 1, indent: 56),
      itemBuilder: (context, i) {
        final peer = peers[i];
        final info = deviceMap[peer.deviceId];
        final label = info != null
            ? (_deviceLabel(info.platform) ??
                  context.locale.settings__lan_mesh__unknown_device)
            : _shortId(peer.deviceId);
        final icon = info != null
            ? _deviceIcon(info.platform)
            : Icons.devices_rounded;
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: peer.reachable
                ? Colors.green.shade100
                : colorScheme.surfaceContainerHigh,
            child: Icon(
              icon,
              size: 20,
              color: peer.reachable
                  ? Colors.green.shade700
                  : colorScheme.outline,
            ),
          ),
          title: Text(label),
          subtitle: Text(
            '${peer.host}  ·  ${_shortId(peer.deviceId)}',
            style: TextStyle(fontSize: 12, color: colorScheme.outline),
          ),
          trailing: _ReachabilityBadge(reachable: peer.reachable),
        );
      },
    );
  }

  String _shortId(String id) => id.length > 16 ? '${id.substring(0, 16)}…' : id;
}

// MARK: - Empty / Scanning State

class _ScanningEmpty extends StatelessWidget {
  const _ScanningEmpty();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          SizedBox.square(
            dimension: 36,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: colorScheme.primary,
            ),
          ),
          Text(
            context.locale.settings__lan_mesh__searching,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// MARK: - Trailing Badge

class _ReachabilityBadge extends StatelessWidget {
  final bool reachable;

  const _ReachabilityBadge({required this.reachable});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: reachable ? Colors.green.shade100 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: reachable ? Colors.green.shade700 : Colors.grey.shade500,
            ),
          ),
          Text(
            reachable
                ? context.locale.settings__lan_mesh__reachable
                : context.locale.settings__lan_mesh__unreachable,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: reachable ? Colors.green.shade800 : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

// MARK: - Banners & Tiles

class _DisabledBanner extends StatelessWidget {
  const _DisabledBanner();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: colors.errorContainer,
      child: Text(
        context.locale.settings__lan_mesh__disabled_banner,
        style: TextStyle(color: colors.onErrorContainer, fontSize: 13),
        textAlign: TextAlign.center,
      ),
    );
  }
}
