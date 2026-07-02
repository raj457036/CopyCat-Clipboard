import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/file_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';

class FileClipCard extends StatelessWidget {
  final ClipboardItem item;

  const FileClipCard({super.key, required this.item});

  String _displayFileType() {
    final mimeType = item.fileMimeType;
    final extension = item.fileExtension?.replaceFirst('.', '').trim();

    final fromMime = mimeType == null || mimeType.isEmpty
        ? null
        : extensionFromMime(mimeType)?.trim();

    // Prefer real extension for generic/unknown mime types.
    if (fromMime == null || fromMime.isEmpty || fromMime == 'bin') {
      if (extension != null && extension.isNotEmpty) {
        return extension.toLowerCase();
      }
      return 'file';
    }

    return fromMime;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;
    final typeAndSize =
        "${_displayFileType()} • ${formatBytes(item.fileSize ?? 1024)}";
    final fileName = item.fileName?.sub(end: 30) ?? context.locale.app__no_name;

    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned.fill(child: FileThumbnail(item: item, widgetSize: 250)),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ColoredBox(
              color: colors.surface.withValues(alpha: .75),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: padding8,
                  vertical: padding6,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      typeAndSize,
                      style: textTheme.labelSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      fileName,
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
