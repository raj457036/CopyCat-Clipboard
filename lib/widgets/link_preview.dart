import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/base/bloc/offline_persistance_cubit/offline_persistance_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/image_not_found.dart';
import 'package:clipboard/widgets/shimmer.dart' show Shimmer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart' as flp;
import 'package:flutter_svg/flutter_svg.dart';

class _PreviewContent {
  const _PreviewContent({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  static _PreviewContent? fromValues({
    required String? title,
    required String? description,
    required String? imageUrl,
  }) {
    if ((title == null || title.isEmpty) &&
        (description == null || description.isEmpty) &&
        (imageUrl == null || imageUrl.isEmpty)) {
      return null;
    }

    return _PreviewContent(
      title: title,
      description: description,
      imageUrl: imageUrl,
    );
  }

  final String? title;
  final String? description;
  final String? imageUrl;
}

class LinkPreviewItem extends StatelessWidget {
  const LinkPreviewItem({
    super.key,
    this.maxTitleLines = 1,
    this.maxDescLines = 1,
    this.bottom,
    this.onTap,
    this.title,
    this.description,
    this.provider,
  });

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
          Expanded(child: LinkPreviewImage(provider: provider!))
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

class LinkPreviewImage extends StatelessWidget {
  final ImageProvider<Object> provider;
  const LinkPreviewImage({super.key, required this.provider});

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
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => const ImageNotFound(),
    );
  }
}

class LinkPreview extends StatefulWidget {
  final ClipboardItem item;

  final int maxTitleLines;
  final int maxDescLines;
  final bool withShadow;
  final VoidCallback? onTap;
  final bool flat;
  final Widget? bottom;

  const LinkPreview({
    super.key,
    required this.item,
    this.maxTitleLines = 2,
    this.maxDescLines = 4,
    this.withShadow = false,
    this.onTap,
    this.flat = false,
    this.bottom,
  });

  @override
  State<LinkPreview> createState() => _LinkPreviewState();
}

class _LinkPreviewState extends State<LinkPreview> {
  _PreviewContent? _preview;
  bool _isLoading = false;
  String? _requestedUrl;

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
    if (oldWidget.item != widget.item) {
      _hydrateFromItem();
      _fetchPreviewIfNeeded();
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

  bool _isValidUrl(String value) {
    return RegExp(
      flp.regexLink,
      caseSensitive: false,
      unicode: true,
    ).hasMatch(value.trim());
  }

  Future<void> _fetchPreview() async {
    final url = _url;
    _requestedUrl = url;

    if (!_isValidUrl(url)) {
      setState(() {
        _preview = null;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _preview = null;
      _isLoading = true;
    });

    final data = await flp.getLinkPreviewData(url);

    if (!mounted || _requestedUrl != url) {
      return;
    }

    final preview = _previewFromLinkData(data);

    if (preview != null) {
      await context.read<OfflinePersistenceCubit>().persistLocalLinkPreview(
        widget.item,
        title: preview.title,
        description: preview.description,
        imageUrl: preview.imageUrl,
      );
    }

    setState(() {
      _preview = preview;
      _isLoading = false;
    });
  }

  _PreviewContent? _previewFromItem(ClipboardItem item) {
    return _PreviewContent.fromValues(
      title: item.linkPreviewTitle,
      description: item.linkPreviewDescription,
      imageUrl: item.linkPreviewImageUrl,
    );
  }

  _PreviewContent? _previewFromLinkData(dynamic data) {
    if (data == null) {
      return null;
    }

    return _PreviewContent.fromValues(
      title: data.title as String?,
      description: data.description as String?,
      imageUrl: data.image?.url as String?,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isValidUrl = _isValidUrl(_url);
    if (!isValidUrl) {
      return LinkPreviewItem(bottom: widget.bottom, onTap: widget.onTap);
    }

    if (_isLoading) {
      return const Shimmer();
    }

    final preview = _preview;
    if (preview == null) {
      return LinkPreviewItem(bottom: widget.bottom, onTap: widget.onTap);
    }

    return LinkPreviewItem(
      maxTitleLines: widget.maxTitleLines,
      maxDescLines: widget.maxDescLines,
      bottom: widget.bottom,
      onTap: widget.onTap,
      title: preview.title,
      description: preview.description,
      provider: preview.imageUrl == null
          ? null
          : NetworkImage(preview.imageUrl!),
    );
  }
}
