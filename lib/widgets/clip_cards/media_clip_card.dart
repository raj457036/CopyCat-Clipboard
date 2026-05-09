import 'package:clipboard/base/constants/widgets.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/blur_hash.dart';
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
        return SvgPicture.file(File(item.localPath!), width: 480);
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

class MediaClipCard extends StatelessWidget {
  final ClipboardItem item;

  const MediaClipCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(child: MediaPreview(item: item));
  }
}
