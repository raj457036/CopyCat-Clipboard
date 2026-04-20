import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/utils/clipboard_actions.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/can_paste_builder.dart';
import 'package:clipboard/widgets/multi_paste/multi_paste_dialog.dart';
import 'package:flutter/material.dart';

class MultiPasteButton extends StatelessWidget {
  final VoidCallback? onPasteComplete;
  final List<ClipboardItem> items;

  const MultiPasteButton({
    super.key,
    this.onPasteComplete,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return CanPasteBuilder(
      builder: (context, canPaste) {
        if (!canPaste) return const SizedBox.shrink();
        return IconButton(
          onPressed: () async {
            final options = await MultiPasteDialog(items: items).show(context);
            if (options == null || !context.mounted) return;

            await pasteMultipleOnLastWindow(
              context,
              items,
              textMergeSeparator: options.textMergeSeparator,
              waitBetweenPastes: options.waitBetweenPastes,
            );
            onPasteComplete?.call();
          },
          tooltip:
              'Paste Multiple • ${keyboardShortcut(meta: false, shift: true, key: "Enter")}',
          icon: const Icon(Icons.content_paste_go_outlined),
        );
      },
    );
  }
}
