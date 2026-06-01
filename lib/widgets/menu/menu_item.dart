part of '../menu.dart';

class MenuItem {
  final String? text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final String? section;
  final List<MenuItem> children;

  const MenuItem({
    this.text,
    this.icon,
    this.onPressed,
    this.section,
    this.children = const [],
  });
}
