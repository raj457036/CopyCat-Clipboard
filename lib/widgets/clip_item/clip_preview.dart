import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart' show isMediaType;
import 'package:clipboard/widgets/clip_cards/file_clip_card.dart';
import 'package:clipboard/widgets/clip_cards/media_clip_card.dart';
import 'package:clipboard/widgets/clip_item/clip_card/encrypted_card.dart';
import 'package:clipboard/widgets/clip_item/clip_card/text_clip_card.dart';
import 'package:clipboard/widgets/clip_item/clip_card/url_clip_card.dart';
import 'package:flutter/material.dart';

class ClipPreview extends StatelessWidget {
  final ClipboardItem item;
  const ClipPreview({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    if (item.encrypted) {
      return EncryptedClipItem(item: item);
    }

    if (item.type == ClipItemType.text) {
      return TextClipCard(item: item);
    }
    if (item.type == ClipItemType.media || isMediaType(item)) {
      return MediaClipCard(item: item);
    }
    if (item.type == ClipItemType.url) {
      return UrlClipCard(item: item);
    }
    if (item.type == ClipItemType.file) {
      return FileClipCard(item: item);
    }
    return const SizedBox.shrink();
  }
}
