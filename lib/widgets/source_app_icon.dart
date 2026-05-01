import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/base/enums/platform_os.dart';
import 'package:clipboard/base/domain/services/application_meta_resolver.dart';
import 'package:clipboard/di/di.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';

class SourceAppIcon extends StatelessWidget {
  final String? sourceId;
  final PlatformOS? sourceOs;
  final double radius;
  final EdgeInsetsGeometry padding;

  const SourceAppIcon({
    super.key,
    required this.sourceId,
    this.sourceOs,
    this.radius = 10,
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
      future: resolver.getIconPathBySourceId(
        normalizedSourceId,
        sourceOs: sourceOs,
      ),
      builder: (context, snapshot) {
        final iconPath = snapshot.data;
        if (iconPath == null || iconPath.isEmpty) {
          return const SizedBox.shrink();
        }

        final isRemote = iconPath.startsWith('http');
        final ImageProvider image = isRemote
            ? CachedNetworkImageProvider(iconPath)
            : FileImage(File(iconPath));

        return Padding(
          padding: padding,
          child: Image(
            image: image,
            width: radius * 2,
            height: radius * 2,
            gaplessPlayback: true,
            semanticLabel: "Source application icon",
          ),
        );
      },
    );
  }
}
