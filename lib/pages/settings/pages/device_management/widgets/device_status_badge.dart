import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:flutter/material.dart';

enum DeviceStatusBadgeType { current, active, revoked }

class DeviceStatusBadge extends StatelessWidget {
  final DeviceStatusBadgeType status;

  const DeviceStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    late final Color dotColor;
    late final Color textColor;
    late final String label;

    switch (status) {
      case DeviceStatusBadgeType.current:
        dotColor = colorScheme.primary;
        textColor = colorScheme.primary;
        label = 'This device';
      case DeviceStatusBadgeType.active:
        dotColor = colorScheme.tertiary;
        textColor = colorScheme.tertiary;
        label = 'Active';
      case DeviceStatusBadgeType.revoked:
        dotColor = colorScheme.error;
        textColor = colorScheme.error;
        label = 'Revoked';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          child: const SizedBox(width: 8, height: 8),
        ),
        width6,
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
