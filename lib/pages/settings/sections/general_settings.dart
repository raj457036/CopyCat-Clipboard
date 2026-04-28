import 'package:clipboard/pages/settings/widgets/copycat_about_tile.dart';
import 'package:clipboard/pages/settings/widgets/download_desktop_client.dart';
import 'package:clipboard/pages/settings/widgets/dropdowns/dont_copy_over_dropdown.dart';
import 'package:clipboard/pages/settings/widgets/switches/pause_till_switch.dart';
import 'package:clipboard/pages/settings/widgets/switches/startup_launch_switch.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/widgets/locale_dropdown.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class GeneralSettings extends StatelessWidget {
  const GeneralSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 650),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: padding12),
        children: [
          const DownloadDesktopClientTile(),
          height16,
          const LocaleDropdownTile(),
          height10,
          const DontAutoCopyOverDropdown(),
          const PauseTillSwitch(),
          const StartUpLaunchSwitch(),
          ListTile(
            leading: const Icon(Icons.backup_rounded),
            title: Text(context.locale.settings__tile__backup_restore__title),
            subtitle: Text(
              context.locale.settings__tile__backup_restore__subtitle,
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            onTap: () => context.goNamed(RouteConstants.backupRestore),
          ),
          height10,
          const CopycatAboutTile(),
        ],
      ),
    );
  }
}
