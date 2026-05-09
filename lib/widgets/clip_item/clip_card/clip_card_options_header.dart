// ignore_for_file: use_build_context_synchronously

import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/clip_item/clip_card/hover_state_builder.dart'
    show HoverScope;
import 'package:clipboard/widgets/clip_item/leading_option.dart';
import 'package:clipboard/widgets/clip_item/primary_clip_action_button.dart';
import 'package:clipboard/widgets/clip_item/primary_hover_action_button.dart';
import 'package:clipboard/widgets/clip_item/secondary_clip_action_button.dart';
import 'package:clipboard/base/bloc/selected_clips_cubit/selected_clips_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClipCardOptionsHeader extends StatelessWidget {
  const ClipCardOptionsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final selectionActive = context.select(
      (SelectedClipsCubit cubit) => cubit.hasSelection,
    );
    final hovered = HoverScope.of(context);

    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      descendantsAreFocusable: false,
      child: SizedBox(
        height: 36,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: LeadingClipboardOption(
                  hovered: hovered || selectionActive,
                ),
              ),
            ),
            if (!selectionActive && hovered) const SecondaryClipActionButton(),
            if (!selectionActive) const PrimaryClipActionButton(),
            if (!selectionActive && isDesktopPlatform)
              PrimaryHoverAction(hovered: hovered),
          ],
        ),
      ),
    );
  }
}
