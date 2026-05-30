import 'package:clipboard/pages/settings/widgets/dropdowns/sync_mode_dropdown.dart';
import 'package:clipboard/pages/settings/widgets/switches/enable_sync_switch.dart';
import 'package:clipboard/pages/settings/widgets/switches/file_sync_switch.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/local_user.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SyncingSettings extends StatelessWidget {
  const SyncingSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final dense = context.isMobile;
    return ListView(
      padding: dense
          ? const EdgeInsets.symmetric(vertical: padding12)
          : const EdgeInsets.all(padding12),
      children: [
        DisableForLocalUser(
          ifLocal: ListTile(
            leading: const Icon(Icons.sync_disabled),
            enabled: false,
            title: Text(context.locale.settings__text__sync_not_available),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const EnableSyncSwitch(),
              const EnableFileSyncSwitch(),
              const SyncModeDropdown(),
              ListTile(
                leading: const Icon(Icons.devices_rounded),
                title: Text(
                  context.locale.settings__sync__manage_devices__title,
                ),
                subtitle: Text(
                  context.locale.settings__sync__manage_devices__subtitle,
                ),
                onTap: () => context.goNamed(RouteConstants.deviceManagement),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
