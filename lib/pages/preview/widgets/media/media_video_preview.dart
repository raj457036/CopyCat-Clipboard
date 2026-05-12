import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:flutter/material.dart';

class MediaVideoPreview extends StatelessWidget {
  final ClipboardItem item;
  final ShapeBorder? shape;
  final ImageProvider? preview;
  final VoidCallback onOpen;

  const MediaVideoPreview({
    super.key,
    required this.item,
    required this.shape,
    required this.preview,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      margin: EdgeInsets.zero,
      shape: shape,
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: preview != null
              ? DecorationImage(image: preview!, fit: BoxFit.contain)
              : null,
          borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(12),
          ),
        ),
        child: item.inCache
            ? Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow_rounded),
                  onPressed: onOpen,
                  label: Text(context.locale.preview__card__video__play),
                ),
              )
            : const Align(
                alignment: Alignment(-.98, -.98),
                child: Icon(Icons.video_file, color: Colors.white),
              ),
      ),
    );
  }
}
