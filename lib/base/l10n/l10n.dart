import 'package:clipboard/base/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

AppLocalizations locale(BuildContext context) => AppLocalizations.of(context);

extension LocaleExtension on BuildContext {
  AppLocalizations get locale => AppLocalizations.of(this);
  MaterialLocalizations get mlocale => MaterialLocalizations.of(this);
}
