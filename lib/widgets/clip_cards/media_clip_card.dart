import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/constants/widgets.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/blur_hash.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/clip_cards/file_display_name_mixin.dart';
import 'package:clipboard/widgets/clipcard_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import "package:universal_io/io.dart";

final mediaMimeRegex = RegExp("video|image|audio");

class MediaPreview extends StatelessWidget {
  final ClipboardItem item;
  const MediaPreview({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isImage = item.fileMimeType!.startsWith("image");
    if (!isImage) {
      return placeholderImage;
    }

    if (item.localPath != null) {
      if (item.fileMimeType!.contains("svg")) {
        return SvgPicture.file(File(item.localPath!), width: 360);
      }
      return Image(
        image: ResizeImage(
          FileImage(File(item.localPath!)),
          width: 480,
          policy: ResizeImagePolicy.fit,
        ),
        gaplessPlayback: true,
        fit: BoxFit.cover,
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
