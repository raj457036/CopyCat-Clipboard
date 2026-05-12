import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef ThemeBuilder =
    Widget Function(
      BuildContext context,
      ThemeData theme,
      ThemeData darkTheme,
      AppConfig config,
    );

class ThemeManager extends StatelessWidget {
  final ThemeBuilder builder;

  const ThemeManager({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppConfigCubit, AppConfigState>(
      buildWhen: (previous, current) {
        return (previous.config.themeMode != current.config.themeMode ||
            previous.config.locale != current.config.locale ||
            previous.config.lightThemeColorScheme !=
                current.config.lightThemeColorScheme ||
            previous.config.darkThemeColorScheme !=
                current.config.darkThemeColorScheme ||
            previous.config.view != current.config.view);
      },
      builder: (context, state) {
        final lightTheme = buildAppTheme(
          colorScheme: state.config.lightThemeColorScheme,
          brightness: Brightness.light,
        );

        final darkTheme = buildAppTheme(
          colorScheme: state.config.darkThemeColorScheme,
          brightness: Brightness.dark,
        );

        return builder(context, lightTheme, darkTheme, state.config);
      },
    );
  }
}
