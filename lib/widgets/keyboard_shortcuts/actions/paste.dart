import 'package:clipboard/utils/clipboard_actions.dart';
import 'package:copycat_base/constants/strings/route_constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_io/io.dart';

class PasteIntent extends Intent {
  const PasteIntent();

  static final activator = SingleActivator(
    LogicalKeyboardKey.keyV,
    meta: Platform.isMacOS,
    control: Platform.isWindows || Platform.isLinux,
    includeRepeats: false,
  );
}

class PasteAction extends ContextAction<PasteIntent> {
  @override
  void invoke(PasteIntent intent, [BuildContext? context]) {
    if (context == null) return;
    context.goNamed(RouteConstants.home);
    pasteContent(context);
  }
}
