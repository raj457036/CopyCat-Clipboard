import 'dart:typed_data';

import 'package:clipboard/pages/preview/view/clip_preview_config.dart';
import 'package:clipboard/utils/blur_hash.dart';
import 'package:clipboard/utils/clipboard_actions.dart';
import 'package:clipboard/base/constants/strings/asset_constants.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
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
      if (widget.item.fileMimeType!.contains("svg")) {
        return Svg(widget.item.localPath!, source: SvgSource.file);
      }
      return FileImage(File(widget.item.localPath!));
    }
    if (_blurHashBytes != null) return MemoryImage(_blurHashBytes!);
    if (widget.item.imgBlurHash == null) {
      return const AssetImage(AssetConstants.placeholderImage);
    }
    // still loading — return null so the card renders without an image first.
    return null;
  }

  void _open() => openFile(widget.item);

  Widget? _getPrimaryView(BuildContext context) {
    if (widget.item.fileMimeType != null) {
      if (widget.item.fileMimeType!.startsWith("image")) {
        return const Align(
          alignment: Alignment(-.98, -.98),
          child: Icon(Icons.image_rounded, color: Colors.white),
        );
      }
      if (widget.item.fileMimeType!.startsWith("video")) {
        if (widget.item.inCache) {
          return Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow_rounded),
              onPressed: _open,
              label: Text(context.locale.preview__card__video__play),
            ),
          );
        }
        return const Align(
          alignment: Alignment(-.98, -.98),
          child: Icon(Icons.video_file, color: Colors.white),
        );
      }
      if (widget.item.fileMimeType!.startsWith("audio")) {
        return const Align(
          alignment: Alignment(-.98, -.98),
          child: Icon(Icons.audiotrack, color: Colors.white),
        );
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final config = ClipPreviewConfig.of(context);
    final preview = _getPreview();

    return Card.filled(
      margin: EdgeInsets.zero,
      shape: config?.shape,
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: preview != null
              ? DecorationImage(image: preview, fit: BoxFit.contain)
              : null,
          borderRadius: const BorderRadius.horizontal(
            left: Radius.circular(12),
          ),
        ),
        child: _getPrimaryView(context),
      ),
    );
  }
}
