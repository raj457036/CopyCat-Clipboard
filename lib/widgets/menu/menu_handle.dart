part of '../menu.dart';

/// Returned by [Menu.of]. Use this to open the menu.
class MenuHandle {
  final Future<void> Function(BuildContext context) _openMenu;
  final Future<void> Function(BuildContext context, Offset globalPosition)
  _openPopupMenu;

  MenuHandle._({
    required Future<void> Function(BuildContext context) openMenu,
    required Future<void> Function(BuildContext context, Offset globalPosition)
    openPopupMenu,
  }) : _openMenu = openMenu,
       _openPopupMenu = openPopupMenu;

  Future<void> openMenu(BuildContext context) => _openMenu(context);

  void openPopupMenu(BuildContext context, Offset globalPosition) {
    unawaited(_openPopupMenu(context, globalPosition));
  }
}
