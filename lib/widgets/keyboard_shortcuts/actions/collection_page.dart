import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_io/io.dart';

class NavigateToCollectionPageIntent extends Intent {
  const NavigateToCollectionPageIntent();

  static final activator = SingleActivator(
    LogicalKeyboardKey.keyC,
    meta: Platform.isMacOS,
    control: Platform.isWindows || Platform.isLinux,
    includeRepeats: false,
  );
}

class NavigateToCollectionPageAction
    extends ContextAction<NavigateToCollectionPageIntent> {
  @override
  void invoke(NavigateToCollectionPageIntent intent, [BuildContext? context]) {
    context?.goNamed(RouteConstants.collections);
  }
}
