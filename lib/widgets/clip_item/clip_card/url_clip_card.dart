import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/db/app_config/appconfig.dart';
import 'package:copycat_base/db/clipboard_item/clipboard_item.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:copycat_base/widgets/link_preview.dart';
import 'package:flutter/material.dart';

class UrlClipCard extends StatelessWidget {
  final AppLayout layout;
  final ClipboardItem item;

  const UrlClipCard({
    super.key,
    required this.item,
    required this.layout,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final text = Text(
      item.url ?? "https://example.com",
      maxLines: 4,
      overflow: TextOverflow.fade,
      style: textTheme.bodySmall,
    );
    final child = LayoutBuilder(builder: (context, constriants) {
      final hide = constriants.maxWidth < 150;
      if (hide) return text;
      return Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (item.url != null) LinkPreview(url: item.url!, expanded: true),
          text,
        ],
      );
    });

    final padded = Padding(
      padding: const EdgeInsets.only(
        left: padding10,
        right: padding10,
        bottom: padding10,
      ),
      child: child,
    );
    return layout == AppLayout.grid ? SizedBox.expand(child: padded) : padded;
  }
}
