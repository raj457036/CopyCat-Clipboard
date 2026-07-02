import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/widgets/image_not_found.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MediaSVGImagePreview extends StatelessWidget {
  final ClipboardItem item;
  final ShapeBorder? shape;
  final SvgPicture? preview;

  const MediaSVGImagePreview({
    super.key,
    required this.item,
    required this.shape,
    required this.preview,
  });

  @override
  Widget build(BuildContext context) {
    if (preview == null) return const ImageNotFound();
    return Card.filled(
      margin: EdgeInsets.zero,
      shape: shape,
      clipBehavior: Clip.hardEdge,
      child: InteractiveViewer(
        minScale: 1,
        maxScale: 5,
        panEnabled: true,
        scaleEnabled: true,
        child: Center(child: preview!),
      ),
    );
  }
}
