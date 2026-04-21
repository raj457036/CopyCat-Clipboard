import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class _SpaceActionIntent extends Intent {}

class _EnterActionIntent extends Intent {}

class _ShiftSpaceActionIntent extends Intent {}

class _ShiftSpaceEnterIntent extends Intent {}

class _ShiftC extends Intent {}

typedef BuildContextCallback = void Function(BuildContext context);

/// A widget that listens for space and enter key presses and
/// triggers the provided callbacks.
class SpaceEnterListener extends StatelessWidget {
  final Widget child;
  final bool enabled;

  final BuildContextCallback? onSpace;
  final BuildContextCallback? onEnter;
  final BuildContextCallback? onShiftSpace;
  final BuildContextCallback? onShiftSpaceEnter;
  final BuildContextCallback? onShiftC;

  const SpaceEnterListener({
    super.key,
    required this.child,
    this.onSpace,
    this.onEnter,
    this.enabled = true,
    this.onShiftSpace,
    this.onShiftSpaceEnter,
    this.onShiftC,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return child;
    }

    return Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        if (onSpace != null)
          const SingleActivator(LogicalKeyboardKey.space): _SpaceActionIntent(),
        if (onEnter != null)
          const SingleActivator(LogicalKeyboardKey.enter): _EnterActionIntent(),
        if (onShiftSpace != null)
          const SingleActivator(LogicalKeyboardKey.space, shift: true):
              _ShiftSpaceActionIntent(),
        if (onShiftSpaceEnter != null)
          const SingleActivator(LogicalKeyboardKey.enter, shift: true):
              _ShiftSpaceEnterIntent(),
        if (onShiftC != null)
          const SingleActivator(LogicalKeyboardKey.keyC, shift: true):
              _ShiftC(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          if (onSpace != null)
            _SpaceActionIntent: CallbackAction<_SpaceActionIntent>(
              onInvoke: (intent) => onSpace!(context), // Space triggers toggle
            ),
          if (onEnter != null)
            _EnterActionIntent: CallbackAction<_EnterActionIntent>(
              onInvoke: (intent) => onEnter!(context), // Enter triggers primary
            ),

          if (onShiftSpace != null)
            _ShiftSpaceActionIntent: CallbackAction<_ShiftSpaceActionIntent>(
              onInvoke: (intent) => onShiftSpace!(context),
            ),
          if (onShiftSpaceEnter != null)
            _ShiftSpaceEnterIntent: CallbackAction<_ShiftSpaceEnterIntent>(
              onInvoke: (intent) => onShiftSpaceEnter!(context),
            ),

          if (onShiftC != null)
            _ShiftC: CallbackAction<_ShiftC>(
              onInvoke: (intent) => onShiftC!(context),
            ),
        },
        child: child,
      ),
    );
  }
}
