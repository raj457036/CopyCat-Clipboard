import 'package:clipboard/base/bloc/paste_stack_cubit/paste_stack_cubit.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    context.read<PasteStackCubit>().toggle();
  }
}
