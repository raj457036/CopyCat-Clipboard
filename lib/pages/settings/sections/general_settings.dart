import 'package:clipboard/pages/settings/widgets/copycat_about_tile.dart';
import 'package:clipboard/pages/settings/widgets/download_desktop_client.dart';
import 'package:clipboard/pages/settings/widgets/dropdowns/dont_copy_over_dropdown.dart';
import 'package:clipboard/pages/settings/widgets/switches/pause_till_switch.dart';
import 'package:clipboard/pages/settings/widgets/switches/startup_launch_switch.dart';
import 'package:clipboard/widgets/locale_dropdown.dart';
import 'package:copycat_base/constants/widget_styles.dart';
import 'package:flutter/material.dart';

class GeneralSettings extends StatelessWidget {
  const GeneralSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 650),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: padding12),
        children: const [
          DownloadDesktopClientTile(),
          height16,
          LocaleDropdownTile(),
          height10,
          DontAutoCopyOverDropdown(),
          PauseTillSwitch(),
          StartUpLaunchSwitch(),
          height10,
          CopycatAboutTile(),
        ],
      ),
    );
  }
}
