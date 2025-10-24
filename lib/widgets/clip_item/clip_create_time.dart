import 'package:clipboard/base/constants/font_variations.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/datetime_extension.dart';
import 'package:flutter/material.dart';

class ClipCreateTime extends StatelessWidget {
  final DateTime created;
  final EdgeInsetsGeometry? padding;
  const ClipCreateTime({
    super.key,
    this.padding,
    required this.created,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;

    final createdFormatted = created.isToday()
        ? created.ago(context.locale.localeName)
        : getLocaleDateFormatter(context.locale.localeName)
            .format(created.toLocal());
    return Padding(
      padding: padding ?? const EdgeInsets.only(left: padding12),
      child: Text(
        createdFormatted,
        style: textTheme.labelMedium?.copyWith(
          fontVariations: fontVarW400,
          color: colors.outline,
        ),
        maxLines: 1,
        overflow: TextOverflow.clip,
      ),
    );
  }
}
