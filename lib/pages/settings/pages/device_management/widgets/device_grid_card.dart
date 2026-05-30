import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/sync/user_device_access.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/pages/settings/pages/device_management/widgets/device_status_badge.dart';
import 'package:flutter/material.dart';

class DeviceGridCard extends StatelessWidget {
  final SyncDeviceInfo device;
  final bool isCurrentDevice;
  final String lastSeenText;
  final VoidCallback? onRevoke;

  const DeviceGridCard({
    super.key,
    required this.device,
    required this.isCurrentDevice,
    required this.lastSeenText,
    required this.onRevoke,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final titleColor = device.isRevoked
        ? colorScheme.onSurface.withValues(alpha: 0.6)
        : colorScheme.onSurface;

    final deviceId =
        "ID: ${device.deviceId.substring(0, 6)}•••${device.deviceId.substring(device.deviceId.length - 6)}";

    return Card.outlined(
      color: device.isRevoked
          ? colorScheme.errorContainer.withValues(alpha: 0.2)
          : colorScheme.surfaceContainer,
      elevation: 0.5,
      child: InkWell(
        borderRadius: radius16,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            spacing: padding8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: padding8,
                children: [
                  Icon(
                    _platformIcon(device),
                    size: 24,
                    color: device.isRevoked
                        ? colorScheme.onSurface.withValues(alpha: 0.5)
                        : colorScheme.onSurfaceVariant,
                  ),
                  Expanded(
                    child: Text(
                      _getDeviceName(device),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: titleColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              DeviceStatusBadge(
                status: isCurrentDevice
                    ? DeviceStatusBadgeType.current
                    : (device.isRevoked
                          ? DeviceStatusBadgeType.revoked
                          : DeviceStatusBadgeType.active),
              ),
              Text(
                deviceId,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text(
                context.locale.settings__device_card__last_seen(
                  time: lastSeenText,
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              if (onRevoke != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: onRevoke,
                    icon: const Icon(Icons.link_off_rounded, size: 16),
                    label: Text(context.locale.settings__device_card__revoke),
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _platformIcon(SyncDeviceInfo device) {
    final platform = device.platform.toLowerCase();
    final id = device.deviceId.toLowerCase();

    if (platform.contains('android')) {
      if (id.contains('tablet') || id.contains('tab')) {
        return Icons.tablet_android_rounded;
      }
      return Icons.smartphone_rounded;
    }
    if (platform.contains('ios') || platform.contains('iphone')) {
      return Icons.phone_iphone_rounded;
    }
    if (platform.contains('ipad')) {
      return Icons.tablet_mac_rounded;
    }
    if (platform.contains('macos') || platform.contains('darwin')) {
      return Icons.laptop_mac_rounded;
    }
    if (platform.contains('windows')) {
      return Icons.desktop_windows_rounded;
    }
    if (platform.contains('linux')) {
      return Icons.computer_rounded;
    }
    if (platform.contains('web') || platform.contains('browser')) {
      return Icons.language_rounded;
    }
    return Icons.devices_other_rounded;
  }

  String _getDeviceName(SyncDeviceInfo device) {
    final platform = device.platform.toLowerCase();

    if (platform.contains('android')) {
      return device.deviceId.contains('tablet')
          ? 'Android Tablet'
          : 'Android Phone';
    }
    if (platform.contains('ios') || platform.contains('iphone')) {
      return 'iPhone';
    }
    if (platform.contains('ipad')) {
      return 'iPad';
    }
    if (platform.contains('macos')) {
      return 'Mac';
    }
    if (platform.contains('windows')) {
      return 'Windows';
    }
    if (platform.contains('linux')) {
      return 'Linux';
    }
    if (platform.contains('web')) {
      return 'Web';
    }
    return device.platform;
  }
}
