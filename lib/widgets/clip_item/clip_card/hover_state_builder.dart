import 'package:flutter/material.dart';

class HoverScope extends InheritedWidget {
  final bool hovered;

  const HoverScope({super.key, required this.hovered, required super.child});

  /// Whether the widget or any of its ancestor widget is being hovered.
  static bool of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<HoverScope>();
    return scope?.hovered ?? false;
  }

  @override
  bool updateShouldNotify(HoverScope oldWidget) {
    return hovered != oldWidget.hovered;
  }
}

/// Provides hover state without rebuilding child content.
/// Only the hoverable parts rebuild when hover changes.
class HoverScopeProvider extends StatefulWidget {
  final Widget child;

  /// Wrap [child] with a hover scope that provides hover state to its descendants.
  ///
  /// To get the hover state, use `HoverScope.of(context)` in the descendant widgets.
  const HoverScopeProvider({super.key, required this.child});

  @override
  State<HoverScopeProvider> createState() => _HoverScopeProviderState();
}

class _HoverScopeProviderState extends State<HoverScopeProvider> {
  bool _hovered = false;

  /// Whether the widget or any of its ancestor widget is being hovered.
  bool get hovered => _hovered;

  void _onHover(bool hovered) {
    if (_hovered != hovered) {
      setState(() => _hovered = hovered);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset hover state when dependencies change to prevent stale hover state
    if (_hovered) {
      setState(() => _hovered = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: HoverScope(hovered: _hovered, child: widget.child),
    );
  }
}
