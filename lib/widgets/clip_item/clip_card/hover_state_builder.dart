import 'package:flutter/material.dart';

/// Provides hover state without rebuilding child content.
/// Only the hoverable parts rebuild when hover changes.
class HoverStateBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, bool hovered) builder;

  const HoverStateBuilder({super.key, required this.builder});

  @override
  State<HoverStateBuilder> createState() => _HoverStateBuilderState();
}

class _HoverStateBuilderState extends State<HoverStateBuilder> {
  bool _hovered = false;

  void _onHover(bool hovered) {
    if (_hovered != hovered) {
      setState(() => _hovered = hovered);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: widget.builder(context, _hovered),
    );
  }
}
