import 'package:clipboard/common/failure.dart';
import 'package:clipboard/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class NativeVideoPlayer extends StatefulWidget {
  final String url;
  final double width;
  final double? height;
  final double aspectRatio;
  final BorderRadius? borderRadius;
  final bool mute;
  final bool loop;

  const NativeVideoPlayer({
    super.key,
    required this.url,
    required this.width,
    this.height,
    this.aspectRatio = 16 / 9,
    this.borderRadius,
    this.mute = true,
    this.loop = true,
  });

  @override
  State<NativeVideoPlayer> createState() => _NativeVideoPlayerState();
}

class _NativeVideoPlayerState extends State<NativeVideoPlayer> {
  VideoPlayerController? _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void didUpdateWidget(covariant NativeVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.url != widget.url) {
      _initialize();
      return;
    }

    final controller = _controller;
    if (controller == null) return;

    if (oldWidget.mute != widget.mute) {
      controller.setVolume(widget.mute ? 0 : 1);
    }
    if (oldWidget.loop != widget.loop) {
      controller.setLooping(widget.loop);
    }
  }

  @override
  void dispose() {
    final controller = _controller;
    _controller = null;
    controller?.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    final previous = _controller;
    setState(() => _loading = true);

    final controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _controller = controller;

    try {
      await controller.setLooping(widget.loop);
      await controller.setVolume(widget.mute ? 0 : 1);
      await controller.initialize();
      await controller.play();
    } catch (e) {
      if (mounted && identical(_controller, controller)) {
        showFailureSnackbar(Failure.fromException(e));
      }
    } finally {
      await previous?.dispose();
      if (mounted && identical(_controller, controller)) {
        setState(() => _loading = false);
      } else {
        await controller.dispose();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (_loading || controller == null || !controller.value.isInitialized) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: widget.width,
          maxHeight: widget.height ?? double.infinity,
        ),
        child: AspectRatio(
          aspectRatio: widget.aspectRatio,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: const Center(child: CircularProgressIndicator()),
          ),
        ),
      );
    }

    Widget child = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: widget.width,
        maxHeight: widget.height ?? double.infinity,
      ),
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: VideoPlayer(controller),
      ),
    );

    if (widget.borderRadius != null) {
      child = ClipRRect(borderRadius: widget.borderRadius!, child: child);
    }

    return RepaintBoundary(child: child);
  }
}
