import 'package:clipboard/pages/preview/view/clip_preview_config.dart';
import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/db/clipboard_item/clipboard_item.dart';
import 'package:copycat_base/l10n/l10n.dart';
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
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: padding16,
            right: padding16,
            top: padding16,
            bottom: padding38 * 2.5,
          ),
          child: SelectableText(
            item.url ?? context.locale.nothingHere,
          ),
        ),
      ),
    );
  }
}
