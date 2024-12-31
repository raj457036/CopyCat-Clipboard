import 'package:clipboard/utils/clipboard_actions.dart';
import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/db/clipboard_item/clipboard_item.dart';
import 'package:copycat_base/enums/clip_type.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:flutter/material.dart';

class PreviewOptions extends StatelessWidget {
  final ClipboardItem item;
  final Axis direction;
  const PreviewOptions({
    super.key,
    required this.item,
    required this.direction,
  });

  @override
  Widget build(BuildContext context) {
    final canOpen =
        (item.type == ClipItemType.file || item.type == ClipItemType.media) &&
            item.inCache;
    return Card(
      shape: StadiumBorder(),
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
                    ? context.locale.downloading
                    : context.locale.downloadForOffline,
                icon: const Icon(Icons.download_for_offline_outlined),
              ),
            if (item.inCache)
              IconButton.filledTonal(
                onPressed: () => copyToClipboard(context, item),
                tooltip: context.locale.copyToClipboard,
                icon: const Icon(Icons.copy),
              ),
            if (item.inCache)
              IconButton.outlined(
                icon: const Icon(Icons.ios_share),
                tooltip: context.locale.share,
                onPressed: () => shareClipboardItem(context, item),
              ),
            if (item.type == ClipItemType.url)
              IconButton.outlined(
                icon: const Icon(Icons.open_in_new),
                tooltip: context.locale.openInBrowser,
                onPressed: () => launchUrl(item),
              ),
            if (item.text != null)
              IconButton.outlined(
                icon: const Icon(Icons.edit_document),
                tooltip: context.locale.edit,
                onPressed: () => editTextContent(context, item),
              ),
            if (canOpen)
              IconButton.outlined(
                icon: const Icon(Icons.open_in_new),
                tooltip: context.locale.open,
                onPressed: () => openFile(item),
              ),
            if (canOpen)
              IconButton.outlined(
                icon: const Icon(Icons.save_alt_rounded),
                tooltip: context.locale.export,
                onPressed: () => copyToClipboard(context, item, saveFile: true),
              ),
            IconButton.outlined(
              onPressed: () async {
                final done = await deleteClipboardItem(context, [item]);
                // ignore: use_build_context_synchronously
                if (done) Navigator.pop(context);
              },
              tooltip: context.locale.delete,
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
