import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/routes/utils.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:flutter/material.dart';

class CopyCatNavrail extends StatelessWidget {
  final Widget? floatingActionButton;
  final int navbarActiveIndex;

  const CopyCatNavrail({
    super.key,
    this.floatingActionButton,
    required this.navbarActiveIndex,
  });

  @override
  Widget build(BuildContext context) {
    return ExcludeFocus(
      child: NavigationRail(
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        destinations: [
          NavigationRailDestination(
            padding: const EdgeInsets.all(padding6),
            icon: Tooltip(
              message: keyboardShortcut(key: "D"),
              child: const Icon(Icons.paste_outlined),
            ),
            selectedIcon: Tooltip(
              message: keyboardShortcut(key: "D"),
              child: const Icon(Icons.paste_rounded),
            ),
            label: Text(
              context.locale.layout__navbar__clipboard,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          NavigationRailDestination(
            padding: const EdgeInsets.all(padding6),
            icon: Tooltip(
              message: keyboardShortcut(key: "C"),
              child: const Icon(Icons.collections_bookmark_outlined),
            ),
            selectedIcon: Tooltip(
              message: keyboardShortcut(key: "C"),
              child: const Icon(Icons.collections_bookmark_rounded),
            ),
            label: Text(
              context.locale.layout__navbar__collections,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          NavigationRailDestination(
            padding: const EdgeInsets.all(padding6),
            icon: Tooltip(
              message: keyboardShortcut(key: "X"),
              child: const Icon(Icons.settings_outlined),
            ),
            selectedIcon: Tooltip(
              message: keyboardShortcut(key: "X"),
              child: const Icon(Icons.settings),
            ),
            label: Text(
              context.locale.layout__navbar__settings,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
        leading: SizedBox(height: 155, child: floatingActionButton),
        labelType: NavigationRailLabelType.all,
        groupAlignment: -.5,
        selectedIndex: navbarActiveIndex,
        onDestinationSelected: (idx) => onNavItemTapped(context, idx),
      ),
    );
  }
}
