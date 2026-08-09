import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/clip_cards/file_display_name_mixin.dart';
import 'package:clipboard/widgets/file_thumbnail.dart';
import 'package:flutter/material.dart';

class FileClipCard extends FileTypePreview {
  const FileClipCard({super.key, required super.item});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;
    final typeAndSize =
        "${displayFileType().toUpperCase()} • ${formatBytes(item.fileSize ?? 1024)}";
    final fileName = item.fileName?.sub(end: 30);

    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned.fill(child: FileThumbnail(item: item, widgetSize: 250)),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ColoredBox(
              color: colors.surfaceContainerLow,
              child: Padding(
                padding: const EdgeInsets.all(padding8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: padding4,
                  children: [
                    if (fileName != null && fileName.isNotEmpty)
                      Text(
                        fileName,
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    Text(
                      typeAndSize,
                      style: textTheme.labelMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
