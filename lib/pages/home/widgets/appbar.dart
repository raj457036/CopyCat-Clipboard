import 'package:clipboard/base/bloc/paste_stack_cubit/paste_stack_cubit.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/pages/home/widgets/search_bar.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/app_bar/selection_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final size = context.mq.size;
    final scrollUnderElevation = size.width < 600 ? 4.0 : 0.0;
    return BlocSelector<PasteStackCubit, PasteStackState, (bool, int)>(
      selector: (state) => (state.active, state.count),
      builder: (context, state) {
        final (active, count) = state;
        final Widget defaultAppBar = active
            ? AppBar(
                title: Text("Paste Stack • $count"),
                centerTitle: false,
                actions: [
                  IconButton(
                    onPressed: () =>
                        context.read<PasteStackCubit>().deactivate(),
                    tooltip: "Close Paste Stack",
                    icon: const Icon(Icons.keyboard_double_arrow_down_rounded),
                  ),
                ],
              )
            : size.shortestSide < 250
            ? const SizedBox.shrink()
            : AppBar(
                title: const SearchInputBar(),
                titleSpacing: 6,
                scrolledUnderElevation: scrollUnderElevation,
                centerTitle: true,
                backgroundColor: scrollUnderElevation > 0
                    ? null
                    : colors.surface,
              );
        return SelectionAppbar(defaultChild: defaultAppBar);
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
