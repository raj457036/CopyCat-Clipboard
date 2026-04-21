import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransformBehaviorSwitch extends StatelessWidget {
  const TransformBehaviorSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;

    return BlocSelector<AppConfigCubit, AppConfigState, bool>(
      selector: (state) {
        switch (state) {
          case AppConfigLoaded(:final config):
            return config.transformAsNewClip;
          default:
            return false;
        }
      },
      builder: (context, enabled) {
        return SwitchListTile(
          value: enabled,
          onChanged: context.read<AppConfigCubit>().toggleTransformAsNewClip,
          title: Text(
            context.locale.settings__switch__transform_behavior__title,
          ),
          subtitle: Text(
            context.locale.settings__switch__transform_behavior__subtitle,
            style: textTheme.bodyMedium?.copyWith(color: colors.outline),
          ),
        );
      },
    );
  }
}
