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
      child: Chip(
        label: Text(message),
        shape: const StadiumBorder(),
      ),
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
      child: const Icon(
        Icons.info_outline_rounded,
        size: 16,
      ),
    );
  }
}

class ProBadge extends StatelessWidget {
  final bool noTooltip;
  const ProBadge({super.key, this.noTooltip = false});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;
    final chip = Chip(
      shape: const RoundedRectangleBorder(
        borderRadius: radius12,
        side: BorderSide(color: Colors.transparent),
      ),
      label: const Text("PRO"),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(horizontal: padding10),
      backgroundColor: colors.primaryContainer,
      labelStyle: textTheme.labelMedium?.copyWith(
        color: colors.onPrimaryContainer,
        fontVariations: fontVarW600,
      ),
      labelPadding: const EdgeInsets.fromLTRB(2, -6, 2, -6),
    );

    if (noTooltip) return chip;
    return Tooltip(
      message: context.locale.badges__tooltip__pro_only,
      child: chip,
    );
  }
}
