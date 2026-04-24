import 'package:clipboard/widgets/clip_item/leading_option.dart';
import 'package:clipboard/widgets/clip_item/primary_clip_action_button.dart';
import 'package:clipboard/widgets/clip_item/primary_hover_action_button.dart';
import 'package:clipboard/widgets/clip_item/secondary_clip_action_button.dart';
import 'package:clipboard/widgets/clip_item/clip_item_scope.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:flutter/material.dart';

class ClipListItemOptionHeader extends StatelessWidget {
  final ClipboardItem item;
  final bool hasFocusForPaste;
  final bool hovered;
  final bool selected;
  final int selectionIndex;
  final bool selectionActive;

  const ClipListItemOptionHeader({
    super.key,
    required this.item,
    required this.hasFocusForPaste,
    required this.hovered,
    required this.selectionActive,
    required this.selectionIndex,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipItemScope(
      item: item,
      child: SizedBox(
        height: 36,
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: LeadingClipboardOption(
                  createdPadding: const EdgeInsets.symmetric(
                    vertical: padding4,
                    horizontal: padding10,
                  ),
                  created: item.created,
                  hovered: hovered || selectionActive,
                ),
              ),
            ),
            if (!selectionActive) const SecondaryClipActionButton(),
            if (!selectionActive)
              PrimaryClipActionButton(
                hasFocusForPaste: hasFocusForPaste,
                layout: AppLayout.list,
              ),
            if (!selectionActive) const PrimaryHoverAction(),
          ],
        ),
      ),
    );
  }
}
