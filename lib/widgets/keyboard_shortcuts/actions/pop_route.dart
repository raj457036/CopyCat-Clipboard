import 'package:clipboard/widgets/window_focus_manager.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class PopRouteIntent extends Intent {
  const PopRouteIntent();

  static const activator = SingleActivator(LogicalKeyboardKey.escape);
}

class HideWindowAction extends ContextAction<PopRouteIntent> {
  @override
  void invoke(PopRouteIntent intent, [BuildContext? context]) {
    final primaryFocus = FocusManager.instance.primaryFocus;

    if (primaryFocus?.onKeyEvent != null) return;
    if (context == null) return;

    final canPop = Navigator.canPop(context);

    if (!canPop) {
      WindowFocusManager.of(context)?.restore();
    } else {
      context.pop();
    }
  }
}
