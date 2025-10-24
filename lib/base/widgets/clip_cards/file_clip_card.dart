import 'package:clipboard/base/constants/font_variations.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/db/app_config/appconfig.dart';
import 'package:clipboard/base/db/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/utils/utility.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';

class FileClipCard extends StatelessWidget {
  final AppLayout layout;
  final ClipboardItem item;

  const FileClipCard({
    super.key,
    required this.item,
    required this.layout,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    final label =
        "~${formatBytes(item.fileSize!)} • ${extensionFromMime(item.fileMimeType!)}";

    final metaChip = Chip(
      labelPadding: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(horizontal: padding6),

      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: const StadiumBorder(),
      label: Text(
        label,
        style: textTheme.labelSmall?.copyWith(fontVariations: fontVarW700),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      // side: BorderSide.none,
    );

    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.all(padding8),
        child: Stack(
          children: [
            Text(
              item.fileName?.sub(end: 25) ?? "No Name",
              overflow: TextOverflow.fade,
              maxLines: 5,
              textAlign: TextAlign.center,
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurface,
                height: 1.8,
              ),
            ),
            Align(
              alignment: const Alignment(0.0, 0.95),
              child: metaChip,
            ),
          ],
        ),
      ),
    );
  }
}
