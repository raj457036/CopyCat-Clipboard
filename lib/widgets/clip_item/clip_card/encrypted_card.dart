import 'package:clipboard/utils/clipboard_actions.dart';
import 'package:copycat_base/db/clipboard_item/clipboard_item.dart';
import 'package:flutter/material.dart';

class EncryptedClipItem extends StatelessWidget {
  final ClipboardItem item;
  const EncryptedClipItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      spacing: 4,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.security),
        const Text("Encrypted"),
        IconButton.filledTonal(
          onPressed: () => deleteClipboardItem(context, [item]),
          icon: const Icon(Icons.delete),
        ),
      ],
    ));
  }
}
