import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RichDataCaptureSwitchTile extends StatelessWidget {
  const RichDataCaptureSwitchTile({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppConfigCubit>();
    return BlocSelector<AppConfigCubit, AppConfigState, bool>(
      selector: (state) {
        switch (state) {
          case AppConfigLoaded(:final config):
            return config.richDataCapture;
          default:
            return false;
        }
      },
      builder: (context, enabled) {
        return SwitchListTile(
          value: enabled,
          onChanged: cubit.toggleRichDataCapture,
          title: Text(
            context.locale.settings__switch__rich_data_capture__title,
          ),
          subtitle: Text(
            context.locale.settings__switch__rich_data_capture__subtitle,
          ),
        );
      },
    );
  }
}
