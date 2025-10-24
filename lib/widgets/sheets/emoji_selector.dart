import 'dart:math' show min;

import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';

class EmojiSelectorSheet extends StatefulWidget {
  const EmojiSelectorSheet({super.key});

  @override
  State<EmojiSelectorSheet> createState() => _EmojiSelectorSheetState();

  Future<Emoji?> open(BuildContext context) {
    final mqSize = context.mq.size;
    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      constraints: BoxConstraints(maxWidth: mqSize.width * 0.9),
      builder: (context) => this,
    );
  }
}

class _EmojiSelectorSheetState extends State<EmojiSelectorSheet> {
  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final mq = context.mq;
    final colors = context.colors;
    final keyboardHeight = mq.viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: SafeArea(
        child: EmojiPicker(
          onEmojiSelected: (Category? category, Emoji emoji) {
            Navigator.of(context).pop(emoji);
          },
          config: Config(
            height: min(mq.size.height * 0.5, 450),
            locale: Locale(locale.localeName),
            checkPlatformCompatibility: true,
            emojiViewConfig: EmojiViewConfig(
              backgroundColor: colors.surface,

              // Issue: https://github.com/flutter/flutter/issues/28894
              emojiSizeMax: 28 *
                  (foundation.defaultTargetPlatform == TargetPlatform.iOS
                      ? 1.20
                      : 1.0),
            ),
            viewOrderConfig: const ViewOrderConfig(
              top: EmojiPickerItem.categoryBar,
              middle: EmojiPickerItem.emojiView,
              bottom: EmojiPickerItem.searchBar,
            ),
            skinToneConfig: const SkinToneConfig(),
            categoryViewConfig: CategoryViewConfig(
              backgroundColor: colors.surface,
            ),
            bottomActionBarConfig: BottomActionBarConfig(
              backgroundColor: colors.surface,
              buttonColor: colors.surface,
              buttonIconColor: colors.onSurface,
            ),
            searchViewConfig: SearchViewConfig(
              backgroundColor: colors.surface,
              buttonIconColor: colors.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
