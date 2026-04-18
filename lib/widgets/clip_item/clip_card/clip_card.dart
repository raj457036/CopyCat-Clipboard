import 'package:clipboard/widgets/clip_item/clip_card/clip_card_body.dart';
import 'package:clipboard/widgets/clip_item/clip_menu_provider.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:flutter/material.dart';

class ClipCard extends StatelessWidget {
  final bool autoFocus;
  final bool selected;
  final int selectionIndex;
  final bool selectionActive;
  final ClipboardItem item;

  const ClipCard({
    super.key,
    required this.item,
    this.autoFocus = true,
    this.selected = false,
    this.selectionActive = false,
    required this.selectionIndex,
  });

  @override
  Widget build(BuildContext context) {
    return ClipMenuProvider(
      item: item,
      child: ClipCardBody(
        item: item,
        focused: autoFocus,
        selected: selected,
        selectionActive: selectionActive,
        selectionIndex: selectionIndex,
      ),
    );
  }
}
