import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/l10n/l10n.dart';
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
          const Icon(Icons.lock),
          Text(context.locale.preview__inspector__status__encrypted),
        ],
      ),
    );
  }
}
