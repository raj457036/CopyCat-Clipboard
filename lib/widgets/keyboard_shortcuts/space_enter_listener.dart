import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class _SpaceActionIntent extends Intent {}

class _EnterActionIntent extends Intent {}

class _ShiftSpaceActionIntent extends Intent {}

class _ShiftSpaceEnterIntent extends Intent {}

typedef BuildContextCallback = void Function(BuildContext context);

/// A widget that listens for space and enter key presses and
/// triggers the provided callbacks.
class SpaceEnterListener extends StatelessWidget {
  final Widget child;
  final bool enabled;

  final BuildContextCallback onSpace;
  final BuildContextCallback onEnter;
  final BuildContextCallback? onShiftSpace;
  final BuildContextCallback? onShiftSpaceEnter;

  const SpaceEnterListener({
    super.key,
    required this.child,
    required this.onSpace,
    required this.onEnter,
    this.enabled = true,
    this.onShiftSpace,
    this.onShiftSpaceEnter,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return child;
    }

    return Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        const SingleActivator(LogicalKeyboardKey.space): _SpaceActionIntent(),
        const SingleActivator(LogicalKeyboardKey.enter): _EnterActionIntent(),
        if (onShiftSpace != null)
          const SingleActivator(LogicalKeyboardKey.space, shift: true):
              _ShiftSpaceActionIntent(),
        if (onShiftSpaceEnter != null)
          const SingleActivator(LogicalKeyboardKey.enter, shift: true):
              _ShiftSpaceEnterIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          _SpaceActionIntent: CallbackAction<_SpaceActionIntent>(
            onInvoke: (intent) => onSpace(context), // Space triggers toggle
          ),
          _EnterActionIntent: CallbackAction<_EnterActionIntent>(
            onInvoke: (intent) => onEnter(context), // Enter triggers primary
          ),

          if (onShiftSpace != null)
            _ShiftSpaceActionIntent: CallbackAction<_ShiftSpaceActionIntent>(
              onInvoke: (intent) => onShiftSpace!(context),
            ),
          if (onShiftSpaceEnter != null)
            _ShiftSpaceEnterIntent: CallbackAction<_ShiftSpaceEnterIntent>(
              onInvoke: (intent) => onShiftSpaceEnter!(context),
            ),
        },
        child: child,
      ),
    );
  }
}
