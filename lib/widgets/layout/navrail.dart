import 'package:clipboard/routes/utils.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:flutter/material.dart';

class NavLayoutNavrail extends StatelessWidget {
  final Widget? floatingActionButton;
  final int navbarActiveIndex;

  const NavLayoutNavrail({
    super.key,
    this.floatingActionButton,
    required this.navbarActiveIndex,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final selectedLabelStyle =
        textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600);
    final unselectedlabelStyle =
        textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w400);
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      descendantsAreFocusable: false,
      descendantsAreTraversable: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            // physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                maxWidth: 80,
              ),
              child: IntrinsicHeight(
                child: NavigationRailTheme(
                  data: NavigationRailThemeData(
                    selectedLabelTextStyle: selectedLabelStyle,
                    unselectedLabelTextStyle: unselectedlabelStyle,
                  ),
                  child: NavigationRail(
                    destinations: [
                      NavigationRailDestination(
                        padding: const EdgeInsets.symmetric(vertical: padding6),
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
                        padding: const EdgeInsets.symmetric(vertical: padding6),
                        icon: Tooltip(
                          message: keyboardShortcut(key: "C"),
                          child:
                              const Icon(Icons.collections_bookmark_outlined),
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
                        padding: const EdgeInsets.symmetric(vertical: padding6),
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
                    // TODO(raj): replace with a better ux
                    // trailing: const AttentionButton(),
                    leading: SizedBox(
                      height: 155,
                      child: floatingActionButton,
                    ),
                    labelType: NavigationRailLabelType.all,
                    groupAlignment: -.5,
                    selectedIndex: navbarActiveIndex,
                    onDestinationSelected: (idx) =>
                        onNavItemTapped(context, idx),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
