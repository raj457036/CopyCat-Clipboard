import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/text_theme.dart';
import 'package:flutter/material.dart';

Color menuSurfaceColorFor(ColorScheme scheme, Brightness brightness) {
  return brightness == Brightness.dark
      ? scheme.surfaceContainerHigh
      : scheme.surface;
}

PopupMenuThemeData popupMenuThemeFor(
  ColorScheme scheme,
  Brightness brightness,
) {
  return PopupMenuThemeData(
    color: menuSurfaceColorFor(scheme, brightness),
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
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (BuildContext context) =>
          const Icon(Icons.arrow_back),
    ),

    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
        TargetPlatform.macOS: ZoomPageTransitionsBuilder(),
        TargetPlatform.windows: ZoomPageTransitionsBuilder(),
        TargetPlatform.linux: ZoomPageTransitionsBuilder(),
      },
    ),
  );

  return theme.copyWith(textTheme: robotoFlexTextTheme(theme.textTheme));
}
