import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/utility.dart' show formatBytes;
import 'package:clipboard/widgets/video_players/adaptive_video_player.dart';
import 'package:flutter/material.dart';

class MediaVideoPreview extends StatefulWidget {
  final ClipboardItem item;
  final ShapeBorder? shape;
  final ImageProvider? preview;
  final VoidCallback onOpen;

  const MediaVideoPreview({
    super.key,
    required this.item,
    required this.shape,
    required this.preview,
    required this.onOpen,
  });

  @override
  State<MediaVideoPreview> createState() => _MediaVideoPreviewState();
}

class _MediaVideoPreviewState extends State<MediaVideoPreview> {
  bool _isPlaying = false;
  bool _isMuted = true;

  @override
  void didUpdateWidget(covariant MediaVideoPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.id != widget.item.id ||
        oldWidget.item.localPath != widget.item.localPath) {
      _isPlaying = false;
      _isMuted = true;
    }
  }

  BorderRadius _resolveBorderRadius(BuildContext context) {
    final ShapeBorder? shape = widget.shape;
    if (shape is RoundedRectangleBorder) {
      return shape.borderRadius.resolve(Directionality.of(context));
    }
    return radius12;
  }

  String _getVideoBadgeText() {
    final String? mime = widget.item.fileMimeType;
    final int? size = widget.item.fileSize;
    String subtype = 'VIDEO';
    if (mime != null && mime.contains('/')) {
      subtype = mime.split('/').last.toUpperCase();
    }
    if (size != null && size > 0) {
      return '$subtype • ${formatBytes(size)}';
    }
    return subtype;
  }

  Widget _buildPoster(BuildContext context, bool canPlay) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colors = theme.colorScheme;

    return Stack(
      key: const ValueKey<String>('video_poster'),
      fit: StackFit.expand,
      children: [
        if (widget.preview != null)
          Image(
            image: widget.preview!,
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
          )
        else
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest,
            ),
            child: Center(
              child: Icon(
                Icons.video_file_outlined,
                size: 64,
                color: colors.outline,
              ),
            ),
          ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.35),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.45),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
        if (canPlay)
          Positioned(
            top: padding12,
            right: padding12,
            child: IconButton.filledTonal(
              style: IconButton.styleFrom(
                backgroundColor: Colors.black54,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.open_in_new_rounded, size: padding20),
              tooltip: context.locale.preview__card__file__open,
              onPressed: widget.onOpen,
            ),
          ),
        Positioned(
          top: padding14,
          left: padding14,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: const BorderRadius.all(Radius.circular(padding6)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: padding8,
                vertical: padding4,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.videocam_rounded,
                    size: padding14,
                    color: Colors.white70,
                  ),
                  width4,
                  Text(
                    _getVideoBadgeText(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: padding12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (canPlay)
          Center(
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: padding20,
                  vertical: padding14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(padding28),
                ),
                elevation: 4,
              ),
              icon: const Icon(Icons.play_arrow_rounded, size: 26),
              label: Text(
                context.locale.preview__card__video__play,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              onPressed: () => setState(() => _isPlaying = true),
            ),
          ),
      ],
    );
  }

  Widget _buildVideoPlayer(BuildContext context, BorderRadius borderRadius) {
    return LayoutBuilder(
      key: const ValueKey<String>('video_player'),
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : (width / (16 / 9));

        return Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: AdaptiveVideoPlayer(
                url: widget.item.localPath!,
                width: width,
                height: height,
                aspectRatio: 16 / 9,
                borderRadius: borderRadius,
                mute: _isMuted,
                loop: true,
                autoPlay: true,
              ),
            ),
            Positioned(
              top: padding12,
              right: padding12,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius:
                      const BorderRadius.all(Radius.circular(padding20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: padding4,
                    vertical: padding2,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          _isMuted
                              ? Icons.volume_off_rounded
                              : Icons.volume_up_rounded,
                          color: Colors.white,
                          size: padding20,
                        ),
                        tooltip: _isMuted
                            ? context.locale.preview__card__video__unmute
                            : context.locale.preview__card__video__mute,
                        onPressed: () => setState(() => _isMuted = !_isMuted),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.open_in_new_rounded,
                          color: Colors.white,
                          size: padding20,
                        ),
                        tooltip: context.locale.preview__card__file__open,
                        onPressed: widget.onOpen,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: padding20,
                        ),
                        tooltip: context.locale.preview__card__video__close,
                        onPressed: () => setState(() => _isPlaying = false),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = _resolveBorderRadius(context);
    final bool canPlay =
        widget.item.inCache && widget.item.localPath != null;

    return Card.filled(
      margin: EdgeInsets.zero,
      shape: widget.shape,
      clipBehavior: Clip.antiAlias,
      child: AnimatedSwitcher(
        duration: Durations.medium2,
        child: _isPlaying && canPlay
            ? _buildVideoPlayer(context, borderRadius)
            : _buildPoster(context, canPlay),
      ),
    );
  }
}
