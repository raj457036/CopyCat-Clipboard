import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';

class EncryptedClipItem extends StatelessWidget {
  final ClipboardItem item;
  const EncryptedClipItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    if (item.locked) {
      final colors = context.colors;
      return Column(
        spacing: 4,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          height32,
          Icon(
            Icons.fingerprint_rounded,
            color: colors.onPrimaryContainer,
            size: 38,
          ),
          Text(
            "••••••••",
            style: context.textTheme.labelLarge?.copyWith(
              color: colors.onPrimaryContainer,
            ),
          ),
          Text(
            context.locale.app_lock__screen__locked,
            style: context.textTheme.labelLarge?.copyWith(
              color: colors.onPrimaryContainer,
            ),
          ),
        ],
      );
    }
    return Center(
      child: Column(
        spacing: 4,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock),
          Text(
            context.locale.preview__inspector__status__encrypted,
            style: context.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
