import 'package:clipboard/widgets/debug/focus_node_rect.dart';
import 'package:flutter/material.dart';
import 'package:statsfl/statsfl.dart' show StatsFl;

class GizmoOverlay extends StatelessWidget {
  final Widget child;
  final bool enabled;
  final bool focusGizmo;
  final bool fpsGizmo;

  const GizmoOverlay({
    super.key,
    required this.child,
    this.enabled = true,
    this.focusGizmo = true,
    this.fpsGizmo = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    Widget entry = child;

    if (focusGizmo) {
      entry = FocusNodeRectGizmo(child: entry);
    }

    return StatsFl(
      isEnabled: fpsGizmo,
      align: Alignment.topCenter,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Overlay(
          initialEntries: [OverlayEntry(builder: (context) => entry)],
        ),
      ),
    );
  }
}
