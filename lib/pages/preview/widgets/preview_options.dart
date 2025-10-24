import 'package:clipboard/pages/preview/page.dart';
import 'package:clipboard/utils/clipboard_actions.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/db/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:flutter/material.dart';

class PreviewOptions extends StatelessWidget {
  final ClipboardItem item;
  final Axis direction;
  const PreviewOptions({
    super.key,
    required this.item,
    required this.direction,
  });

  Future<void> updateItem(BuildContext context) async {
    final state = ClipboardItemPreviewPage.of(context);
    final updatedItem = await editTextContent(context, item);
    if (updatedItem != null) {
      state.updateItem(updatedItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canOpen =
        (item.type == ClipItemType.file || item.type == ClipItemType.media) &&
            item.inCache;
    return Card(
      shape: const StadiumBorder(),
      child: Padding(
        padding: const EdgeInsets.all(padding8),
        child: Flex(
          mainAxisSize: MainAxisSize.min,
          direction: Axis.horizontal,
          spacing: 10,
          children: [
            if (item.needDownload)
              IconButton.outlined(
                onPressed: item.downloading
                    ? null
                    : () {
                        downloadFile(context, item);
                        Navigator.pop(context);
                      },
                tooltip: item.downloading
                    ? context.locale.app__downloading
                    : context.locale.app__download,
                icon: const Icon(Icons.download_for_offline_outlined),
              ),
            if (item.inCache)
              IconButton.filledTonal(
                onPressed: () => copyToClipboard(context, item),
                tooltip: context.mlocale.copyButtonLabel,
                icon: const Icon(Icons.copy),
              ),
            if (item.inCache)
              IconButton.outlined(
                icon: const Icon(Icons.ios_share),
                tooltip: context.mlocale.shareButtonLabel,
                onPressed: () => shareClipboardItem(context, item),
              ),
            if (item.type == ClipItemType.url)
              IconButton.outlined(
                icon: const Icon(Icons.open_in_new),
                tooltip: context.locale.app__follow_link,
                onPressed: () => launchUrl(item),
              ),
            if (item.text != null)
              IconButton.outlined(
                icon: const Icon(Icons.edit_document),
                tooltip: context.locale.app__edit,
                onPressed: () => updateItem(context),
              ),
            if (canOpen)
              IconButton.outlined(
                icon: const Icon(Icons.open_in_new),
                tooltip: context.locale.preview__card__file__open,
                onPressed: () => openFile(item),
              ),
            if (canOpen)
              IconButton.outlined(
                icon: const Icon(Icons.save_alt_rounded),
                tooltip: context.locale.app__export,
                onPressed: () => copyToClipboard(context, item, saveFile: true),
              ),
            IconButton.outlined(
              onPressed: () async {
                final done = await deleteClipboardItem(context, [item]);
                // ignore: use_build_context_synchronously
                if (done) Navigator.pop(context);
              },
              tooltip: context.locale.app__delete,
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
