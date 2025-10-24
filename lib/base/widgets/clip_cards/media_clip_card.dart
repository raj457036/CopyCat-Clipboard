import 'package:clipboard/base/constants/font_variations.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/constants/widgets.dart';
import 'package:clipboard/base/db/app_config/appconfig.dart';
import 'package:clipboard/base/db/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/utils/utility.dart';
import 'package:clipboard/base/widgets/clipcard_loading.dart';
import 'package:clipboard/utils/blur_hash.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import "package:universal_io/io.dart";

final mediaMimeRegex = RegExp("video|image|audio");

class MediaPreview extends StatelessWidget {
  final ClipboardItem item;
  const MediaPreview({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final isImage = item.fileMimeType!.startsWith("image");
    if (!isImage) {
      return placeholderImage;
    }

    if (item.localPath != null) {
      if (item.fileMimeType!.contains("svg")) {
        return SvgPicture.file(
          File(item.localPath!),
          width: 480,
        );
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
            return const Center(
              child: Text("Something went wrong"),
            );
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

class MediaClipCard extends StatelessWidget {
  final AppLayout layout;
  final ClipboardItem item;

  const MediaClipCard({
    super.key,
    required this.item,
    required this.layout,
  });

  Widget getIcon(BuildContext context) {
    final textTheme = context.textTheme;
    if (item.fileMimeType != null) {
      if (item.fileMimeType!.startsWith(mediaMimeRegex)) {
        final label = "${item.fileMimeType!} • ${formatBytes(item.fileSize!)}";
        return Chip(
          padding: EdgeInsets.zero,
          materialTapTargetSize: MaterialTapTargetSize.padded,
          label: Text(
            label,
            style: textTheme.labelSmall?.copyWith(fontVariations: fontVarW700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          side: BorderSide.none,
        );
      }
    }
    return const Icon(
      Icons.image,
      color: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isGrid = AppLayout.grid == layout;
    final preview = MediaPreview(item: item);
    final isNarrow = context.mq.size.height < 230;
    final child = SizedBox.expand(
      child: isGrid && !isNarrow
          ? Stack(
              children: [
                Positioned.fill(child: preview),
                Align(
                  alignment: const Alignment(0.0, 0.95),
                  child: getIcon(context),
                ),
              ],
            )
          : preview,
    );

    if (item.isSynced) {
      return ClipRRect(
        borderRadius: isGrid ? radiusBottom12 : radiusBottom8,
        child: child,
      );
    }
    return child;
  }
}
