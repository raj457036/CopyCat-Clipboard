import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:flutter/material.dart';

class MultiPasteDialog extends StatelessWidget {
  final List<ClipboardItem> items;

  const MultiPasteDialog({super.key, required this.items});

  Future<void> show(BuildContext context) async {
    await showDialog(context: context, builder: (context) => this);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
