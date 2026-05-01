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
    late final Widget defaultAppBar;
    if (size.shortestSide < 250) {
      defaultAppBar = const SizedBox.shrink();
    } else {
      defaultAppBar = AppBar(
        title: const SearchInputBar(),
        titleSpacing: 16,
        scrolledUnderElevation: 0.0,
        centerTitle: true,
        backgroundColor: colors.surface,
      );
    }
    return SelectionAppbar(defaultChild: defaultAppBar);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
