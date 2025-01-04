import 'package:clipboard/widgets/sheets/sheet_handle.dart';
import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:copycat_base/utils/utility.dart';
import 'package:flutter/material.dart';

class MenuItem {
  final String? text;
  final IconData? icon;
  final VoidCallback? onPressed;

  const MenuItem({
    this.text,
    this.icon,
    this.onPressed,
  });
}

class Menu extends InheritedWidget {
  final List<MenuItem> items;

  const Menu({
    super.key,
    required this.items,
    required super.child,
  });

  Future<void> openOptionBottomSheet(BuildContext context) async {
    final mq = context.mq;
    final mqSize = mq.size;
    final safeArea = mq.systemGestureInsets.bottom + padding16;
    final colors = context.colors;
    await showModalBottomSheet(
      context: context,
      scrollControlDisabledMaxHeightRatio: 0.8,
      constraints: BoxConstraints(
        maxWidth: mqSize.width * 0.9,
      ),
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: safeArea),
          child: Material(
            color: colors.surface,
            borderRadius: radius16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SheetHandle(),
                for (var menuItem in items)
                  ListTile(
                    leading: Icon(menuItem.icon),
                    title: Text(menuItem.text!),
                    onTap: () async {
                      Navigator.pop(context);
                      await wait(250);
                      menuItem.onPressed?.call();
                    },
                  ),
                height10,
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> openPopupMenu(BuildContext context, Offset offset) async {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final position = overlay.globalToLocal(offset);
    final RelativeRect positionPopup = RelativeRect.fromSize(
      Rect.fromPoints(position, position),
      overlay.size,
    );
    final options = <PopupMenuEntry<MenuItem>>[
      for (var menuItem in items)
        PopupMenuItem(
          height: 40,
          value: menuItem,
          mouseCursor: SystemMouseCursors.click,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(menuItem.icon, size: 18),
              width6,
              Text(menuItem.text!, overflow: TextOverflow.fade, maxLines: 1),
            ],
          ),
        ),
    ];
    final item = await showMenu(
      context: context,
      constraints: const BoxConstraints(minWidth: 120),
      position: positionPopup,
      items: options,
      popUpAnimationStyle: AnimationStyle.noAnimation,
    );
    await wait(250);
    item?.onPressed?.call();
  }

  static Menu? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Menu>();
  }

  static Menu of(BuildContext context) {
    final Menu? result = maybeOf(context);
    assert(result != null, 'No Menu found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant Menu oldWidget) {
    return items != oldWidget.items;
  }
}
