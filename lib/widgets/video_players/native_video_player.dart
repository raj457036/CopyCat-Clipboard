import 'package:clipboard/base/data/services/notification_service.dart'
    show InAppNotificationService;
import 'package:clipboard/base/domain/model/notification_message.dart'
    show NotificationMessage;
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/widgets/yarn_ball_loading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';
import 'package:video_player/video_player.dart';

class NativeVideoPlayer extends StatefulWidget {
  final String url;
  final double width;
  final double? height;
  final double aspectRatio;
  final BorderRadius? borderRadius;
  final bool mute;
  final bool loop;
  final bool autoPlay;

  const NativeVideoPlayer({
    super.key,
    required this.url,
    required this.width,
    this.height,
    this.aspectRatio = 16 / 9,
    this.borderRadius,
    this.mute = true,
    this.loop = true,
    this.autoPlay = true,
  });

  @override
  State<NativeVideoPlayer> createState() => _NativeVideoPlayerState();
}

class _NativeVideoPlayerState extends State<NativeVideoPlayer> {
  VideoPlayerController? _controller;
  bool _loading = true;
  bool _isPlaying = true;

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

    final VideoPlayerController? controller = _controller;
    if (controller == null) return;

    if (oldWidget.mute != widget.mute) {
      controller.setVolume(widget.mute ? 0 : 1);
    }
    if (oldWidget.loop != widget.loop) {
      controller.setLooping(widget.loop);
    }
  }

  void _onControllerUpdate() {
    final VideoPlayerController? controller = _controller;
    if (controller == null) return;
    if (controller.value.isPlaying != _isPlaying) {
      if (mounted) {
        setState(() {
          _isPlaying = controller.value.isPlaying;
        });
      }
    }
  }

  @override
  void dispose() {
    final VideoPlayerController? controller = _controller;
    _controller = null;
    controller?.removeListener(_onControllerUpdate);
    controller?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    final VideoPlayerController? controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
  }

  Future<void> _initialize() async {
    final VideoPlayerController? previous = _controller;
    previous?.removeListener(_onControllerUpdate);
    setState(() => _loading = true);

    final Uri? parsedUri = Uri.tryParse(widget.url);
    final bool isNetwork = parsedUri != null &&
        (parsedUri.scheme == 'http' || parsedUri.scheme == 'https');

    final VideoPlayerController controller;
    if (isNetwork || kIsWeb) {
      controller = VideoPlayerController.networkUrl(
        parsedUri ?? Uri.parse(widget.url),
      );
    } else if (parsedUri != null && parsedUri.scheme == 'file') {
      controller = VideoPlayerController.file(File.fromUri(parsedUri));
    } else {
      controller = VideoPlayerController.file(File(widget.url));
    }
    _controller = controller;

    try {
      await controller.setLooping(widget.loop);
      await controller.setVolume(widget.mute ? 0 : 1);
      await controller.initialize();
      controller.addListener(_onControllerUpdate);
      if (widget.autoPlay) {
        await controller.play();
      }
      _isPlaying = controller.value.isPlaying;
    } catch (e) {
      if (mounted && identical(_controller, controller)) {
        InAppNotificationService.i.notify(
          NotificationMessage(
            id: "video_player_error",
            body: Failure.fromException(e).message,
          ),
        );
      }
    } finally {
      await previous?.dispose();
      if (mounted && identical(_controller, controller)) {
        setState(() => _loading = false);
      } else {
        controller.removeListener(_onControllerUpdate);
        await controller.dispose();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final VideoPlayerController? controller = _controller;
    if (_loading || controller == null || !controller.value.isInitialized) {
      return Center(
        child: ConstrainedBox(
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
              child: const Center(child: YarnBallLoading(size: 32)),
            ),
          ),
        ),
      );
    }

    Widget child = Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: widget.width,
          maxHeight: widget.height ?? double.infinity,
        ),
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: GestureDetector(
            onTap: _togglePlayPause,
            behavior: HitTestBehavior.opaque,
            child: Stack(
              fit: StackFit.expand,
              children: [
                VideoPlayer(controller),
                if (!_isPlaying)
                  const ColoredBox(
                    color: Colors.black38,
                    child: Center(
                      child: Icon(
                        Icons.play_circle_filled_rounded,
                        size: 56,
                        color: Colors.white70,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );

    if (widget.borderRadius != null) {
      child = ClipRRect(borderRadius: widget.borderRadius!, child: child);
    }

    return RepaintBoundary(child: child);
  }
}
