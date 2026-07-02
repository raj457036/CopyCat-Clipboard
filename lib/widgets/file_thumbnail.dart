import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:thumbnailer/thumbnailer.dart';
import 'package:universal_io/io.dart';

class FileThumbnail extends StatelessWidget {
  final ClipboardItem item;
  final double widgetSize;

  const FileThumbnail({
    super.key,
    required this.item,
    required this.widgetSize,
  });

  bool get _canShowThumbnail {
    final mimeType = item.fileMimeType?.trim();
    return item.inCache &&
        item.localPath != null &&
        mimeType?.isNotEmpty == true;
  }

  bool get _useIconOnly => (item.fileSize ?? 0) > (10 * 1024 * 1024);

  @override
  Widget build(BuildContext context) {
    final mimeType = item.fileMimeType?.trim();

    if (!_canShowThumbnail || mimeType == null) {
      return const Icon(Icons.insert_drive_file_rounded);
    }

    return Thumbnail(
      mimeType: mimeType,
      widgetSize: widgetSize,
      onlyIcon: _useIconOnly,
      useWrapper: false,
      useWaterMark: false,
      name: item.fileName,
      decoration: WidgetDecoration(
        backgroundColor: context.colors.surfaceContainer,
        iconColor: context.colors.onSurface,
      ),
      dataSize: item.fileSize,
      dataResolver: _useIconOnly
          ? null
          : () => File(item.localPath!).readAsBytes(),
      errorBuilder: (context, error) =>
          const Icon(Icons.insert_drive_file_rounded),
    );
  }
}
