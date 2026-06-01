part of '../menu.dart';

List<Widget> _buildDesktopMenuChildren(
  BuildContext context,
  List<MenuItem> source,
) {
  final grouped = _groupedMenuItems(source);
  final children = <Widget>[];

  for (final entry in grouped.entries) {
    if (children.isNotEmpty) {
      children.add(const Divider(height: 8));
    }

    if (entry.key != null) {
      children.add(_DesktopSectionLabel(entry.key!));
    }

    children.addAll(entry.value.map(_buildDesktopMenuButton));
  }

  return children;
}

Widget _buildDesktopMenuButton(MenuItem item) {
  if (item.children.isNotEmpty) {
    return SubmenuButton(
      leadingIcon: item.icon != null ? Icon(item.icon, size: 18) : null,
      menuChildren: item.children.map(_buildDesktopMenuButton).toList(),
      child: Text(item.text ?? ''),
    );
  }

  return MenuItemButton(
    leadingIcon: item.icon != null ? Icon(item.icon, size: 18) : null,
    onPressed: item.onPressed,
    child: Text(item.text ?? ''),
  );
}

List<MenuItem> _limitMenuItems(List<MenuItem> source) {
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

List<MenuItem> _flattenBottomSheetItems(
  List<MenuItem> source, {
  String? fallbackSection,
}) {
  final flattened = <MenuItem>[];

  for (final item in source) {
    final section = item.section ?? fallbackSection;

    if (item.onPressed != null || item.children.isEmpty) {
      flattened.add(
        MenuItem(
          text: item.text,
          icon: item.icon,
          onPressed: item.onPressed,
          section: section,
        ),
      );
    }

    if (item.children.isNotEmpty) {
      flattened.addAll(
        _flattenBottomSheetItems(
          item.children,
          fallbackSection: item.text ?? section,
        ),
      );
    }
  }

  return flattened;
}

Map<String?, List<MenuItem>> _groupedMenuItems(List<MenuItem> source) {
  final map = <String?, List<MenuItem>>{};
  for (final item in source) {
    map.putIfAbsent(item.section, () => []).add(item);
  }
  return map;
}

Future<void> _showMenuBottomSheet({
  required BuildContext context,
  required Map<String?, List<MenuItem>> groupedItems,
}) async {
  final mq = context.mq;
  final colors = context.colors;
  final safeArea = mq.systemGestureInsets.bottom + padding8;

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
                    for (final entry in groupedItems.entries) ...[
                      if (entry.key != null)
                        _BottomSheetSectionLabel(entry.key!),
                      for (final item in entry.value)
                        ListTile(
                          leading: item.icon != null ? Icon(item.icon) : null,
                          title: Text(item.text ?? ''),
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
}

class _DesktopSectionLabel extends StatelessWidget {
  final String text;

  const _DesktopSectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
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
