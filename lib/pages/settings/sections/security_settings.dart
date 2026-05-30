import 'package:clipboard/pages/settings/widgets/e2ee_settings.dart';
import 'package:clipboard/pages/settings/widgets/exclusion_rules/exclusion_rules_switch_tile.dart';
import 'package:clipboard/pages/settings/widgets/local_auth_settings_tile.dart';
import 'package:clipboard/pages/settings/widgets/switches/hide_from_screen_capture_switch.dart';
import 'package:clipboard/pages/settings/widgets/setting_header.dart';
import 'package:clipboard/widgets/local_user.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:flutter/material.dart';

class SecuritySettings extends StatelessWidget {
  const SecuritySettings({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(padding12),
      children: [
        DisableForLocalUser(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SettingHeader(name: context.locale.settings__text__encryption),
              const E2EESetupListTile(),
            ],
          ),
        ),
        const DisableForLocalUser(
          child: Divider(indent: padding12, endIndent: padding12),
        ),
        const HideFromScreenCaptureSwitchTile(),
        const Divider(indent: padding12, endIndent: padding12),
        const ExclusionRulesSwitchTile(),
        const Divider(indent: padding12, endIndent: padding12),
        const LocalAuthSettingsTile(),
      ],
    );
  }
}
