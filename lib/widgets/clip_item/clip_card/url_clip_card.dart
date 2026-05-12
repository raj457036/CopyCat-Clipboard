import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/link_preview.dart';
import 'package:flutter/material.dart';

class UrlClipCard extends StatelessWidget {
  final ClipboardItem item;

  const UrlClipCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final url = item.url ?? "https://example.com";

    final child = LayoutBuilder(
      builder: (context, constriants) {
        return Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: LinkPreview(url: url, maxTitleLines: 1, maxDescLines: 1),
            ),
            Text(
              url,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium,
            ),
          ],
        );
      },
    );

    return SizedBox.expand(
      child: Padding(padding: const EdgeInsets.all(padding8), child: child),
    );
  }
}
