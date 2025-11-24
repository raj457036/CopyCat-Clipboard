import 'package:clipboard/pages/home/widgets/search_bar.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/app_bar/selection_appbar.dart';
import 'package:flutter/material.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final size = context.mq.size;
    final scrollUnderElevation = size.width < 600 ? 4.0 : 0.0;
    final Widget defaultAppBar = size.shortestSide < 250
        ? const SizedBox.shrink()
        : AppBar(
            title: const SearchInputBar(),
            titleSpacing: 6,
            scrolledUnderElevation: scrollUnderElevation,
            centerTitle: true,
            backgroundColor: scrollUnderElevation > 0 ? null : colors.surface,
          );
    return SelectionAppbar(
      defaultChild: defaultAppBar,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
