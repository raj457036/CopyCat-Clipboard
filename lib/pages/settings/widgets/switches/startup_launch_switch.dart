import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/base/utils/utility.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartUpLaunchSwitch extends StatelessWidget {
  const StartUpLaunchSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    if (isMobilePlatform) return const SizedBox.shrink();
    final textTheme = context.textTheme;
    final colors = context.colors;
    final cubit = context.read<AppConfigCubit>();
    return BlocSelector<AppConfigCubit, AppConfigState, bool>(
      selector: (state) {
        switch (state) {
          case AppConfigLoaded(:final config):
            return config.launchAtStartup;
          default:
            return false;
        }
      },
      builder: (context, state) {
        return SwitchListTile(
          value: state,
          onChanged: cubit.setLaunchAtStartup,
          title: Text(context.locale.settings__switch__startup__title),
          subtitle: Text(
            context.locale.settings__switch__startup__subtitle,
            style: textTheme.bodyMedium?.copyWith(
              color: colors.outline,
            ),
          ),
        );
      },
    );
  }
}
