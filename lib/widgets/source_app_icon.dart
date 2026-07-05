import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/enums/platform_os.dart';
import 'package:clipboard/base/domain/services/application_meta_resolver.dart';
import 'package:clipboard/di/di.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';

class SourceAppIcon extends StatelessWidget {
  final String? sourceId;
  final PlatformOS? sourceOs;
  final double? width;
  final double? height;

  const SourceAppIcon({
    super.key,
    required this.sourceId,
    this.sourceOs,
    this.width,
    this.height,
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

        final imgWidget = Image(
          image: image,
          gaplessPlayback: true,
          fit: BoxFit.cover,
          semanticLabel: "Source application icon",
        );
        if (sourceOs == PlatformOS.android) {
          return SizedBox(
            width: width,
            height: height,
            child: Padding(
              padding: const EdgeInsets.all(padding4),
              child: ClipRRect(borderRadius: radius8, child: imgWidget),
            ),
          );
        }
        return SizedBox(width: width, height: height, child: imgWidget);
      },
    );
  }
}
