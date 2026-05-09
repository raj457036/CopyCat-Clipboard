import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/image_not_found.dart';
import 'package:clipboard/widgets/shimmer.dart' show Shimmer;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LinkPreviewImage extends StatelessWidget {
  final ImageProvider provider;
  const LinkPreviewImage({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    if (provider is NetworkImage) {
      final networkImage = provider as NetworkImage;
      final isSvg = networkImage.url.contains(".svg");

      if (networkImage.url.endsWith("giphy.gif?raw=true")) {
        return const ImageNotFound();
      }

      if (isSvg) {
        return SvgPicture.network(
          networkImage.url,
          fit: BoxFit.fitWidth,
          headers: networkImage.headers,
          placeholderBuilder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      }

      return CachedNetworkImage(
        imageUrl: networkImage.url,
        httpHeaders: networkImage.headers,
        fit: BoxFit.fitWidth,
        errorWidget: (context, error, stackTrace) => const ImageNotFound(),
      );
    }

    return Image(
      image: provider,
      fit: BoxFit.fitWidth,
      errorBuilder: (context, error, stackTrace) => const ImageNotFound(),
    );
  }
}

class LinkPreview extends StatelessWidget {
  final String url;

  final int maxTitleLines;
  final int maxDescLines;
  final bool withShadow;
  final VoidCallback? onTap;

  const LinkPreview({
    super.key,
    required this.url,
    this.maxTitleLines = 2,
    this.maxDescLines = 4,
    this.withShadow = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isValidUrl = AnyLinkPreview.isValidLink(url);
    if (!isValidUrl) {
      return const SizedBox.expand(child: ImageNotFound());
    }

    return Card.filled(
      elevation: withShadow ? 0.5 : 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: radius8,
        side: BorderSide.none,
      ),

      child: AnyLinkPreview.builder(
        link: url,
        placeholderWidget: const Shimmer(),
        errorWidget: const SizedBox.expand(child: ImageNotFound()),
        cache: const Duration(days: 30),
        itemBuilder: (context, meta, provider, svg) {
          if (meta.title == null && meta.desc == null && provider == null) {
            return const ImageNotFound();
          }

          final colors = context.colors;
          final body = Column(
            mainAxisSize: .max,
            crossAxisAlignment: .stretch,
            children: [
              if (provider != null)
                Expanded(child: LinkPreviewImage(provider: provider)),
              if (meta.title != null && meta.title!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(padding6),
                  child: Text(
                    meta.title!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: maxTitleLines,
                    style: context.textTheme.labelMedium,
                  ),
                ),
              if (meta.desc != null && meta.desc!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(padding6),
                  child: Text(
                    meta.desc!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: maxDescLines,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: colors.outline,
                    ),
                  ),
                ),
            ],
          );

          if (onTap != null) {
            return InkWell(
              mouseCursor: SystemMouseCursors.click,
              borderRadius: radius8,
              onTap: onTap,
              child: body,
            );
          }
          return body;
        },
      ),
    );
  }
}
