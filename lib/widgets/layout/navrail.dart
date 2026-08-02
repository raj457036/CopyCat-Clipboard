import 'package:animate_do/animate_do.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/routes/utils.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/yarn_ball_loading.dart';
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
    final clipboardTooltip =
        "${context.locale.layout__navbar__clipboard} • ${keyboardShortcut(key: "D")}";
    final collectionsTooltip =
        "${context.locale.layout__navbar__collections} • ${keyboardShortcut(key: "C")}";
    final settingsTooltip =
        "${context.locale.layout__navbar__settings} • ${keyboardShortcut(key: "X")}";

    const duration = Duration(milliseconds: 1500);

    return ExcludeFocus(
      child: NavigationRail(
        selectedLabelTextStyle: context.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        destinations: [
          NavigationRailDestination(
            padding: const EdgeInsets.symmetric(vertical: padding12),
            icon: Tooltip(
              message: clipboardTooltip,
              child: const Icon(Icons.paste_outlined),
            ),
            selectedIcon: Tooltip(
              message: clipboardTooltip,
              child: const Swing(
                duration: duration,
                child: Icon(Icons.paste_rounded),
              ),
            ),
            label: Text(
              context.locale.layout__navbar__clipboard,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          NavigationRailDestination(
            padding: const EdgeInsets.symmetric(vertical: padding12),
            icon: Tooltip(
              message: collectionsTooltip,
              child: const Icon(Icons.folder_outlined),
            ),
            selectedIcon: Tooltip(
              message: collectionsTooltip,
              child: const Tada(
                duration: duration,
                child: Icon(Icons.folder_rounded),
              ),
            ),
            label: Text(
              context.locale.layout__navbar__collections,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          NavigationRailDestination(
            padding: const EdgeInsets.symmetric(vertical: padding12),
            icon: Tooltip(
              message: settingsTooltip,
              child: YarnBall(size: 28, color: context.colors.onSurface),
            ),
            selectedIcon: Tooltip(
              message: settingsTooltip,
              child: Spin(
                duration: Durations.medium4,
                spins: 0.4,
                child: YarnBall(size: 28, color: context.colors.onSurface),
              ),
            ),
            label: Text(
              context.locale.layout__navbar__settings,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
        minWidth: 86,
        leadingAtTop: true,
        leading: SizedBox(height: 155, child: floatingActionButton),
        labelType: NavigationRailLabelType.none,
        groupAlignment: -.5,
        selectedIndex: navbarActiveIndex,
        onDestinationSelected: (idx) => onNavItemTapped(context, idx),
      ),
    );
  }
}
