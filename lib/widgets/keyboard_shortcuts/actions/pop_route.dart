import 'package:clipboard/base/constants/key.dart';
import 'package:clipboard/widgets/window_focus_manager.dart';
import 'package:clipboard/base/bloc/selected_clips_cubit/selected_clips_cubit.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PopRouteIntent extends Intent {
  const PopRouteIntent();

  static const activator = SingleActivator(LogicalKeyboardKey.escape);
}

class HideWindowAction extends ContextAction<PopRouteIntent> {
  bool _dismissTopRoute() {
    final rootNavigator = rootNavKey.currentState;
    if (rootNavigator == null || !rootNavigator.canPop()) return false;

    FocusManager.instance.primaryFocus?.unfocus();
    rootNavigator.pop();
    return true;
  }

  @override
  void invoke(PopRouteIntent intent, [BuildContext? context]) {
    if (context == null) return;

    final rootContext = rootNavKey.currentContext ?? context;

    if (_dismissTopRoute()) {
      return;
    }

    if (GoRouter.of(rootContext).canPop()) {
      FocusManager.instance.primaryFocus?.unfocus();
      rootContext.pop();
      return;
    }

    final selectionCubit = rootContext.read<SelectedClipsCubit?>();

    if (selectionCubit != null && selectionCubit.hasSelection) {
      selectionCubit.clear();
      return;
    }

    WindowFocusManager.of(rootContext)?.restore();
  }
}
