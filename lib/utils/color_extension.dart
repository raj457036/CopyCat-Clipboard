import 'package:flutter/material.dart';

/// Darken a color by [percent] amount (100 = black)
// ........................................................
Color _darken(Color c, [int percent = 0]) {
  if (percent <= 0) return c;
  var f = percent / 100;
  return Color.from(alpha: c.a, red: c.r * f, green: c.g * f, blue: c.b * f);
}

/// Lighten a color by [percent] amount (100 = white)
// ........................................................
Color _lighten(Color c, [int percent = 0]) {
  if (percent <= 0) return c;
  var p = percent / 100;
  final color = Color.from(
    red: (c.r + (1 - c.r) * p),
    green: (c.g + (1 - c.g) * p),
    blue: (c.b + (1 - c.b) * p),
    alpha: c.a,
  );
  return color;
}

extension ColorBrightnessExtension on Color {
  Color darker([int percent = 0, bool swap = false]) =>
      swap ? _lighten(this, percent) : _darken(this, percent);
  Color lighter([int percent = 0, bool swap = false]) =>
      swap ? _darken(this, percent) : _lighten(this, percent);
}
