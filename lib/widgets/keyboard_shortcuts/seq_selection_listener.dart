import 'package:copycat_base/bloc/selected_clips_cubit/selected_clips_cubit.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A widget that listens for Shift key events and updates selection behavior accordingly.
class SeqSelectionListener extends StatefulWidget {
  final Widget child;

  const SeqSelectionListener({
    super.key,
    required this.child,
  });

  @override
  State<SeqSelectionListener> createState() => _SeqSelectionListenerState();
}

class _SeqSelectionListenerState extends State<SeqSelectionListener> {
  late final bool Function(KeyEvent) handler;
  late final SelectedClipsCubit selectionCubit;

  @override
  void initState() {
    selectionCubit = context.read<SelectedClipsCubit>();
    buildHandler();
    HardwareKeyboard.instance.addHandler(handler);
    super.initState();
  }

  void buildHandler() {
    handler = (KeyEvent event) {
      final isShiftKey = event.logicalKey == LogicalKeyboardKey.shift ||
          event.logicalKey == LogicalKeyboardKey.shiftLeft ||
          event.logicalKey == LogicalKeyboardKey.shiftRight;

      if (!isShiftKey) return false;

      if (event is KeyUpEvent) {
        selectionCubit.multiSelectMode = false;
      }
      if (event is KeyDownEvent) {
        selectionCubit.multiSelectMode = true;
      }

      // NOTE: Prevent further propagation of this event
      return true;
    };
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(handler);
    super.dispose();
  }
}
