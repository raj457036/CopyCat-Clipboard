import 'package:flutter/material.dart';

const _fontFamily = 'RobotoFlex';

TextStyle applyVariableFont(TextStyle style, {double weight = 400}) {
  return style.copyWith(
    fontFamily: _fontFamily,
    fontVariations: [FontVariation.weight(weight)],
  );
}

TextTheme robotoFlexTextTheme(TextTheme base) {
  return TextTheme(
    displayLarge: applyVariableFont(base.displayLarge!, weight: 700),
    displayMedium: applyVariableFont(base.displayMedium!, weight: 600),
    displaySmall: applyVariableFont(base.displaySmall!, weight: 500),
    headlineLarge: applyVariableFont(base.headlineLarge!, weight: 700),
    headlineMedium: applyVariableFont(base.headlineMedium!, weight: 600),
    headlineSmall: applyVariableFont(base.headlineSmall!, weight: 500),
    titleLarge: applyVariableFont(base.titleLarge!, weight: 500),
    titleMedium: applyVariableFont(base.titleMedium!, weight: 500),
    titleSmall: applyVariableFont(base.titleSmall!, weight: 500),
    bodyLarge: applyVariableFont(base.bodyLarge!, weight: 400),
    bodyMedium: applyVariableFont(base.bodyMedium!, weight: 400),
    bodySmall: applyVariableFont(base.bodySmall!, weight: 400),
    labelLarge: applyVariableFont(base.labelLarge!, weight: 500),
    labelMedium: applyVariableFont(base.labelMedium!, weight: 500),
    labelSmall: applyVariableFont(base.labelSmall!, weight: 500),
  );
}
