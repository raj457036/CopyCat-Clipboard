import 'package:animate_do/animate_do.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/pages/home/widgets/collection_filter_chips.dart';
import 'package:clipboard/routes/utils.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/yarn_ball_loading.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int navbarActiveIndex;
  const BottomNavBar({super.key, required this.navbarActiveIndex});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth <= 330) return const SizedBox.shrink();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (navbarActiveIndex == 0)
              const CollectionFilterChips(placedInBottomNavBar: true),
            NavigationBar(
              selectedIndex: navbarActiveIndex,
              onDestinationSelected: (idx) => onNavItemTapped(context, idx),
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.paste_rounded),
                  selectedIcon: const Swing(child: Icon(Icons.paste_rounded)),
                  label: context.locale.layout__navbar__clipboard.sub(end: 15),
                  tooltip: context.locale.layout__navbar__clipboard,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.folder_outlined),
                  selectedIcon: const Tada(child: Icon(Icons.folder_rounded)),
                  label: context.locale.layout__navbar__collections,
                  tooltip: context.locale.layout__navbar__collections,
                ),
                NavigationDestination(
                  icon: YarnBall(size: 28, color: context.colors.onSurface),
                  selectedIcon: Spin(
                    duration: Durations.medium4,
                    spins: 0.4,
                    child: YarnBall(size: 28, color: context.colors.onSurface),
                  ),
                  label: context.locale.layout__navbar__settings.sub(end: 8),
                  tooltip: context.locale.layout__navbar__settings,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
