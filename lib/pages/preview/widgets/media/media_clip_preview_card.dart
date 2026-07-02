import 'dart:typed_data';

import 'package:clipboard/base/constants/strings/asset_constants.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/pages/preview/view/clip_preview_config.dart';
import 'package:clipboard/pages/preview/widgets/media/media_audio_preview.dart';
import 'package:clipboard/pages/preview/widgets/media/media_image_preview.dart';
import 'package:clipboard/pages/preview/widgets/media/media_svg_preview.dart';
import 'package:clipboard/pages/preview/widgets/media/media_video_preview.dart';
import 'package:clipboard/utils/blur_hash.dart';
import 'package:clipboard/utils/clipboard_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:universal_io/io.dart';

class MediaClipPreviewCard extends StatefulWidget {
  final ClipboardItem item;
  const MediaClipPreviewCard({super.key, required this.item});

  @override
  State<MediaClipPreviewCard> createState() => _MediaClipPreviewCardState();
}

class _MediaClipPreviewCardState extends State<MediaClipPreviewCard> {
  Uint8List? _blurHashBytes;

  @override
  void initState() {
    super.initState();
    _loadBlurHash();
  }

  @override
  void didUpdateWidget(MediaClipPreviewCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.imgBlurHash != widget.item.imgBlurHash) {
      _loadBlurHash();
    }
  }

  Future<void> _loadBlurHash() async {
    final hash = widget.item.imgBlurHash;
    if (hash == null || widget.item.localPath != null) return;
    final bytes = await getImageFromBlurHash(hash);
    if (mounted && bytes != null) {
      setState(() => _blurHashBytes = bytes);
    }
  }

  ImageProvider? _getPreview() {
    if (widget.item.localPath != null) {
      return FileImage(File(widget.item.localPath!));
    }
    if (_blurHashBytes != null) return MemoryImage(_blurHashBytes!);
    if (widget.item.imgBlurHash == null) {
      return const AssetImage(AssetConstants.placeholderImage);
    }
    return null;
  }

  void _open() => openFile(widget.item);

  @override
  Widget build(BuildContext context) {
    final config = ClipPreviewConfig.of(context);
    final preview = _getPreview();
    final mimeType = widget.item.fileMimeType ?? '';

    if (mimeType.startsWith('video')) {
      return MediaVideoPreview(
        item: widget.item,
        shape: config?.shape,
        preview: preview,
        onOpen: _open,
      );
    }
    if (mimeType.startsWith('audio')) {
      return MediaAudioPreview(item: widget.item, shape: config?.shape);
    }

    if (mimeType.contains('svg')) {
      return MediaSVGImagePreview(
        item: widget.item,
        shape: config?.shape,
        preview: SvgPicture.file(File(widget.item.localPath!)),
      );
    }

    return MediaImagePreview(
      item: widget.item,
      shape: config?.shape,
      preview: preview,
    );
  }
}
