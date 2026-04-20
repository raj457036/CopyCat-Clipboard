import 'package:clipboard/utils/paste_stack.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:universal_io/io.dart';

class TogglePasteStackIntent extends Intent {
  const TogglePasteStackIntent();

  static final activator = SingleActivator(
    LogicalKeyboardKey.keyC,
    meta: Platform.isMacOS,
    control: Platform.isWindows || Platform.isLinux,
    shift: true,
    includeRepeats: false,
  );
}

class TogglePasteStackAction extends ContextAction<TogglePasteStackIntent> {
  @override
  void invoke(TogglePasteStackIntent intent, [BuildContext? context]) {
    if (context == null) return;
    togglePasteStack(context);
  }
}
