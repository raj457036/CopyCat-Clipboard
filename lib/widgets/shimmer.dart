import 'package:flutter/widgets.dart';
import 'package:clipboard/utils/common_extension.dart';

class Shimmer extends StatefulWidget {
  final BorderRadius borderRadius;
  final Duration duration;

  const Shimmer({
    super.key,
    this.borderRadius = BorderRadius.zero,
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void didUpdateWidget(covariant Shimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller
        ..duration = widget.duration
        ..repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resolvedBase = context.colors.surfaceContainerHighest;
    final resolvedHighlight =
        Color.lerp(resolvedBase, context.colors.surface, 0.6) ?? resolvedBase;

    final child = SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: resolvedBase,
          borderRadius: widget.borderRadius,
        ),
      ),
    );

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        child: child,
        builder: (context, child) {
          final t = _controller.value;
          final begin = Alignment(-2 + (4 * t), -1);
          final end = Alignment(0 + (4 * t), 1);
          return ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: begin,
                end: end,
                colors: [resolvedBase, resolvedHighlight, resolvedBase],
                stops: const [0.2, 0.5, 0.8],
              ).createShader(bounds);
            },
            child: child,
          );
        },
      ),
    );
  }
}
