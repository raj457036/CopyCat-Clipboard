import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:flutter/material.dart';

class MediaAudioPreview extends StatelessWidget {
  final ClipboardItem item;
  final ShapeBorder? shape;

  const MediaAudioPreview({super.key, required this.item, required this.shape});

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      margin: EdgeInsets.zero,
      shape: shape,
      child: const DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
        ),
        child: Align(
          alignment: Alignment(-.98, -.98),
          child: Icon(Icons.audiotrack, color: Colors.white),
        ),
      ),
    );
  }
}
