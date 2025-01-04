import 'package:clipboard/pages/preview/view/clip_preview_config.dart';
import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/db/clipboard_item/clipboard_item.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:copycat_base/widgets/link_preview.dart';
import 'package:flutter/material.dart';

class URLClipPreviewCard extends StatelessWidget {
  final ClipboardItem item;
  const URLClipPreviewCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final config = ClipPreviewConfig.of(context);

    return Card.filled(
      margin: EdgeInsets.zero,
      shape: config?.shape,
      child: Padding(
        padding: const EdgeInsets.all(padding8),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 12,
          children: [
            SizedBox.fromSize(
              size: const Size(280, 240),
              child: LinkPreview(url: item.url!, withProgress: true),
            ),
            SelectableText(
              item.url ?? context.locale.nothingHere,
            )
          ],
        ),
      ),
    );
  }
}
