import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/constants/numbers/file_sizes.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/widgets/settings_menu_dropdown.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DontAutoUploadOverDropdown extends StatelessWidget {
  const DontAutoUploadOverDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;
    final cubit = context.read<AppConfigCubit>();
    return BlocSelector<AppConfigCubit, AppConfigState, int>(
      selector: (state) {
        switch (state) {
          case AppConfigLoaded(:final config):
            return config.dontUploadOver;
          default:
            return $10MB;
        }
      },
      builder: (context, state) {
        return ListTile(
          leading: const Icon(Icons.cloud_off_rounded),
          title: Text(
            context.locale.settings__dropdown__no_upload_over_limit__title,
          ),
          subtitle: Text(
            context.locale.settings__dropdown__no_upload_over_limit__subtitle(
              fileSize: formatBytes(state, precise: false),
            ),
            style: textTheme.bodyMedium?.copyWith(color: colors.outline),
          ),
          trailing: SettingsMenuDropdown<int>(
            value: state,
            items: const [
              SettingsDropdownItem(value: $5MB),
              SettingsDropdownItem(value: $10MB),
              SettingsDropdownItem(value: $20MB),
              SettingsDropdownItem(value: $50MB),
              SettingsDropdownItem(value: $100MB),
            ],
            itemBuilder: (context, value) {
              final label = switch (value) {
                $5MB => context.locale.settings__text__5MB,
                $10MB => context.locale.settings__text__10MB,
                $20MB => context.locale.settings__text__20MB,
                $50MB => context.locale.settings__text__50MB,
                $100MB => context.locale.settings__text__100MB,
                _ => formatBytes(value, precise: false),
              };

              return (leading: null, child: Text(label), trailing: null);
            },
            onSelected: cubit.changeDontUploadOver,
          ),
        );
      },
    );
  }
}
