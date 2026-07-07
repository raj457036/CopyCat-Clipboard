import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/base/bloc/offline_persistance_cubit/offline_persistance_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/image_not_found.dart';
import 'package:clipboard/widgets/link_preview/fetcher.dart';
import 'package:clipboard/widgets/link_preview/type.dart';
import 'package:clipboard/widgets/shimmer.dart' show Shimmer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class _LinkPreviewItem extends StatelessWidget {
  const _LinkPreviewItem({
    this.maxTitleLines = 1,
    this.maxDescLines = 1,
    this.bottom,
    this.onTap,
    this.title,
    this.description,
    this.provider,
    required this.imageBoxFit,
  });

  final BoxFit imageBoxFit;
  final int maxTitleLines;
  final int maxDescLines;
  final Widget? bottom;
  final VoidCallback? onTap;
  final String? title;
  final String? description;
  final ImageProvider<Object>? provider;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final body = Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: padding2,
      children: [
        if (provider != null)
          Expanded(
            child: _LinkPreviewImage(
              provider: provider!,
              imageBoxFit: imageBoxFit,
            ),
          )
        else
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: padding44),
              child: ImageNotFound(),
            ),
          ),
        height4,
        if (title != null && title!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: padding8),
            child: Text(
              title!,
              overflow: TextOverflow.ellipsis,
              maxLines: maxTitleLines,
              style: context.textTheme.labelMedium,
            ),
          ),
        if (description != null && description!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: padding8),
            child: Text(
              description!,
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

class _LinkPreviewImage extends StatelessWidget {
  final BoxFit imageBoxFit;
  final ImageProvider<Object> provider;
  const _LinkPreviewImage({required this.provider, required this.imageBoxFit});

  @override
  Widget build(BuildContext context) {
    if (provider case final NetworkImage networkImage) {
      return _buildNetwork(networkImage);
    }

    return _buildGeneric();
  }

  Widget _buildNetwork(NetworkImage networkImage) {
    final url = networkImage.url;

    if (url.endsWith('giphy.gif?raw=true')) {
      return const ImageNotFound();
    }

    if (url.contains('.svg')) {
      return SvgPicture.network(
        url,
        fit: BoxFit.contain,
        headers: networkImage.headers,
        placeholderBuilder: (context) =>
            const Center(child: CircularProgressIndicator()),
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      errorWidget: (context, error, stackTrace) => const ImageNotFound(),
    );
  }

  Widget _buildGeneric() {
    return Image(
      image: provider,
      fit: imageBoxFit,
      errorBuilder: (context, error, stackTrace) => const ImageNotFound(),
    );
  }
}

class LinkPreview extends StatefulWidget {
  final ClipboardItem item;

  final int maxTitleLines;
  final int maxDescLines;
  final VoidCallback? onTap;
  final Widget? bottom;
  final BoxFit? imageBoxFit;

  const LinkPreview({
    super.key,
    required this.item,
    this.maxTitleLines = 2,
    this.maxDescLines = 4,
    this.onTap,
    this.bottom,
    this.imageBoxFit,
  });

  @override
  State<LinkPreview> createState() => _LinkPreviewState();
}

class _LinkPreviewState extends State<LinkPreview> {
  LinkPreviewData? _preview;
  bool _isLoading = false;

  String get _url => widget.item.url?.trim() ?? '';

  @override
  void initState() {
    super.initState();
    _hydrateFromItem();
    _fetchPreviewIfNeeded();
  }

  @override
  void didUpdateWidget(covariant LinkPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldUrl = oldWidget.item.url?.trim() ?? '';
    final newUrl = widget.item.url?.trim() ?? '';

    if (oldUrl != newUrl) {
      _hydrateFromItem();
      _fetchPreviewIfNeeded();
      return;
    }

    final previewChanged =
        oldWidget.item.linkPreviewTitle != widget.item.linkPreviewTitle ||
        oldWidget.item.linkPreviewDescription !=
            widget.item.linkPreviewDescription ||
        oldWidget.item.linkPreviewImageUrl != widget.item.linkPreviewImageUrl;
    if (previewChanged) {
      _hydrateFromItem();
    }
  }

  void _hydrateFromItem() {
    _preview = _previewFromItem(widget.item);
    _isLoading = false;
  }

  void _fetchPreviewIfNeeded() {
    if (_preview == null) {
      _fetchPreview();
    }
  }

  Future<void> _fetchPreview() async {
    if (_url.isEmpty || !_isValidUrl(_url)) {
      debugPrint('Invalid URL for link preview: $_url');
      return;
    }

    setState(() {
      _preview = null;
      _isLoading = true;
    });

    debugPrint('Fetching link preview for: $_url');

    final data = await getLinkPreviewData(_url);

    debugPrint('Fetched link preview for: $_url, data: $data');

    if (!mounted) return;

    if (data != null) {
      await context.read<OfflinePersistenceCubit>().persistLocalLinkPreview(
        widget.item,
        title: data.title,
        description: data.description,
        imageUrl: data.image?.imageUrl,
      );
    }

    setState(() {
      _preview = data;
      _isLoading = false;
    });
  }

  LinkPreviewData? _previewFromItem(ClipboardItem item) {
    if (item.linkPreviewTitle == null &&
        item.linkPreviewDescription == null &&
        item.linkPreviewImageUrl == null) {
      return null;
    }

    return LinkPreviewData(
      link: item.url ?? '',
      title: item.linkPreviewTitle,
      description: item.linkPreviewDescription,
      image: item.linkPreviewImageUrl != null
          ? LinkImagePreviewData(
              imageUrl: item.linkPreviewImageUrl!,
              imageSize: Size
                  .zero, // You can replace this with actual size if available
            )
          : null,
    );
  }

  bool _isValidUrl(String url) {
    if (url.isEmpty) {
      return false;
    }

    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Shimmer();
    }

    if (_preview == null) {
      return _LinkPreviewItem(
        bottom: widget.bottom,
        onTap: widget.onTap,
        imageBoxFit: widget.imageBoxFit ?? BoxFit.cover,
      );
    }

    return _LinkPreviewItem(
      maxTitleLines: widget.maxTitleLines,
      maxDescLines: widget.maxDescLines,
      bottom: widget.bottom,
      onTap: widget.onTap,
      title: _preview?.title,
      description: _preview?.description,
      provider: _preview?.image == null
          ? null
          : CachedNetworkImageProvider(_preview!.image!.imageUrl),
      imageBoxFit: widget.imageBoxFit ?? BoxFit.cover,
    );
  }
}
