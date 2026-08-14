import 'package:clipboard/base/constants/font_variations.dart';
import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:flutter/material.dart';

class TextPreviewBody extends StatelessWidget {
  final Color? bg;
  final Widget child;
  final bool liteMode;

  const TextPreviewBody({
    super.key,
    required this.child,
    this.bg,
    this.liteMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final body = Padding(
      padding: liteMode
          ? const EdgeInsets.all(padding8)
          : clipCardContentPadding,
      child: child,
    );
    if (bg != null) {
      return Ink(color: bg!, child: body);
    }
    return body;
  }
}

class TextClipCard extends StatelessWidget {
  final ClipboardItem item;
  final bool liteMode;

  const TextClipCard({super.key, required this.item, this.liteMode = false});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;

    switch (item.textCategory) {
      case TextCategory.color:
        final bg = textToColor(item);
        return TextPreviewBody(
          bg: bg,
          child: Center(
            child: Text(
              item.text!,
              style: textTheme.titleMedium?.copyWith(
                color: getFg(bg),
                fontVariations: fontVarW500,
              ),
            ),
          ),
        );
      case TextCategory.email || TextCategory.phone:
        return TextPreviewBody(
          bg: colors.surfaceContainerHighest,
          child: Align(
            heightFactor: 1,
            child: Text(
              item.text!,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                fontVariations: fontVarW500,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      case TextCategory.struct:
        return TextPreviewBody(
          bg: colors.tertiaryContainer,
          child: Text(
            item.text!,
            overflow: TextOverflow.visible,
            style: textTheme.bodySmall?.copyWith(
              fontFamily: jetBrainsMonoFont,
              color: colors.onTertiaryContainer,
            ),
          ),
        );
      default:
        return TextPreviewBody(
          liteMode: liteMode,
          child: Text(
            item.text!,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium,
            maxLines: 12,
          ),
        );
    }
  }
}
