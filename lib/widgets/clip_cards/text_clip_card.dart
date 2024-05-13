import 'package:clipboard/constants/widget_styles.dart';
import 'package:clipboard/db/clipboard_item/clipboard_item.dart';
import 'package:clipboard/enums/clip_type.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:flutter/material.dart';

class TextPreviewBody extends StatelessWidget {
  final Color? bg;
  final Widget child;

  const TextPreviewBody({
    super.key,
    required this.child,
    this.bg,
  });

  @override
  Widget build(BuildContext context) {
    final body = SizedBox.expand(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(padding8),
          child: child,
        ),
      ),
    );
    if (bg != null) {
      return Material(
        color: bg,
        borderRadius: radius8,
        child: body,
      );
    }
    return body;
  }
}

class TextClipCard extends StatelessWidget {
  final ClipboardItem item;

  const TextClipCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;

    Color? fg;
    final bg = hexToColor(item);
    if (bg != null) {
      fg = getFg(bg);
    }

    switch (item.textCategory) {
      case TextCategory.color:
        return TextPreviewBody(
          bg: bg,
          child: Text(
            item.text!,
            style: textTheme.titleMedium?.copyWith(
              color: fg,
            ),
          ),
        );
      case TextCategory.email:
      case TextCategory.phone:
        return TextPreviewBody(
          bg: colors.secondaryContainer,
          child: Text(
            item.text!,
            style: textTheme.titleMedium,
            maxLines: 2,
            overflow: TextOverflow.fade,
          ),
        );
      default:
        return TextPreviewBody(
          child: Text(
            item.text!,
            overflow: TextOverflow.fade,
            // maxLines: 10,
            style: textTheme.bodySmall,
          ),
        );
    }
  }
}
