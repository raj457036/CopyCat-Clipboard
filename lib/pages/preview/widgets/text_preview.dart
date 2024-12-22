import 'package:clipboard/pages/preview/view/clip_preview_config.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/db/clipboard_item/clipboard_item.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:flutter/material.dart';

class TextClipPreviewCard extends StatelessWidget {
  final ClipboardItem item;
  const TextClipPreviewCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    Color? fg;
    final bg = hexToColor(item);
    if (bg != null) {
      fg = getFg(bg);
    }

    final config = ClipPreviewConfig.of(context);

    return Card.filled(
      color: bg,
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
            item.text ?? context.locale.nothingHere,
            style: TextStyle(color: fg),
          ),
        ),
      ),
    );
  }
}
