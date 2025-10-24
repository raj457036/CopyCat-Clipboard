import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';

class DropArea extends StatelessWidget {
  final bool processing;
  const DropArea({
    super.key,
    this.processing = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;
    return ColoredBox(
      color: colors.secondaryContainer.withAlpha(217),
      child: processing
          ? const CircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.all(padding12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.blur_on_rounded,
                    size: 95,
                    color: colors.onSecondaryContainer,
                  ),
                  height16,
                  Text(
                    context.locale.dnd__text__drop_here,
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.onSecondaryContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
    );
  }
}
