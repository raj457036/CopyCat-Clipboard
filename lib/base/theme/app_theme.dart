import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/text_theme.dart';
import 'package:flutter/material.dart';

PopupMenuThemeData popupMenuThemeFor(
  ColorScheme scheme,
  Brightness brightness,
) {
  return PopupMenuThemeData(
    color: brightness == Brightness.dark
        ? scheme.surfaceContainerHigh
        : scheme.surface,
    elevation: 12,
    shape: RoundedRectangleBorder(
      borderRadius: radius12,
      side: BorderSide(color: scheme.outlineVariant, width: 1),
    ),
  );
}

ThemeData buildAppTheme({
  required ColorScheme colorScheme,
  required Brightness brightness,
}) {
  final buttonStyle = ButtonStyle(
    mouseCursor: WidgetStateProperty.all(SystemMouseCursors.click),
  );
  final iconButtonTheme = IconButtonThemeData(style: buttonStyle);
  final textButtonTheme = TextButtonThemeData(style: buttonStyle);
  final elevatedButtonTheme = ElevatedButtonThemeData(style: buttonStyle);
  final outlinedButtonTheme = OutlinedButtonThemeData(style: buttonStyle);

  final theme = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    brightness: brightness,
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      isDense: true,
    ),
    textButtonTheme: textButtonTheme,
    elevatedButtonTheme: elevatedButtonTheme,
    outlinedButtonTheme: outlinedButtonTheme,
    iconButtonTheme: iconButtonTheme,
    popupMenuTheme: popupMenuThemeFor(colorScheme, brightness),
  );

  return theme.copyWith(textTheme: robotoFlexTextTheme(theme.textTheme));
}
