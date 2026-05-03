import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

/// Ensures that arrow-key navigation never gets stuck with focus off-screen.
///
/// If focus is missing/stale or currently outside the visible viewport, the
/// first arrow key press moves focus to the nearest available focusable item.
class ArrowFocusVisibilityListener extends StatefulWidget {
  final Widget child;

  const ArrowFocusVisibilityListener({super.key, required this.child});

  @override
  State<ArrowFocusVisibilityListener> createState() =>
      _ArrowFocusVisibilityListenerState();
}

class _ArrowFocusVisibilityListenerState
    extends State<ArrowFocusVisibilityListener> {
  late final bool Function(KeyEvent) _handler;

  @override
  void initState() {
    super.initState();
    _handler = _onKeyEvent;
    HardwareKeyboard.instance.addHandler(_handler);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handler);
    super.dispose();
  }

  bool _onKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return false;

    final key = event.logicalKey;
    final isArrow =
        key == LogicalKeyboardKey.arrowUp ||
        key == LogicalKeyboardKey.arrowDown ||
        key == LogicalKeyboardKey.arrowLeft ||
        key == LogicalKeyboardKey.arrowRight;
    if (!isArrow) return false;

    final isReverse =
        key == LogicalKeyboardKey.arrowUp ||
        key == LogicalKeyboardKey.arrowLeft;
    final scope =
        FocusManager.instance.primaryFocus?.nearestScope ??
        FocusManager.instance.rootScope;

    final primaryFocus = FocusManager.instance.primaryFocus;
    final focusContext = primaryFocus?.context;

    if (focusContext == null || !focusContext.mounted) {
      return isReverse ? scope.previousFocus() : scope.nextFocus();
    }

    // Keep text-field caret navigation untouched.
    if (focusContext.widget is EditableText) return false;

    if (_isFocusedNodeOutOfView(focusContext)) {
      primaryFocus?.unfocus();
      return isReverse ? scope.previousFocus() : scope.nextFocus();
    }

    return false;
  }

  bool _isFocusedNodeOutOfView(BuildContext context) {
    final scrollable = Scrollable.maybeOf(context);
    final target = context.findRenderObject();
    if (scrollable == null || target == null || !target.attached) return false;

    final viewport = RenderAbstractViewport.maybeOf(target);
    if (viewport == null) return false;

    final leading = viewport.getOffsetToReveal(target, 0).offset;
    final trailing = viewport.getOffsetToReveal(target, 1).offset;
    final minOffset = math.min(leading, trailing);
    final maxOffset = math.max(leading, trailing);
    final pixels = scrollable.position.pixels;

    return pixels < minOffset || pixels > maxOffset;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
