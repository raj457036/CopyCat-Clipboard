import 'package:clipboard/utils/utility.dart';
import 'package:flutter/material.dart';

class BorderPainter extends CustomPainter {
  final Offset position;
  final Size boxSize;

  const BorderPainter({required this.position, required this.boxSize});

  @override
  void paint(Canvas canvas, Size size) {
    // Tinted fill + outline
    final fillPaint = Paint()
      ..color = const Color.fromARGB(40, 98, 255, 0)
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = const Color.fromARGB(200, 98, 255, 0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, fillPaint);
    canvas.drawRect(rect, borderPaint);

    // Dimension label: "x, y  w × h"
    final label =
        'x:${position.dx.toStringAsFixed(1)}  '
        'y:${position.dy.toStringAsFixed(1)}  '
        'w:${boxSize.width.toStringAsFixed(1)}  '
        'h:${boxSize.height.toStringAsFixed(1)}';

    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Color.fromARGB(255, 0, 255, 0),
          fontSize: 10,
          fontWeight: FontWeight.bold,
          backgroundColor: Color.fromARGB(160, 0, 0, 0),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width);

    // Place label just above the top-left corner; fall back inside if clipped.
    final labelTop = textPainter.height + 2 > 0
        ? -textPainter.height - 2.0
        : 2.0;
    textPainter.paint(canvas, Offset(0, labelTop));

    // Corner cross-hair markers at each corner
    const markerLen = 6.0;
    final markerPaint = Paint()
      ..color = const Color.fromARGB(220, 98, 255, 0)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (final corner in [
      Offset.zero,
      Offset(size.width, 0),
      Offset(0, size.height),
      Offset(size.width, size.height),
    ]) {
      final dx = corner.dx == 0 ? markerLen : -markerLen;
      final dy = corner.dy == 0 ? markerLen : -markerLen;
      canvas.drawLine(corner, corner + Offset(dx, 0), markerPaint);
      canvas.drawLine(corner, corner + Offset(0, dy), markerPaint);
    }
  }

  @override
  bool shouldRepaint(BorderPainter old) =>
      old.position != position || old.boxSize != boxSize;
}

class FocusNodeRectGizmo extends StatefulWidget {
  final Widget child;

  const FocusNodeRectGizmo({super.key, required this.child});

  @override
  State<FocusNodeRectGizmo> createState() => _FocusNodeRectGizmoState();
}

class _FocusNodeRectGizmoState extends State<FocusNodeRectGizmo> {
  late final OverlayState overlay;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    overlay = Overlay.of(context);
    FocusManager.instance.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    FocusManager.instance.removeListener(_onFocusChanged);
    _removeOverlay();
    super.dispose();
  }

  void _onFocusChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final overlay = Overlay.of(context);
      await wait(250);
      final focusedNode = FocusManager.instance.primaryFocus;
      if (focusedNode != null && focusedNode.context != null) {
        final renderBox = focusedNode.rect;
        // final offset = renderBox.localToGlobal(Offset.zero);

        _removeOverlay();
        _overlayEntry = _createOverlayEntry(renderBox.topLeft, renderBox.size);
        overlay.insert(_overlayEntry!);
      } else {
        _removeOverlay();
      }
    });
  }

  OverlayEntry _createOverlayEntry(Offset offset, Size size) {
    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy,
        width: size.width,
        height: size.height,
        child: IgnorePointer(
          child: CustomPaint(
            painter: BorderPainter(position: offset, boxSize: size),
          ),
        ),
      ),
    );
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
