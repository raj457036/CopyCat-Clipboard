import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:emoji_selector/emoji_selector.dart';
import 'package:flutter/material.dart';

class EmojiSelectorSheet extends StatefulWidget {
  const EmojiSelectorSheet({super.key});

  @override
  State<EmojiSelectorSheet> createState() => _EmojiSelectorSheetState();

  Future<EmojiData?> open(BuildContext context) {
    final mqSize = context.mq.size;
    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      constraints: BoxConstraints(
        maxWidth: mqSize.width * 0.9,
      ),
      builder: (context) {
        return this;
      },
    );
  }
}

class _EmojiSelectorSheetState extends State<EmojiSelectorSheet> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrints) {
      int columns = 8;
      int rows = 6;
      if (constrints.maxWidth < 250) {
        columns = 4;
        rows = 6;
      }
      if (constrints.maxWidth < 400) {
        columns = 6;
        rows = 7;
      }
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      return Padding(
        padding: EdgeInsets.only(bottom: keyboardHeight),
        child: SingleChildScrollView(
          child: EmojiSelector(
            columns: columns,
            rows: rows,
            padding: EdgeInsets.only(
              left: padding10,
              right: padding10,
              bottom: padding38,
            ),
            withTitle: false,
            onSelected: Navigator.of(context).pop,
          ),
        ),
      );
    });
  }
}
