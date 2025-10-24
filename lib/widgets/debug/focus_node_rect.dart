import 'package:clipboard/utils/utility.dart';
import 'package:flutter/material.dart';

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(83, 98, 255, 0) // Red border
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 2;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
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
            painter: BorderPainter(),
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
