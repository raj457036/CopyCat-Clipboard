import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/widgets/settings_menu_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleDropdownButton extends StatelessWidget {
  const LocaleDropdownButton({super.key});

  static const _supportedLocales = [
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('de'),
    Locale('zh'),
    Locale('pt'),
  ];

  ({Widget? leading, Widget child, Widget? trailing}) _localeDetails(
    BuildContext context,
    Locale locale,
  ) {
    final label = switch (locale.languageCode) {
      'en' => context.locale.app__locale_en,
      'es' => context.locale.app__locale_es,
      'fr' => context.locale.app__locale_fr,
      'de' => context.locale.app__locale_de,
      'zh' => context.locale.app__locale_zh,
      'pt' => context.locale.app__locale_pt,
      _ => context.locale.app__locale_en,
    };

    return (leading: null, child: Text(label), trailing: null);
  }

  Locale _normalizedLocale(String localeCode) {
    for (final locale in _supportedLocales) {
      if (locale.languageCode == localeCode) return locale;
    }
    return const Locale('en');
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AppConfigCubit, AppConfigState, Locale>(
      selector: (state) {
        switch (state) {
          case AppConfigLoaded(:final config):
            if (config.locale.isEmpty) return const Locale('en');
            return _normalizedLocale(config.locale);
          default:
            return const Locale('en');
        }
      },
      builder: (context, state) {
        return LimitedBox(
          maxWidth: 150,
          child: SettingsMenuDropdown<Locale>(
            value: state,
            items: _supportedLocales
                .map((locale) => SettingsDropdownItem(value: locale))
                .toList(growable: false),
            itemBuilder: _localeDetails,
            onSelected: (locale) {
              context.read<AppConfigCubit>().changeLocale(locale.languageCode);
            },
          ),
        );
      },
    );
  }
}
