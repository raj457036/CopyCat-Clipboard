import 'package:clipboard/base/bloc/event_bus_cubit/event_bus_cubit.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_io/io.dart';

class FocusOnSearchFieldIntent extends Intent {
  const FocusOnSearchFieldIntent();

  static final activator = SingleActivator(
    LogicalKeyboardKey.keyF,
    meta: Platform.isMacOS,
    control: Platform.isWindows || Platform.isLinux,
    includeRepeats: false,
  );
}

class FocusOnSearchFieldAction extends ContextAction<FocusOnSearchFieldIntent> {
  @override
  void invoke(FocusOnSearchFieldIntent intent, [BuildContext? context]) {
    context?.goNamed(RouteConstants.home);
    context?.read<EventBusCubit>().keyboard("search");
  }
}
