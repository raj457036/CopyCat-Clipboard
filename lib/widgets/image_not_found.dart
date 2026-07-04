import 'package:animate_do/animate_do.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';

class ImageNotFound extends StatelessWidget {
  const ImageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox.expand(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Ink(
            decoration: BoxDecoration(color: colors.surfaceContainerHigh),
            child: Padding(
              padding: const EdgeInsets.all(padding4),
              child: Column(
                spacing: 6,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported_rounded,
                    color: colors.outline,
                  ),
                  Text(
                    context.locale.app__image_not_found,
                    style: TextStyle(color: colors.outline),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
