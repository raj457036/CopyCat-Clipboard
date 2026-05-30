import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrayIconSwitch extends StatelessWidget {
  const TrayIconSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;
    final cubit = context.read<AppConfigCubit>();
    return BlocSelector<AppConfigCubit, AppConfigState, bool>(
      selector: (state) {
        switch (state) {
          case AppConfigLoaded(:final config):
            return config.showTrayIcon;
          default:
            return true;
        }
      },
      builder: (context, showTrayIcon) {
        return SwitchListTile(
          secondary: const Icon(Icons.linear_scale_rounded),
          value: showTrayIcon,
          onChanged: cubit.toggleTrayIcon,
          title: Text(context.locale.settings__switch__tray_icon__title),
          subtitle: Text(
            context.locale.settings__switch__tray_icon__subtitle,
            style: textTheme.bodyMedium?.copyWith(color: colors.outline),
          ),
        );
      },
    );
  }
}
