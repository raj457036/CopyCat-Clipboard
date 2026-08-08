import 'package:flutter/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Favicon extends StatelessWidget {
  final String url;
  final double size;
  const Favicon({super.key, required this.url, this.size = 16})
    : assert(size % 8 == 0, 'Size must be a multiple of 8'),
      assert(size > 0);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl:
          "https://t0.gstatic.com/faviconV2?client=SOCIAL&type=FAVICON&fallback_opts=TYPE,SIZE,URL&url=$url&size=${size.toInt() * 2}",
      fit: BoxFit.contain,
      errorWidget: (context, url, error) => const SizedBox.shrink(),
      height: size,
      width: size,
    );
  }
}
