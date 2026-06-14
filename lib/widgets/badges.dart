import 'package:clipboard/base/constants/font_variations.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';

class TextBadge extends StatelessWidget {
  final String message;
  const TextBadge({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: context.locale.badges__tooltip__experimental,
      child: Chip(label: Text(message), shape: const StadiumBorder()),
    );
  }
}

class InfoBadge extends StatelessWidget {
  final String message;
  const InfoBadge({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      child: const Icon(Icons.info_outline_rounded, size: 16),
    );
  }
}

class ProBadge extends StatelessWidget {
  final bool noTooltip;
  final Widget child;
  const ProBadge({super.key, this.noTooltip = false, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    final chip = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        width4,
        Badge(
          label: Text(context.locale.badges__label__pro),
          padding: const EdgeInsets.symmetric(horizontal: padding10),
          backgroundColor: colors.primary,
          alignment: Alignment.centerLeft,
          offset: const Offset(105, -8),
          textStyle: textTheme.labelMedium?.copyWith(
            color: colors.onPrimaryContainer,
            fontVariations: fontVarW600,
          ),
          // labelPadding: const EdgeInsets.fromLTRB(2, -6, 2, -6),
        ),
      ],
    );

    if (noTooltip) return chip;
    return Tooltip(
      message: context.locale.badges__tooltip__pro_only,
      child: chip,
    );
  }
}
