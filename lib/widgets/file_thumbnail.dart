import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:file_thumbnailer/file_thumbnailer.dart' as ft;
import 'package:flutter/material.dart';

class FileThumbnail extends StatelessWidget {
  final ClipboardItem item;
  final double widgetSize;
  final String? modifier;

  const FileThumbnail({
    super.key,
    required this.item,
    required this.widgetSize,
    this.modifier,
  });

  bool get _canShowThumbnail {
    final mimeType = item.fileMimeType?.trim();
    return item.inCache &&
        item.localPath != null &&
        mimeType?.isNotEmpty == true;
  }

  @override
  Widget build(BuildContext context) {
    if (!_canShowThumbnail) {
      return const Icon(Icons.insert_drive_file_rounded);
    }

    return ft.FileThumbnail(
      request: ft.ThumbnailRequest(
        filePath: item.localPath!,
        widgetSize: widgetSize,
        mimeType: item.fileMimeType?.trim(),
        fileSize: item.fileSize,
        modifier: modifier,
      ),
      errorWidget: const Icon(Icons.insert_drive_file_rounded),
    );
  }
}
