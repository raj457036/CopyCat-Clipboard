import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/constants/widgets.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/blur_hash.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/clip_cards/file_display_name_mixin.dart';
import 'package:clipboard/widgets/clipcard_loading.dart';
import 'package:file_thumbnailer/file_thumbnailer.dart' as ft;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import "package:universal_io/io.dart";

final mediaMimeRegex = RegExp("video|image|audio");

class MediaPreview extends StatelessWidget {
  final ClipboardItem item;
  const MediaPreview({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final mime = item.fileMimeType?.toLowerCase() ?? '';

    if (mime.startsWith('audio')) {
      return Center(
        child: Icon(
          Icons.graphic_eq_rounded,
          size: 48,
          color: context.colors.onSurfaceVariant,
        ),
      );
    }

    if (item.localPath != null) {
      if (mime.contains('svg')) {
        return SvgPicture.file(File(item.localPath!), width: 360);
      }

      return ft.FileThumbnail(
        request: ft.ThumbnailRequest(
          filePath: item.localPath!,
          widgetSize: 320,
          mimeType: item.fileMimeType,
          fileSize: item.fileSize,
        ),
        fit: BoxFit.cover,
        alignment: Alignment.center,
        showVideoBadge: mime.startsWith('video'),
        placeholder: placeholderImage,
        errorWidget: placeholderImage,
      );
    }

    if (item.imgBlurHash == null) {
      return placeholderImage;
    }

    try {
      return FutureBuilder(
        future: getImageFromBlurHash(item.imgBlurHash!),
        builder: (context, ss) {
          if (ss.hasError) {
            return Center(child: Text(context.locale.app__unknown_error));
          }
          if (!ss.hasData) return loadingCard;

          return Image.memory(
            ss.data!,
            gaplessPlayback: true,
            fit: BoxFit.cover,
          );
        },
      );
    } catch (e) {
      return placeholderImage;
    }
  }
}

class MediaClipCard extends FileTypePreview {
  const MediaClipCard({super.key, required super.item});

  String _displayResolution() {
    if (!item.inCache || isMobilePlatform) return '';

    const supportedMimeTypes = [
      "image/jpeg",
      "image/gif",
      "image/png",
      "image/webp",
      "image/bmp",
      "image/jpg",
    ];
    if (!supportedMimeTypes.contains(item.fileMimeType?.toLowerCase())) {
      return '';
    }

    final size = getImageResolution(item.localPath!);
    if (size == null) return '';
    return " • ${size.width}x${size.height}";
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    final typeAndSize =
        "${displayFileType().toUpperCase()} • ${formatBytes(item.fileSize ?? 1024)}${_displayResolution()}";

    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned.fill(child: MediaPreview(item: item)),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ColoredBox(
              color: colors.surfaceContainerLow,
              child: Padding(
                padding: const EdgeInsets.all(padding8),
                child: Text(
                  typeAndSize,
                  style: textTheme.labelMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
