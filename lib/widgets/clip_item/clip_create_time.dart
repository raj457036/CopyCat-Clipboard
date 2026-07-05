import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/datetime_extension.dart';
import 'package:flutter/material.dart';

class ClipCreateTime extends StatelessWidget {
  final DateTime created;
  final String contentType;
  const ClipCreateTime({
    super.key,
    required this.created,
    required this.contentType,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final createdFormatted = created.isToday()
        ? created.ago(context.locale.localeName)
        : getLocaleDateFormatter(
            context.locale.localeName,
          ).format(created.toLocal());
    return Text(
      "$createdFormatted • $contentType",
      maxLines: 1,
      overflow: TextOverflow.clip,
      style: textTheme.labelSmall?.copyWith(
        color: context.colors.onSurfaceVariant.withValues(alpha: 0.7),
      ),
    );
  }
}
