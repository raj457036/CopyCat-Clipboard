import 'package:clipboard/widgets/debug/focus_node_rect.dart';
import 'package:flutter/material.dart';

class GizmoOverlay extends StatelessWidget {
  final Widget child;
  final bool enabled;
  final bool focusGizmo;

  const GizmoOverlay({
    super.key,
    required this.child,
    this.enabled = true,
    this.focusGizmo = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    Widget entry = child;

    if (focusGizmo) {
      entry = FocusNodeRectGizmo(child: entry);
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Overlay(
        initialEntries: [
          OverlayEntry(
            builder: (context) => entry,
          ),
        ],
      ),
    );
  }
}
