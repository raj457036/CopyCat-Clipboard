import 'package:flutter/widgets.dart';

class DockIcons {
  DockIcons._();

  static const _kFontFam = 'DockIcons';
  static const String _kFontPkg = "copycat_base";

  static const IconData dockTop =
      IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData dockBottom =
      IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData dockLeft =
      IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData dockRight =
      IconData(0xe803, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}
