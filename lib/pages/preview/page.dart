import 'package:clipboard/pages/preview/view/horizontal.dart';
import 'package:clipboard/pages/preview/view/vertical.dart';
import 'package:clipboard/base/db/clipboard_item/clipboard_item.dart';
import 'package:flutter/material.dart';

class ClipboardItemPreviewPage extends StatefulWidget {
  final ClipboardItem item;
  const ClipboardItemPreviewPage({
    super.key,
    required this.item,
  });

  @override
  State<ClipboardItemPreviewPage> createState() => ClipboardItemPreviewState();

  static ClipboardItemPreviewState of(BuildContext context) {
    return context.findAncestorStateOfType<ClipboardItemPreviewState>()!;
  }
}

class ClipboardItemPreviewState extends State<ClipboardItemPreviewPage> {
  late ClipboardItem item;

  @override
  void initState() {
    item = widget.item;
    super.initState();
  }

  void updateItem(ClipboardItem newItem) {
    setState(() {
      item = newItem;
    });
  }

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
