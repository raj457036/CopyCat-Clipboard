import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/sheets/sheet_handle.dart';
import 'package:flutter/material.dart';

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

/// Returned by [Menu.of]. Use this to open the menu.
class MenuHandle {
  final _MenuState _state;
  MenuHandle._(this._state);

  Future<void> openMenu(BuildContext context) => _state._openMenu(context);

  void openPopupMenu(BuildContext context, Offset globalPosition) =>
      _state._openPopupMenu(context, globalPosition);
}

class _MenuScope extends InheritedWidget {
  final MenuHandle handle;
  const _MenuScope({required this.handle, required super.child});

  @override
  bool updateShouldNotify(_MenuScope old) => handle != old.handle;
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

  static MenuHandle of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'No Menu found in context');
    return result!;
  }

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final _menuController = MenuController();
  final _menuAnchorKey = GlobalKey();
  late final MenuHandle _handle = MenuHandle._(this);

  static const _cardWidth = 260.0;
  static const _cardRadius = 14.0;
  static const _groupGap = 6.0;

  static const _itemStyle = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(Colors.transparent),
    padding: WidgetStatePropertyAll(
      EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    ),
    visualDensity: VisualDensity.comfortable,
  );

  static const _panelStyle = MenuStyle(
    backgroundColor: WidgetStatePropertyAll(Colors.transparent),
    shadowColor: WidgetStatePropertyAll(Colors.transparent),
    surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
    elevation: WidgetStatePropertyAll(0),
    padding: WidgetStatePropertyAll(EdgeInsets.all(8)),
    side: WidgetStatePropertyAll(BorderSide.none),
  );

  Future<void> _runBeforeOpen() async {
    final callback = widget.onBeforeOpen;
    if (callback == null) return;
    try {
      await callback();
    } catch (_) {}
  }

  void _openPopupMenu(BuildContext context, Offset globalPosition) async {
    await _runBeforeOpen();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final box =
          _menuAnchorKey.currentContext?.findRenderObject() as RenderBox?;
      _menuController.open(
        position: box?.globalToLocal(globalPosition) ?? globalPosition,
      );
    });
  }

  List<Widget> _buildMenuChildren(BuildContext context) {
    final grouped = _grouped(_limitItems(widget.items));
    final colors = context.colors;
    final cardColor = colors.surfaceBright;
    final sections = <Widget>[];

    for (final entry in grouped.entries) {
      if (sections.isNotEmpty) sections.add(const SizedBox(height: _groupGap));

      sections.add(
        _MenuCard(
          width: _cardWidth,
          radius: _cardRadius,
          color: cardColor,
          shadowColor: colors.shadow,
          children: [
            if (entry.key != null) _SectionLabel(entry.key!),
            for (final item in entry.value)
              if (item.children.isNotEmpty)
                _buildSubmenuButton(context, item, cardColor, colors)
              else
                _buildItemButton(item, colors),
          ],
        ),
      );
    }

    return sections;
  }

  Widget _buildItemButton(MenuItem item, ColorScheme colors) => MenuItemButton(
    style: _itemStyle,
    leadingIcon: item.icon != null
        ? Icon(item.icon, size: 18, color: colors.onSurfaceVariant)
        : null,
    onPressed: item.onPressed,
    child: Text(item.text ?? ''),
  );

  Widget _buildSubmenuButton(
    BuildContext context,
    MenuItem item,
    Color cardColor,
    ColorScheme colors,
  ) => SubmenuButton(
    style: _itemStyle,
    menuStyle: _panelStyle,
    leadingIcon: item.icon != null
        ? Icon(item.icon, size: 18, color: colors.onSurfaceVariant)
        : null,
    menuChildren: [
      _MenuCard(
        width: _cardWidth,
        radius: _cardRadius,
        color: cardColor,
        shadowColor: colors.shadow,
        children: item.children
            .map((child) => _buildItemButton(child, colors))
            .toList(),
      ),
    ],
    child: Text(item.text ?? ''),
  );

  List<MenuItem> _limitItems(List<MenuItem> source) {
    if (source.length <= 10) return source;
    return [
      ...source.take(9),
      MenuItem(
        text: 'More',
        icon: Icons.more_horiz_rounded,
        section: 'More',
        children: source
            .skip(9)
            .map(
              (e) => MenuItem(
                text: e.text,
                icon: e.icon,
                onPressed: e.onPressed,
                section: e.section,
              ),
            )
            .toList(),
      ),
    ];
  }

  Map<String?, List<MenuItem>> _grouped(List<MenuItem> source) {
    final map = <String?, List<MenuItem>>{};
    for (final item in source) {
      map.putIfAbsent(item.section, () => []).add(item);
    }
    return map;
  }

  Future<void> _openMenu(BuildContext context) async {
    await _runBeforeOpen();
    if (!context.mounted) return;
    final mq = context.mq;
    final colors = context.colors;
    final safeArea = mq.systemGestureInsets.bottom + padding8;
    final grouped = _grouped(widget.items);

    await showModalBottomSheet(
      context: context,
      scrollControlDisabledMaxHeightRatio: 0.8,
      constraints: BoxConstraints(maxWidth: mq.size.width * 0.9),
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: safeArea),
        child: Material(
          color: colors.surface,
          borderRadius: radius16,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: mq.size.height * 0.8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SheetHandle(),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (final entry in grouped.entries) ...[
                        if (entry.key != null)
                          _BottomSheetSectionLabel(entry.key!),
                        for (final item in entry.value)
                          ListTile(
                            leading: Icon(item.icon),
                            title: Text(item.text!),
                            onTap: () async {
                              Navigator.pop(context);
                              await wait(250);
                              item.onPressed?.call();
                            },
                          ),
                      ],
                      height10,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    widget.onAfterClose?.call();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _MenuScope(
      handle: _handle,
      child: MenuAnchor(
        key: _menuAnchorKey,
        controller: _menuController,
        style: _panelStyle,
        onClose: widget.onAfterClose,
        menuChildren: _buildMenuChildren(context),
        child: widget.child,
      ),
    );
  }
}

/// A rounded card that wraps a group of menu items.
class _MenuCard extends StatelessWidget {
  final double width;
  final double radius;
  final Color color;
  final Color shadowColor;
  final List<Widget> children;

  const _MenuCard({
    required this.width,
    required this.radius,
    required this.color,
    required this.shadowColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxWidth: width,
      child: Material(
        elevation: 2,
        type: MaterialType.button,
        shadowColor: shadowColor,
        borderRadius: BorderRadius.circular(radius),
        color: color,
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}

/// Uppercase section label rendered inside a card.
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 2),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: context.colors.onSurfaceVariant,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

/// Section label used in the mobile bottom-sheet (non-uppercase, larger).
class _BottomSheetSectionLabel extends StatelessWidget {
  final String text;
  const _BottomSheetSectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: context.colors.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
