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

class Menu extends InheritedWidget {
  final List<MenuItem> items;

  const Menu({super.key, required this.items, required super.child});

  Future<void> openOptionBottomSheet(BuildContext context) async {
    final mq = context.mq;
    final mqSize = mq.size;
    final safeArea = mq.systemGestureInsets.bottom + padding8;
    final colors = context.colors;
    final groupedItems = _grouped(items);

    await showModalBottomSheet(
      context: context,
      scrollControlDisabledMaxHeightRatio: 0.8,
      constraints: BoxConstraints(maxWidth: mqSize.width * 0.9),
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: safeArea),
          child: Material(
            color: colors.surface,
            borderRadius: radius16,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: mqSize.height * 0.8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SheetHandle(),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        for (final entry in groupedItems.entries) ...[
                          if (entry.key != null)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                              child: Text(
                                entry.key!,
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                      color: colors.onSurfaceVariant,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          for (final menuItem in entry.value)
                            ListTile(
                              leading: Icon(menuItem.icon),
                              title: Text(menuItem.text!),
                              onTap: () async {
                                Navigator.pop(context);
                                await wait(250);
                                menuItem.onPressed?.call();
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
        );
      },
    );
  }

  Future<void> openPopupMenu(BuildContext context, Offset offset) async {
    final normalized = _limitPopupItems(items);
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss menu',
      barrierColor: Colors.transparent,
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return _DesktopPopupMenuDialog(anchorOffset: offset, items: normalized);
      },
    );
  }

  List<MenuItem> _limitPopupItems(List<MenuItem> source) {
    if (source.length <= 10) return source;
    final first = source.take(9).toList();
    final rest = source
        .skip(9)
        .map(
          (item) => MenuItem(
            text: item.text,
            icon: item.icon,
            onPressed: item.onPressed,
            section: item.section,
          ),
        )
        .toList();
    return [
      ...first,
      MenuItem(
        text: 'More',
        icon: Icons.more_horiz_rounded,
        section: 'More',
        children: rest,
      ),
    ];
  }

  Map<String?, List<MenuItem>> _grouped(List<MenuItem> source) {
    final grouped = <String?, List<MenuItem>>{};
    for (final item in source) {
      grouped.putIfAbsent(item.section, () => <MenuItem>[]).add(item);
    }
    return grouped;
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

class _DesktopPopupMenuDialog extends StatefulWidget {
  final Offset anchorOffset;
  final List<MenuItem> items;

  const _DesktopPopupMenuDialog({
    required this.anchorOffset,
    required this.items,
  });

  @override
  State<_DesktopPopupMenuDialog> createState() =>
      _DesktopPopupMenuDialogState();
}

class _DesktopPopupMenuDialogState extends State<_DesktopPopupMenuDialog> {
  static const _desktopPanelMaxHeight = 560.0;

  MenuItem? _hoveredParent;
  double _submenuTop = 0;

  double _estimatePanelHeight(List<MenuItem> items) {
    final sectionCount = items
        .map((e) => e.section)
        .whereType<String>()
        .toSet()
        .length;
    final estimate = 16.0 + (items.length * 40.0) + (sectionCount * 28.0);
    return estimate.clamp(120.0, _desktopPanelMaxHeight).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const menuWidth = 280.0;
    const submenuWidth = 300.0;
    const margin = 8.0;
    final mainPanelHeight = _estimatePanelHeight(widget.items);
    final mainMaxTop = (size.height - mainPanelHeight - margin) > margin
        ? (size.height - mainPanelHeight - margin)
        : margin;

    final mainLeft = widget.anchorOffset.dx.clamp(
      margin,
      (size.width - menuWidth - margin).clamp(margin, double.infinity),
    );
    final mainTop = widget.anchorOffset.dy.clamp(margin, mainMaxTop);

    final submenuLeft = (mainLeft + menuWidth + 6).clamp(
      margin,
      (size.width - submenuWidth - margin).clamp(margin, double.infinity),
    );
    final submenuPanelHeight = _estimatePanelHeight(
      _hoveredParent?.children ?? const [],
    );
    final submenuMaxTop = (size.height - submenuPanelHeight - margin) > margin
        ? (size.height - submenuPanelHeight - margin)
        : margin;
    final submenuTop = _submenuTop == 0
        ? mainTop
        : _submenuTop.clamp(margin, submenuMaxTop);

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            left: mainLeft,
            top: mainTop,
            width: menuWidth,
            child: _DesktopMenuPanel(
              items: widget.items,
              showChildrenHint: true,
              onHover: (item, globalDy) {
                if (!mounted) return;
                setState(() {
                  _hoveredParent = item;
                  _submenuTop = globalDy - 12;
                });
              },
              onPressed: (item) async {
                if (item.children.isNotEmpty) return;
                Navigator.pop(context);
                await wait(250);
                item.onPressed?.call();
              },
            ),
          ),
          if (_hoveredParent != null)
            Positioned(
              left: submenuLeft,
              top: submenuTop,
              width: submenuWidth,
              child: _DesktopMenuPanel(
                items: _hoveredParent!.children,
                showChildrenHint: false,
                onHover: (item, globalDy) {},
                onPressed: (item) async {
                  Navigator.pop(context);
                  await wait(250);
                  item.onPressed?.call();
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _DesktopMenuPanel extends StatelessWidget {
  static const _desktopPanelMaxHeight = 560.0;

  final List<MenuItem> items;
  final bool showChildrenHint;
  final void Function(MenuItem? item, double globalDy) onHover;
  final Future<void> Function(MenuItem item) onPressed;

  const _DesktopMenuPanel({
    required this.items,
    required this.showChildrenHint,
    required this.onHover,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final popupTheme = Theme.of(context).popupMenuTheme;
    final shape = popupTheme.shape;
    final colors = context.colors;
    final grouped = <String?, List<MenuItem>>{};
    for (final item in items) {
      grouped.putIfAbsent(item.section, () => <MenuItem>[]).add(item);
    }

    return Material(
      elevation: popupTheme.elevation ?? 8,
      borderRadius: shape == null ? radius12 : null,
      color: popupTheme.color ?? colors.surface,
      shadowColor: popupTheme.shadowColor,
      shape: shape,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: _desktopPanelMaxHeight),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            for (final entry in grouped.entries) ...[
              if (entry.key != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                  child: Text(
                    entry.key!,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colors.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              for (final item in entry.value)
                MouseRegion(
                  onHover: (event) {
                    if (item.children.isNotEmpty) {
                      onHover(item, event.position.dy);
                    } else {
                      onHover(null, event.position.dy);
                    }
                  },
                  child: InkWell(
                    onTap: () => onPressed(item),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      child: Row(
                        children: [
                          if (item.icon != null) Icon(item.icon, size: 18),
                          if (item.icon != null) width6,
                          Expanded(
                            child: Text(
                              item.text ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (showChildrenHint && item.children.isNotEmpty)
                            const Icon(Icons.chevron_right_rounded, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
