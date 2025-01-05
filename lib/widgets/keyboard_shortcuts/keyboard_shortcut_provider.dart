import 'package:clipboard/widgets/keyboard_shortcuts.dart';
import 'package:copycat_base/bloc/window_action_cubit/window_action_cubit.dart';
import 'package:copycat_base/db/app_config/appconfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KeyboardShortcutProvider extends StatelessWidget {
  final Widget child;
  const KeyboardShortcutProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WindowActionCubit, WindowActionState, AppView>(
      selector: (state) => state.view,
      builder: (context, view) {
        return KeyboardShortcuts(
          shortcuts: const <ShortcutActivator, Intent>{},
          actions: const {},
          child: child,
        );
      },
    );
  }
}
