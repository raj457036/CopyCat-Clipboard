import 'package:clipboard/base/domain/services/application_meta_resolver.dart';
import 'package:clipboard/di/di.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';

class SourceAppIcon extends StatelessWidget {
  final String? sourceId;
  final double radius;
  final double trailingSpacing;
  final EdgeInsetsGeometry padding;

  const SourceAppIcon({
    super.key,
    required this.sourceId,
    this.radius = 9,
    this.trailingSpacing = 0,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final normalizedSourceId = sourceId?.trim() ?? '';
    if (normalizedSourceId.isEmpty) {
      return const SizedBox.shrink();
    }

    final resolver = sl<ApplicationMetaResolver>();
    return FutureBuilder<String?>(
      future: resolver.getIconPathBySourceId(normalizedSourceId),
      builder: (context, snapshot) {
        final iconPath = snapshot.data;
        if (iconPath == null || iconPath.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: radius,
                backgroundColor: Colors.transparent,
                foregroundImage: FileImage(File(iconPath)),
              ),
              if (trailingSpacing > 0) SizedBox(width: trailingSpacing),
            ],
          ),
        );
      },
    );
  }
}
