import 'package:clipboard/pages/settings/widgets/e2ee_settings.dart';
import 'package:clipboard/pages/settings/widgets/exclusion_rules/exclusion_rules_switch_tile.dart';
import 'package:clipboard/pages/settings/widgets/setting_header.dart';
import 'package:clipboard/widgets/local_user.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:flutter/material.dart';

class SecuritySettings extends StatelessWidget {
  const SecuritySettings({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 650),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: padding12),
        children: [
          DisableForLocalUser(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SettingHeader(
                    icon: Icons.key,
                    name: context.locale.settings__text__encryption),
                const E2EESettings(),
              ],
            ),
          ),
          const DisableForLocalUser(child: Divider(indent: padding12, endIndent: padding12)),
          const ExclusionRulesSwitchTile(),
        ],
      ),
    );
  }
}
