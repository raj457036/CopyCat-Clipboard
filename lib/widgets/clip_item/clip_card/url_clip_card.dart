import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/db/app_config/appconfig.dart';
import 'package:clipboard/base/db/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/widgets/link_preview.dart';
import 'package:clipboard/utils/common_extension.dart';
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
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: textTheme.bodyMedium,
    );
    final child = LayoutBuilder(builder: (context, constriants) {
      final hide = constriants.maxWidth < 150;
      if (hide) return text;
      final hideDesc = constriants.maxWidth < 100;
      return Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (item.url != null)
            LinkPreview(
              url: item.url!,
              expanded: true,
              hideDesc: hideDesc,
              maxTitleLines: 1,
              maxDescLines: 1,
            ),
          text,
        ],
      );
    });

    final padded = Padding(
      padding: const EdgeInsets.only(
        left: padding8,
        right: padding8,
        bottom: padding10,
      ),
      child: child,
    );
    return layout == AppLayout.grid ? SizedBox.expand(child: padded) : padded;
  }
}
