import 'package:clipboard/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/constants/widget_styles.dart';
import 'package:clipboard/l10n/l10n.dart';
import 'package:clipboard/widgets/badges.dart';
import 'package:clipboard/widgets/dialogs/e2ee_dialog.dart';
import 'package:clipboard/widgets/subscription/subscription_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class E2EESettings extends StatelessWidget {
  const E2EESettings({super.key});

  void toggleAutoEncrypt(BuildContext context, bool value) {
    context.read<AppConfigCubit>().toggleAutoEncrypt(value);
  }

  @override
  Widget build(BuildContext context) {
    return SubscriptionBuilder(
      builder: (context, subscription) {
        return BlocSelector<AppConfigCubit, AppConfigState, (bool, bool)>(
          selector: (state) {
            switch (state) {
              case AppConfigLoaded(:final config):
                return (config.enc2 != null, config.autoEncrypt);
              default:
                return (false, false);
            }
          },
          builder: (context, state) {
            final (setup, autoEncrypt) = state;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  title: Text(context.locale.endToEndVault),
                  subtitle: Text(
                    context.locale.accessE2eeVault,
                  ),
                  // enabled: subscription.encrypt,
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => const E2EESettingDialog().show(context),
                ),
                SwitchListTile(
                  value: autoEncrypt,
                  onChanged: setup && subscription.encrypt
                      ? (value) => toggleAutoEncrypt(context, value)
                      : null,
                  title: Row(
                    children: [
                      Text(context.locale.encryptClipboard),
                      width8,
                      const ProBadge(),
                    ],
                  ),
                  subtitle: Text(
                    context.locale.encryptClipboardDesc,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
