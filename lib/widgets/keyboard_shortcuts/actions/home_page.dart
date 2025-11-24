import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_io/io.dart';

class NavigateToHomePageIntent extends Intent {
  const NavigateToHomePageIntent();

  static final activator = SingleActivator(
    LogicalKeyboardKey.keyD,
    meta: Platform.isMacOS,
    control: Platform.isWindows || Platform.isLinux,
    includeRepeats: false,
  );
}

class NavigateToHomePageAction extends ContextAction<NavigateToHomePageIntent> {
  @override
  void invoke(NavigateToHomePageIntent intent, [BuildContext? context]) {
    context?.goNamed(RouteConstants.home);
  }
}
