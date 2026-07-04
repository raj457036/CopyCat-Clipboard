import 'package:any_link_preview/any_link_preview.dart' as al;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/image_not_found.dart';
import 'package:clipboard/widgets/shimmer.dart' show Shimmer;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LinkPreviewItem extends StatelessWidget {
  const LinkPreviewItem({
    super.key,
    this.maxTitleLines = 1,
    this.maxDescLines = 1,
    this.bottom,
    this.onTap,
    this.meta,
    this.provider,
    this.svg,
  });

  final int maxTitleLines;
  final int maxDescLines;
  final Widget? bottom;
  final VoidCallback? onTap;
  final al.Metadata? meta;
  final ImageProvider<Object>? provider;
  final SvgPicture? svg;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final body = Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: padding2,
      children: [
        if (provider != null)
          Expanded(child: LinkPreviewImage(provider: provider!))
        else
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: padding44),
              child: ImageNotFound(),
            ),
          ),
        height4,
        if (meta?.title != null && meta!.title!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: padding8),
            child: Text(
              meta!.title!,
              overflow: TextOverflow.ellipsis,
              maxLines: maxTitleLines,
              style: context.textTheme.labelMedium,
            ),
          ),
        if (meta?.desc != null && meta!.desc!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: padding8),
            child: Text(
              meta!.desc!,
              overflow: TextOverflow.ellipsis,
              maxLines: maxDescLines,
              style: context.textTheme.bodySmall?.copyWith(
                color: colors.outline,
              ),
            ),
          ),
        if (bottom != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: padding8),
            child: bottom,
          ),
        height8,
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
    return Ink(color: colors.surface, child: body);
  }
}

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
          fit: BoxFit.contain,
          headers: networkImage.headers,
          placeholderBuilder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      }

      return CachedNetworkImage(
        imageUrl: networkImage.url,
        httpHeaders: networkImage.headers,
        fit: BoxFit.cover,
        errorWidget: (context, error, stackTrace) => const ImageNotFound(),
      );
    }

    return Image(
      image: provider,
      fit: BoxFit.cover,
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
  final bool flat;
  final Widget? bottom;

  const LinkPreview({
    super.key,
    required this.url,
    this.maxTitleLines = 2,
    this.maxDescLines = 4,
    this.withShadow = false,
    this.onTap,
    this.flat = false,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final isValidUrl = al.AnyLinkPreview.isValidLink(url);
    if (!isValidUrl) {
      return LinkPreviewItem(bottom: bottom, onTap: onTap);
    }

    return al.AnyLinkPreview.builder(
      link: url,
      placeholderWidget: const Shimmer(),
      errorWidget: LinkPreviewItem(bottom: bottom, onTap: onTap),
      cache: const Duration(days: 30),
      itemBuilder: (context, meta, provider, svg) => LinkPreviewItem(
        maxTitleLines: maxTitleLines,
        maxDescLines: maxDescLines,
        bottom: bottom,
        onTap: onTap,
        meta: meta,
        provider: provider,
        svg: svg,
      ),
    );
  }
}
