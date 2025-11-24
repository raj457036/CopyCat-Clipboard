import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/db/app_config/appconfig.dart';
import 'package:clipboard/base/db/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/menu.dart';
import 'package:flutter/material.dart';

class PrimaryClipActionButton extends StatelessWidget {
  final bool hasFocusForPaste;
  final ClipboardItem item;
  final AppLayout layout;
  const PrimaryClipActionButton({
    super.key,
    this.hasFocusForPaste = false,
    required this.item,
    required this.layout,
  });

  @override
  Widget build(BuildContext context) {
    final isGrid = layout == AppLayout.grid;
    final colors = context.colors;

    if (item.encrypted) {
      return const SizedBox.shrink();
    }

    if (item.needDownload) {
      return Tooltip(
        message: item.downloading
            ? context.locale.app__downloading
            : context.locale.app__download,
        child: Padding(
          padding: isGrid
              ? const EdgeInsets.all(padding8)
              : const EdgeInsets.all(padding4),
          child: item.downloading
              ? SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(
                    value: item.downloadProgress,
                    strokeWidth: 2,
                  ),
                )
              : Icon(
                  Icons.download_for_offline_outlined,
                  color: colors.onSurfaceVariant,
                  size: 24,
                ),
        ),
      );
    }

    if (isMobilePlatform) {
      return SizedBox.square(
        dimension: 36,
        child: IconButton(
          onPressed: () {
            final menu = Menu.of(context);
            menu.openOptionBottomSheet(context);
          },
          iconSize: 22,
          icon: CircleAvatar(
            radius: 12,
            backgroundColor: colors.primary.withAlpha(40),
            child: const Icon(Icons.more_horiz_rounded),
          ),
          style: IconButton.styleFrom(
            padding: EdgeInsets.zero,
          ),
          padding: EdgeInsets.zero,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
