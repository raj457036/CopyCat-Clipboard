import 'package:animate_do/animate_do.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/base/constants/font_variations.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/widgets/image_not_found.dart';
import 'package:clipboard/utils/common_extension.dart';
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
          placeholderBuilder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
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
  final bool expanded;
  final bool hideDesc;
  final bool hideTitle;
  final int maxTitleLines;
  final int maxDescLines;
  final bool withProgress;
  final VoidCallback? onTap;

  const LinkPreview({
    super.key,
    required this.url,
    this.expanded = false,
    this.hideDesc = false,
    this.hideTitle = false,
    this.maxTitleLines = 2,
    this.maxDescLines = 4,
    this.withProgress = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isValidUrl = AnyLinkPreview.isValidLink(url);
    if (!isValidUrl) {
      return const SizedBox.shrink();
    }

    return AnyLinkPreview.builder(
        link: url,
        placeholderWidget: const SizedBox.shrink(),
        errorWidget: const SizedBox.shrink(),
        cache: const Duration(days: 30),
        itemBuilder: (context, meta, provider, svg) {
          if (withProgress && !meta.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (meta.title == null && meta.desc == null && provider == null) {
            return const SizedBox.shrink();
          }
          final colors = context.colors;

          Widget body = ClipRRect(
            borderRadius: radius8,
            child: Column(
              spacing: 4,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (provider != null)
                  Expanded(
                    child: LinkPreviewImage(provider: provider),
                  ),
                // else if (svg != null)
                //   Expanded(child: svg),
                if ((meta.title != null || meta.desc != null) &&
                    (!hideDesc || !hideTitle))
                  Padding(
                    padding: const EdgeInsets.only(
                      left: padding6,
                      right: padding6,
                      bottom: padding6,
                    ),
                    child: Column(
                      spacing: 4,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (meta.title != null &&
                            meta.title!.isNotEmpty &&
                            !hideTitle)
                          Flexible(
                            child: Text(
                              meta.title!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: maxTitleLines,
                              style: const TextStyle(
                                fontSize: 12,
                                fontVariations: fontVarW600,
                              ),
                            ),
                          ),
                        if (meta.desc != null &&
                            meta.desc!.isNotEmpty &&
                            !hideDesc)
                          Flexible(
                            child: Text(
                              meta.desc!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: maxDescLines,
                              style: TextStyle(
                                fontSize: 10,
                                color: colors.outline,
                              ),
                            ),
                          ),
                      ],
                    ),
                  )
              ],
            ),
          );

          if (onTap != null) {
            body = InkWell(borderRadius: radius8, onTap: onTap, child: body);
          }
          body = Card(
            elevation: 0.1,
            margin: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(
              borderRadius: radius8,
            ),
            child: body,
          );
          if (withProgress) {
            body = FadeIn(
              delay: const Duration(milliseconds: 150),
              child: body,
            );
          }
          if (expanded) body = Expanded(child: body);

          return body;
        });
  }
}
