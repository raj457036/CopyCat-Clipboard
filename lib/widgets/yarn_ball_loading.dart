import 'dart:math' as math;

import 'package:animate_do/animate_do.dart' show Spin;
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/widgets.dart';

class YarnBallCustomPainter extends CustomPainter {
  final Color color;
  YarnBallCustomPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const double originalSize = 256.0;

    final scale = math.min(
      size.width / originalSize,
      size.height / originalSize,
    );

    canvas.save();

    // Center the drawing.
    canvas.translate(
      (size.width - originalSize * scale) / 2,
      (size.height - originalSize * scale) / 2,
    );

    // Scale from the original 256x256 coordinate system.
    canvas.scale(scale);

    Path path_1 = Path();
    path_1.moveTo(183.39, 216);
    path_1.cubicTo(213.569, 196.986, 231.929, 163.72, 231.929, 128.05);
    path_1.cubicTo(231.929, 71.025, 185.004, 24.1, 127.979, 24.1);
    path_1.cubicTo(70.954, 24.1, 24.029, 71.025, 24.029, 128.05);
    path_1.cubicTo(24.029, 185.075, 70.954, 232, 127.979, 232);
    path_1.cubicTo(127.986, 232, 127.993, 232, 128, 232);
    path_1.cubicTo(128, 232, 160, 232, 183.39, 216);
    path_1.close();
    path_1.moveTo(128, 40);
    path_1.cubicTo(143.424, 39.983, 158.581, 44.044, 171.93, 51.77);
    path_1.cubicTo(162.289, 56.129, 152.972, 61.172, 144.05, 66.86);
    path_1.cubicTo(129.927, 57.854, 114.831, 50.474, 99.05, 44.86);
    path_1.cubicTo(108.357, 41.622, 118.145, 39.979, 128, 40);
    path_1.close();
    path_1.moveTo(78.56, 55.24);
    path_1.cubicTo(96.491, 60.093, 113.684, 67.348, 129.67, 76.81);
    path_1.cubicTo(122.839, 81.952, 116.305, 87.477, 110.1, 93.36);
    path_1.cubicTo(93.682, 84.624, 76.019, 78.462, 57.73, 75.09);
    path_1.cubicTo(63.546, 67.383, 70.582, 60.678, 78.56, 55.24);
    path_1.close();
    path_1.moveTo(48.72, 89.82);
    path_1.cubicTo(65.99, 92.344, 82.753, 97.578, 98.39, 105.33);
    path_1.cubicTo(92.837, 111.432, 87.619, 117.832, 82.76, 124.5);
    path_1.cubicTo(69.595, 118.591, 55.609, 114.713, 41.28, 113);
    path_1.cubicTo(42.668, 104.964, 45.172, 97.162, 48.72, 89.82);
    path_1.close();
    path_1.moveTo(40, 129);
    path_1.cubicTo(51.572, 130.43, 62.89, 133.459, 73.63, 138);
    path_1.cubicTo(66.048, 150.172, 59.662, 163.048, 54.56, 176.45);
    path_1.cubicTo(45.23, 162.372, 40.172, 145.889, 40, 129);
    path_1.close();
    path_1.moveTo(66.42, 190.81);
    path_1.cubicTo(85.849, 132.52, 129.985, 85.642, 187, 62.74);
    path_1.cubicTo(193.315, 68.454, 198.778, 75.044, 203.22, 82.31);
    path_1.cubicTo(146.724, 102.075, 103.295, 148.227, 87, 205.82);
    path_1.cubicTo(79.456, 201.834, 72.528, 196.778, 66.43, 190.81);
    path_1.lineTo(66.42, 190.81);
    path_1.close();
    path_1.moveTo(125.66, 216);
    path_1.cubicTo(117.57, 215.773, 109.551, 214.427, 101.83, 212);
    path_1.cubicTo(116.461, 157.949, 157.211, 114.659, 210.28, 96.79);
    path_1.cubicTo(213.155, 104.353, 214.966, 112.279, 215.66, 120.34);
    path_1.cubicTo(172.108, 135.963, 138.601, 171.577, 125.66, 216);
    path_1.close();
    path_1.moveTo(215.48, 137.56);
    path_1.cubicTo(211.177, 176.5, 181.417, 208.123, 142.81, 214.78);
    path_1.cubicTo(154.791, 179.796, 181.293, 151.624, 215.48, 137.53);
    path_1.lineTo(215.48, 137.56);
    path_1.close();

    Paint paint1Fill = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    canvas.drawPath(path_1, paint1Fill);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class YarnBall extends StatelessWidget {
  final Color? color;
  final double? size;
  const YarnBall({super.key, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    final yarnColor = color ?? context.colors.primary;
    final customPaint = CustomPaint(
      painter: YarnBallCustomPainter(color: yarnColor),
    );

    if (size != null) {
      return SizedBox.square(dimension: size!, child: customPaint);
    }
    return customPaint;
  }
}

class YarnBallLoading extends StatelessWidget {
  final double size;
  final Color? color;

  const YarnBallLoading({super.key, this.size = 50, this.color});

  @override
  Widget build(BuildContext context) {
    final yarnColor = color ?? context.colors.primary;
    return SizedBox.square(
      dimension: size,
      child: Spin(
        infinite: true,
        duration: const Duration(seconds: 2),
        child: YarnBall(color: yarnColor),
      ),
    );
  }
}
