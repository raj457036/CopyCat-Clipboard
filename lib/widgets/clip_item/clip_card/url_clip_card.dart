import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/link_preview/link_preview.dart';
import 'package:flutter/material.dart';

class UrlClipCard extends StatelessWidget {
  final ClipboardItem item;

  const UrlClipCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final url = item.url ?? "-";

    return LinkPreview(
      item: item,
      maxTitleLines: 1,
      maxDescLines: 1,
      flat: true,
      bottom: Text(
        url,
        overflow: TextOverflow.ellipsis,
        style: textTheme.bodySmall?.copyWith(
          color: context.colors.onSurface.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
