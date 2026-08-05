import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';

abstract class FileTypePreview extends StatelessWidget {
  final ClipboardItem item;
  const FileTypePreview({super.key, required this.item});

  String displayFileType() {
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
}
