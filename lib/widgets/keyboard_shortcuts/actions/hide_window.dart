import 'package:clipboard/widgets/window_focus_manager.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class HideWindowIntent extends Intent {
  const HideWindowIntent();

  static const activator = SingleActivator(LogicalKeyboardKey.escape);
}

class HideWindowAction extends ContextAction<HideWindowIntent> {
  @override
  Object? invoke(HideWindowIntent intent, [BuildContext? context]) {
    final primaryFocus = FocusManager.instance.primaryFocus;

    if (primaryFocus?.onKeyEvent != null) {
      return null;
    }

    if (context == null) return null;

    final canPop = context.canPop();

    if (!canPop) {
      WindowFocusManager.of(context)?.restore();
    } else {
      context.pop();
    }

    return null;
  }
}
