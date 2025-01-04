import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:flutter/material.dart';

class SheetHandle extends StatelessWidget {
  const SheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: padding12),
      child: SizedBox.fromSize(
        size: const Size(32, 4),
        child: Material(
          color: colors.onSurfaceVariant,
          borderRadius: radius12,
        ),
      ),
    );
  }
}
