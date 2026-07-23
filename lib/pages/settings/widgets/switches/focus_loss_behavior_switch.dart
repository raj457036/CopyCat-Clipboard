import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FocusLossBehaviorSwitch extends StatelessWidget {
  const FocusLossBehaviorSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;
    return BlocSelector<AppConfigCubit, AppConfigState, bool>(
      selector: (state) {
        switch (state) {
          case AppConfigLoaded(:final config):
            return config.keepWindowOpenOnUnfocus;
          default:
            return true;
        }
      },
      builder: (context, keepOpen) {
        return SwitchListTile(
          secondary: const Icon(Icons.picture_in_picture_alt_rounded),
          value: keepOpen,
          onChanged: context
              .read<AppConfigCubit>()
              .toggleKeepWindowOpenOnUnfocus,
          title: Text(
            context.locale.settings__switch__focus_loss_behavior__title,
          ),
          subtitle: Text(
            context.locale.settings__switch__focus_loss_behavior__subtitle,
            style: textTheme.bodyMedium?.copyWith(color: colors.outline),
          ),
        );
      },
    );
  }
}
