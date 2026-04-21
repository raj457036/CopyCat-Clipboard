import 'package:clipboard/base/constants/font_variations.dart';
import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:flutter/material.dart';

class TextPreviewBody extends StatelessWidget {
  final Color? bg;
  final Widget child;

  const TextPreviewBody({super.key, required this.child, this.bg});

  @override
  Widget build(BuildContext context) {
    final body = Padding(padding: const EdgeInsets.all(padding8), child: child);
    if (bg != null) {
      return Material(
        type: MaterialType.card,
        color: bg,
        borderRadius: radiusBottom12,
        child: body,
      );
    }
    return body;
  }
}

class TextClipCard extends StatelessWidget {
  final AppLayout layout;
  final ClipboardItem item;

  const TextClipCard({super.key, required this.layout, required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;

    switch (item.textCategory) {
      case TextCategory.color:
        final bg = textToColor(item);
        return SizedBox(
          width: double.infinity,
          child: TextPreviewBody(
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
          ),
        );
      case TextCategory.email:
      case TextCategory.phone:
        return SizedBox(
          width: double.infinity,
          child: TextPreviewBody(
            bg: colors.secondaryContainer,
            child: Align(
              heightFactor: 1,
              child: Text(
                item.text!,
                textAlign: TextAlign.center,
                style: textTheme.titleMedium?.copyWith(
                  fontVariations: fontVarW500,
                ),
                maxLines: 3,
                overflow: TextOverflow.fade,
              ),
            ),
          ),
        );
      case TextCategory.struct:
        return SizedBox(
          width: double.infinity,
          child: TextPreviewBody(
            bg: colors.tertiaryContainer,
            child: Text(
              item.text!,
              overflow: TextOverflow.fade,
              style: textTheme.bodyMedium?.copyWith(
                fontFamily: jetBrainsMonoFont,
                color: colors.onTertiaryContainer,
              ),
            ),
          ),
        );
      default:
        return SizedBox(
          width: double.infinity,
          child: TextPreviewBody(
            child: Text(
              item.text!,
              overflow: TextOverflow.fade,
              style: textTheme.bodyMedium,
            ),
          ),
        );
    }
  }
}
