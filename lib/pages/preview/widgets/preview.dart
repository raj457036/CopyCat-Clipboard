import 'package:clipboard/pages/preview/widgets/file_preview.dart';
import 'package:clipboard/pages/preview/widgets/media_preview.dart';
import 'package:clipboard/pages/preview/widgets/text_preview.dart';
import 'package:clipboard/pages/preview/widgets/url_preview.dart';
import 'package:clipboard/utils/utility.dart' show isMediaType;
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/widgets/clip_item/clip_card/encrypted_card.dart';
import 'package:flutter/material.dart';

class ClipPreview extends StatelessWidget {
  final ClipboardItem item;

  const ClipPreview({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    if (item.encrypted) return EncryptedClipItem(item: item);

    if (item.type == ClipItemType.text) {
      return TextClipPreviewCard(item: item);
    }
    if (item.type == ClipItemType.media || isMediaType(item)) {
      return MediaClipPreviewCard(item: item);
    }
    if (item.type == ClipItemType.url) {
      return URLClipPreviewCard(item: item);
    }
    if (item.type == ClipItemType.file) {
      return FileClipPreviewCard(item: item);
    }
    return const SizedBox.shrink();
  }
}
