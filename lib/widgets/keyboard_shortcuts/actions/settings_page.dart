import 'package:copycat_base/constants/strings/route_constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_io/io.dart';

class NavigateToSettingPageIntent extends Intent {
  const NavigateToSettingPageIntent();

  static final activator = SingleActivator(
    LogicalKeyboardKey.keyX,
    meta: Platform.isMacOS,
    control: Platform.isWindows || Platform.isLinux,
    includeRepeats: false,
  );
}

class NavigateToSettingPageAction
    extends ContextAction<NavigateToSettingPageIntent> {
  @override
  Object? invoke(NavigateToSettingPageIntent intent, [BuildContext? context]) {
    context?.goNamed(RouteConstants.settings);
    return null;
  }
}
