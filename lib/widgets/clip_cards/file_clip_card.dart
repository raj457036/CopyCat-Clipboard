import 'package:clipboard/base/constants/font_variations.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';

class FileClipCard extends StatelessWidget {
  final AppLayout layout;
  final ClipboardItem item;

  const FileClipCard({super.key, required this.item, required this.layout});

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

    return fromMime.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final label =
        "${_displayFileType()} • ${formatBytes(item.fileSize!)} • ${item.fileName?.sub(end: 30) ?? "No Name"}";

    return SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.all(padding8),
        child: Text(
          label,
          style: textTheme.labelMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
