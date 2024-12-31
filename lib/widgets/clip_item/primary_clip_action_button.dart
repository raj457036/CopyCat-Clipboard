import 'package:clipboard/widgets/menu.dart';
import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/db/app_config/appconfig.dart';
import 'package:copycat_base/db/clipboard_item/clipboard_item.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:copycat_base/utils/utility.dart';
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
            ? context.locale.downloading
            : context.locale.downloadForOffline,
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
          iconSize: 24,
          icon: const Icon(Icons.more_vert_rounded),
          style: IconButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
              ),
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
