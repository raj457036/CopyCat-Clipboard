import 'package:clipboard/base/data/services/notification_service.dart';
import 'package:clipboard/base/domain/model/notification_message.dart'
    show NotificationMessage;
import 'package:clipboard/common/failure.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class MeidaKitVideoPlayer extends StatefulWidget {
  final String url;
  final double width;
  final double? height;
  final double aspectRatio;
  final BorderRadius? borderRadius;
  final bool mute;
  final bool loop;

  const MeidaKitVideoPlayer({
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
  State<MeidaKitVideoPlayer> createState() => _MeidaKitVideoPlayerState();
}

class _MeidaKitVideoPlayerState extends State<MeidaKitVideoPlayer> {
  late final player = Player();
  late final controller = VideoController(
    player,
    configuration: defaultTargetPlatform == TargetPlatform.macOS
        ? const VideoControllerConfiguration(enableHardwareAcceleration: false)
        : const VideoControllerConfiguration(),
  );

  bool loading = true;

  double get _height => widget.height ?? widget.width / widget.aspectRatio;

  @override
  void initState() {
    super.initState();
    _applyPlayerOptions();
    _open();
  }

  @override
  void didUpdateWidget(covariant MeidaKitVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.mute != widget.mute || oldWidget.loop != widget.loop) {
      _applyPlayerOptions();
    }

    if (oldWidget.url != widget.url) {
      _open();
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void _applyPlayerOptions() {
    player.setVolume(widget.mute ? 0 : 100);
    player.setPlaylistMode(widget.loop ? PlaylistMode.loop : PlaylistMode.none);
  }

  void _open() {
    if (!mounted) return;
    if (!loading) setState(() => loading = true);
    _listenForFrame();
    player.open(Media(widget.url));
  }

  Future<void> _listenForFrame() async {
    try {
      await controller.waitUntilFirstFrameRendered;
    } catch (e) {
      if (!mounted) return;
      InAppNotificationService.i.notify(
        NotificationMessage(
          id: "video_player_error",
          body: Failure.fromException(e).message,
          type: .error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final video = Video(
      controller: controller,
      width: widget.width,
      height: _height,
      aspectRatio: widget.aspectRatio,
      controls: (state) => const SizedBox.shrink(),
      pauseUponEnteringBackgroundMode: true,
      resumeUponEnteringForegroundMode: true,
    );
    Widget child = video;
    if (widget.borderRadius != null) {
      child = ClipRRect(borderRadius: widget.borderRadius!, child: child);
    }
    if (loading) {
      return SizedBox(
        width: widget.width,
        height: _height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }
    return RepaintBoundary(child: child);
  }
}
