import 'package:clipboard/base/constants/font_variations.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/clipboard_actions.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/clip_item/clip_meta_info.dart';
import 'package:clipboard/widgets/clip_item/clip_item_scope.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrimaryHoverAction extends StatelessWidget {
  final bool hovered;

  const PrimaryHoverAction({super.key, required this.hovered});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final item = ClipItemScope.of(context);

    if (!hovered) {
      final meta = ClipMetaInfo.of(context);
      if (meta == null || item.encrypted) return const SizedBox.shrink();
      return Card.filled(
        margin: const EdgeInsets.only(right: padding8),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: padding4),
          child: SizedBox(
            height: 20,
            child: Center(
              child: Text(
                keyboardShortcut(key: meta.index.toString()),
                textAlign: TextAlign.center,
                style: textTheme.labelSmall?.copyWith(
                  fontVariations: fontVarW600,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return SizedBox.square(
      dimension: 34,
      child: IconButton(
        onPressed: () => openClipPreview(context, item),
        iconSize: 20,
        style: IconButton.styleFrom(padding: EdgeInsets.zero),
        tooltip: context.locale.app__preview,
        icon: const Icon(Icons.edit_rounded),
      ),
    );
  }
}
