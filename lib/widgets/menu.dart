import 'dart:async';

import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/sheets/sheet_handle.dart';
import 'package:flutter/material.dart';

part 'menu/menu_handle.dart';
part 'menu/menu_helpers.dart';
part 'menu/menu_item.dart';

_MenuState? _activePopupMenu;

class _MenuScope extends InheritedWidget {
  final MenuHandle handle;
  final bool isOpen;

  const _MenuScope({
    required this.handle,
    required this.isOpen,
    required super.child,
  });

  @override
  bool updateShouldNotify(_MenuScope old) {
    return handle != old.handle || isOpen != old.isOpen;
  }
}

class Menu extends StatefulWidget {
  final List<MenuItem> items;
  final Widget child;
  final Future<void> Function()? onBeforeOpen;
  final VoidCallback? onAfterClose;

  const Menu({
    super.key,
    required this.items,
    required this.child,
    this.onBeforeOpen,
    this.onAfterClose,
  });

  static MenuHandle? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_MenuScope>()?.handle;

  static MenuHandle? of(BuildContext context) {
    final result = maybeOf(context);
    return result;
  }

  static bool? maybeIsOpenOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_MenuScope>()?.isOpen;

  static bool isOpenOf(BuildContext context) {
    final result = maybeIsOpenOf(context);
    assert(result != null, 'No Menu found in context');
    return result!;
  }

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final _menuController = MenuController();
  final _menuAnchorKey = GlobalKey();
  bool _isOpen = false;
  late final MenuHandle _handle = MenuHandle._(
    openMenu: _openMenu,
    openPopupMenu: _openPopupMenu,
  );

  void _setOpen(bool value) {
    if (_isOpen == value || !mounted) return;
    setState(() {
      _isOpen = value;
    });
  }

  void _handlePopupOpen() {
    _activePopupMenu = this;
    _setOpen(true);
  }

  void _handlePopupClose() {
    if (identical(_activePopupMenu, this)) {
      _activePopupMenu = null;
    }
    _setOpen(false);
    widget.onAfterClose?.call();
  }

  Future<void> _runBeforeOpen() async {
    final callback = widget.onBeforeOpen;
    if (callback == null) return;
    try {
      await callback();
    } catch (_) {}
  }

  Future<void> _openPopupMenu(
    BuildContext context,
    Offset globalPosition,
  ) async {
    final waitForItemsFrame = widget.onBeforeOpen != null;
    final otherPopupMenu = _activePopupMenu;
    final reopenCurrentMenu = _menuController.isOpen;

    if (otherPopupMenu != null && !identical(otherPopupMenu, this)) {
      otherPopupMenu._menuController.close();
    }

    if (reopenCurrentMenu) {
      _menuController.close();
    }

    await _runBeforeOpen();

    if (otherPopupMenu != null || reopenCurrentMenu || waitForItemsFrame) {
      await WidgetsBinding.instance.endOfFrame;
    }

    if (!mounted) return;
    final box = _menuAnchorKey.currentContext?.findRenderObject() as RenderBox?;
    _menuController.open(
      position: box?.globalToLocal(globalPosition) ?? globalPosition,
    );
  }

  Future<void> _openMenu(BuildContext context) async {
    await _runBeforeOpen();
    await WidgetsBinding.instance.endOfFrame;
    if (!context.mounted) return;

    _setOpen(true);

    await _showMenuBottomSheet(
      context: context,
      groupedItems: _groupedMenuItems(
        _flattenBottomSheetItems(_limitMenuItems(widget.items)),
      ),
    );

    _setOpen(false);
    widget.onAfterClose?.call();
  }

  @override
  void dispose() {
    if (identical(_activePopupMenu, this)) {
      _activePopupMenu = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _MenuScope(
      handle: _handle,
      isOpen: _isOpen,
      child: MenuAnchor(
        key: _menuAnchorKey,
        controller: _menuController,
        animated: true,
        onOpen: _handlePopupOpen,
        onClose: _handlePopupClose,
        menuChildren: _buildDesktopMenuChildren(
          context,
          _limitMenuItems(widget.items),
        ),
        child: widget.child,
      ),
    );
  }
}
