import 'package:clipboard/base/background/encryption_worker.dart';
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/dialogs/e2ee_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class E2EESettings extends StatelessWidget {
  const E2EESettings({super.key});

  void toggleAutoEncrypt(BuildContext context, bool value) {
    context.read<AppConfigCubit>().toggleAutoEncrypt(value);
    EncryptionWorker.instance.setEncryption(value);
  }

  void toggleUseEncryptionNonce(BuildContext context, bool value) {
    context.read<AppConfigCubit>().toggleUseEncryptionNonce(value);
    EncryptionWorker.instance.setUseNonce(value);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;
    return BlocSelector<AppConfigCubit, AppConfigState, (bool, bool, bool)>(
      selector: (state) {
        switch (state) {
          case AppConfigLoaded(:final config):
            return (
              config.enc2 != null,
              config.autoEncrypt,
              config.useEncryptionNonce,
            );
          default:
            return (false, false, false);
        }
      },
      builder: (context, state) {
        final (setup, autoEncrypt, useNonce) = state;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: Text(context.locale.settings__tile__e2e_setup__title),
              subtitle: Text(
                context.locale.settings__tile__e2e_setup__subtitle,
              ),
              subtitleTextStyle: textTheme.bodyMedium?.copyWith(
                color: colors.outline,
              ),
              // enabled: subscription.encrypt,
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => const E2EESettingDialog().show(context),
            ),
            SwitchListTile(
              value: autoEncrypt,
              onChanged: setup
                  ? (value) => toggleAutoEncrypt(context, value)
                  : null,
              title: Text(context.locale.settings__switch__e2e__title),
              subtitle: Text(
                context.locale.settings__switch__e2e__subtitle,
                style: textTheme.bodyMedium?.copyWith(color: colors.outline),
              ),
            ),
            SwitchListTile(
              value: useNonce,
              onChanged: setup
                  ? (value) => toggleUseEncryptionNonce(context, value)
                  : null,
              title: Text(context.locale.settings__switch__e2e_nonce__title),
              subtitle: Text(
                context.locale.settings__switch__e2e_nonce__subtitle,
                style: textTheme.bodyMedium?.copyWith(color: colors.outline),
              ),
            ),
          ],
        );
      },
    );
  }
}
