import 'package:clipboard/pages/preview/widgets/file_preview.dart';
import 'package:clipboard/pages/preview/widgets/media_preview.dart';
import 'package:clipboard/pages/preview/widgets/text_preview.dart';
import 'package:clipboard/pages/preview/widgets/url_preview.dart';
import 'package:copycat_base/db/clipboard_item/clipboard_item.dart';
import 'package:copycat_base/enums/clip_type.dart';
import 'package:flutter/material.dart';

class ClipPreview extends StatelessWidget {
  final ClipboardItem item;

  const ClipPreview({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    switch (item.type) {
      case ClipItemType.text:
        return TextClipPreviewCard(item: item);
      case ClipItemType.media:
        return MediaClipPreviewCard(item: item);
      case ClipItemType.url:
        return URLClipPreviewCard(item: item);
      case ClipItemType.file:
        return FileClipPreviewCard(item: item);
    }
  }
}
