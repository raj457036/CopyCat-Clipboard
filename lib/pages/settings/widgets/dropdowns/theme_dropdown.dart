import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/widgets/settings_menu_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeDropdownTile extends StatelessWidget {
  const ThemeDropdownTile({super.key});

  ({IconData icon, String label}) _themeDetails(
    BuildContext context,
    ThemeMode mode,
  ) {
    return switch (mode) {
      ThemeMode.system => (
        icon: Icons.contrast_rounded,
        label: context.locale.settings__theme__system,
      ),
      ThemeMode.light => (
        icon: Icons.light_mode_rounded,
        label: context.locale.settings__theme__light,
      ),
      ThemeMode.dark => (
        icon: Icons.dark_mode_rounded,
        label: context.locale.settings__theme__dark,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppConfigCubit>();
    return ListTile(
      title: Text(context.locale.settings__dropdown__theme__title),
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
          return SettingsMenuDropdown<ThemeMode>(
            value: state,
            items: const [
              SettingsDropdownItem(value: ThemeMode.system),
              SettingsDropdownItem(value: ThemeMode.light),
              SettingsDropdownItem(value: ThemeMode.dark),
            ],
            itemBuilder: (context, mode) {
              final details = _themeDetails(context, mode);
              return (
                leading: Icon(details.icon),
                child: Text(details.label),
                trailing: null,
              );
            },
            onSelected: cubit.changeThemeMode,
          );
        },
      ),
    );
  }
}
