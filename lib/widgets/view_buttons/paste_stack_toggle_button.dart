import 'package:clipboard/base/bloc/paste_stack_cubit/paste_stack_cubit.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/select_clip_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PasteStackToggleButton extends StatelessWidget {
  const PasteStackToggleButton({super.key});

  Future<void> toggle(BuildContext context, bool active) async {
    await context.read<PasteStackCubit>().toggle();
    if (context.mounted && !active) {
      context.goNamed(RouteConstants.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SelectedClipBuilder(
      builder: (context, items) {
        if (items.isNotEmpty) {
          return const SizedBox.shrink();
        }
        return BlocSelector<PasteStackCubit, PasteStackState, bool>(
          selector: (state) => state.active,
          builder: (context, active) {
            return IconButton(
              onPressed: () => toggle(context, active),
              padding: EdgeInsets.zero,
              style: IconButton.styleFrom(
                shape: const RoundedRectangleBorder(),
                backgroundColor: active ? colors.primaryContainer : null,
              ),
              iconSize: 20,
              icon: Icon(
                active
                    ? Icons.keyboard_double_arrow_down_rounded
                    : Icons.line_weight_rounded,
              ),
              tooltip: active ? 'Close Paste Stack' : 'Open Paste Stack',
            );
          },
        );
      },
    );
  }
}
