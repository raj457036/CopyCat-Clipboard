import 'package:clipboard/widgets/video_players/mediakit_video_player.dart';
import 'package:clipboard/widgets/video_players/native_video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AdaptiveVideoPlayer extends StatelessWidget {
  final String url;
  final double width;
  final double? height;
  final double aspectRatio;
  final BorderRadius? borderRadius;
  final bool mute;
  final bool loop;

  const AdaptiveVideoPlayer({
    super.key,
    required this.url,
    required this.width,
    this.height,
    this.aspectRatio = 16 / 9,
    this.borderRadius,
    this.mute = true,
    this.loop = true,
  });

  bool get _useMediaKit {
    if (kIsWeb) return false;
    return switch (defaultTargetPlatform) {
      TargetPlatform.windows || TargetPlatform.linux => true,
      _ => false,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_useMediaKit) {
      return MeidaKitVideoPlayer(
        url: url,
        width: width,
        height: height,
        aspectRatio: aspectRatio,
        borderRadius: borderRadius,
        mute: mute,
        loop: loop,
      );
    }

    return NativeVideoPlayer(
      url: url,
      width: width,
      height: height,
      aspectRatio: aspectRatio,
      borderRadius: borderRadius,
      mute: mute,
      loop: loop,
    );
  }
}
