import 'package:clipboard/widgets/window_focus_manager.dart';
import 'package:copycat_base/bloc/selected_clips_cubit/selected_clips_cubit.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PopRouteIntent extends Intent {
  const PopRouteIntent();

  static const activator = SingleActivator(LogicalKeyboardKey.escape);
}

class HideWindowAction extends ContextAction<PopRouteIntent> {
  @override
  void invoke(PopRouteIntent intent, [BuildContext? context]) {
    if (context == null) return;

    final selectionCubit = context.read<SelectedClipsCubit?>();

    if (selectionCubit != null && selectionCubit.hasSelection) {
      selectionCubit.clear();
      return;
    }

    final primaryFocus = FocusManager.instance.primaryFocus;

    if (primaryFocus?.onKeyEvent != null) return;

    final canPop = Navigator.canPop(context);

    if (!canPop) {
      WindowFocusManager.of(context)?.restore();
    } else {
      context.pop();
    }
  }
}
