import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/theme/app_theme.dart';
import 'package:clipboard/di/di.dart';
import 'package:clipboard/pages/ime/ime_page.dart';
import 'package:clipboard/pages/ime/ime_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Lightweight init for the IME engine: only what is needed to query local
/// clips and respond to user taps. No window manager, hotkeys, or sync.
Future<void> imeRunner() async {
  await configureDependencies();
  runApp(const ImeApp());
}

/// Root widget for the IME engine. Provides the minimum BLoC/service context
/// required by [ImePage] — AppConfigCubit for theme, ImeService singleton.
class ImeApp extends StatelessWidget {
  const ImeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppConfigCubit>(
      create: (_) => sl<AppConfigCubit>(),
      child: BlocBuilder<AppConfigCubit, AppConfigState>(
        buildWhen: (prev, curr) =>
            prev.config.themeMode != curr.config.themeMode ||
            prev.config.lightThemeColorScheme !=
                curr.config.lightThemeColorScheme ||
            prev.config.darkThemeColorScheme != curr.config.darkThemeColorScheme,
        builder: (context, state) {
          final lightTheme = buildAppTheme(
            colorScheme: state.config.lightThemeColorScheme,
            brightness: Brightness.light,
          );
          final darkTheme = buildAppTheme(
            colorScheme: state.config.darkThemeColorScheme,
            brightness: Brightness.dark,
          );

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: state.config.themeMode,
            theme: lightTheme,
            darkTheme: darkTheme,
            home: ImePage(imeService: ImeService.instance),
          );
        },
      ),
    );
  }
}
