// ignore_for_file: use_build_context_synchronously

import 'package:clipboard/widgets/clip_item/leading_option.dart';
import 'package:clipboard/widgets/clip_item/primary_clip_action_button.dart';
import 'package:clipboard/widgets/clip_item/primary_hover_action_button.dart';
import 'package:clipboard/widgets/clip_item/secondary_clip_action_button.dart';
import 'package:clipboard/base/bloc/selected_clips_cubit/selected_clips_cubit.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/widgets/clip_item/clip_item_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClipCardOptionsHeader extends StatelessWidget {
  final bool hasFocusForPaste;
  final bool hovered;

  const ClipCardOptionsHeader({
    super.key,
    this.hasFocusForPaste = false,
    this.hovered = false,
  });

  @override
  Widget build(BuildContext context) {
    final item = ClipItemScope.of(context);
    final selectionActive = context.select(
      (SelectedClipsCubit cubit) => cubit.hasSelection,
    );

    return SizedBox(
      height: 36,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: LeadingClipboardOption(
                created: item.created,
                hovered: hovered || selectionActive,
              ),
            ),
          ),
          if (!selectionActive) const SecondaryClipActionButton(),
          if (!selectionActive)
            PrimaryClipActionButton(
              hasFocusForPaste: hasFocusForPaste,
              layout: AppLayout.grid,
            ),
          if (!selectionActive) const PrimaryHoverAction(),
        ],
      ),
    );
  }
}
