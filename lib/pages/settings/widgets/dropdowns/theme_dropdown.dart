import 'package:copycat_base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeDropdownTile extends StatelessWidget {
  const ThemeDropdownTile({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppConfigCubit>();
    return ListTile(
      title: Text(context.locale.settings__dropdown__theme__title),
      contentPadding: const EdgeInsets.only(
        left: padding16,
        right: padding4,
      ),
      trailing: BlocSelector<AppConfigCubit, AppConfigState, ThemeMode>(
        selector: (state) {
          switch (state) {
            case AppConfigLoaded(:final config):
              return config.themeMode;
            default:
              return ThemeMode.system;
          }
        },
        builder: (context, state) {
          return DropdownButtonHideUnderline(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 160),
              child: DropdownButton<ThemeMode>(
                isExpanded: true,
                value: state,
                padding: const EdgeInsets.symmetric(horizontal: padding16),
                borderRadius: radius26,
                icon: const Icon(Icons.arrow_drop_down_rounded),
                items: [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.contrast_rounded),
                        width12,
                        Text(context.locale.settings__theme__system),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.light_mode_rounded),
                        width12,
                        Text(context.locale.settings__theme__light),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.dark_mode_rounded),
                        width12,
                        Text(context.locale.settings__theme__dark),
                      ],
                    ),
                  ),
                ],
                onChanged: cubit.changeThemeMode,
              ),
            ),
          );
        },
      ),
    );
  }
}
