import 'package:clipboard/base/constants/font_variations.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';

class ProBadge extends StatelessWidget {
  final Widget child;
  const ProBadge({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: padding4,
      children: [
        child,
        Tooltip(
          message: context.locale.badges__tooltip__pro_only,
          child: Badge(
            label: Text(context.locale.badges__label__pro),
            padding: const EdgeInsets.symmetric(horizontal: padding10),
            backgroundColor: colors.primary,
            alignment: Alignment.centerLeft,
            offset: const Offset(105, -8),
            textColor: context.colors.onPrimary,
            // labelPadding: const EdgeInsets.fromLTRB(2, -6, 2, -6),
          ),
        ),
      ],
    );
  }
}
