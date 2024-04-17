import 'package:clipboard/constants/widget_styles.dart';
import 'package:clipboard/utils/color_extension.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';

class IssueCard extends StatelessWidget {
  final Color? color;
  final String description;

  const IssueCard({super.key, this.color, required this.description});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final textTheme = context.textTheme;
    return Card.filled(
      color: color?.lighter(50, isDark),
      margin: const EdgeInsets.symmetric(vertical: padding10),
      child: Padding(
        padding: const EdgeInsets.all(padding12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "⚠ Attention Needed!",
              style: textTheme.titleMedium,
            ),
            height12,
            Text(description),
          ],
        ),
      ),
    );
  }
}