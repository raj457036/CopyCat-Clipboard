import 'package:clipboard/pages/preview/view/horizontal.dart';
import 'package:clipboard/pages/preview/view/vertical.dart';
import 'package:copycat_base/db/clipboard_item/clipboard_item.dart';
import 'package:flutter/material.dart';

class ClipboardItemPreviewPage extends StatelessWidget {
  final ClipboardItem item;
  const ClipboardItemPreviewPage({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return constraints.maxWidth > 600
            ? ClipItemPreviewHorizontalView(item: item)
            : ClipItemPreviewVerticalView(item: item);
      },
    );
  }
}
