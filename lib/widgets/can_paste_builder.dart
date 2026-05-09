import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CanPasteScope extends InheritedWidget {
  final bool canPaste;

  const CanPasteScope({
    super.key,
    required this.canPaste,
    required super.child,
  });

  static bool of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CanPasteScope>();
    return scope?.canPaste ?? false;
  }

  @override
  bool updateShouldNotify(CanPasteScope oldWidget) {
    return canPaste != oldWidget.canPaste;
  }
}

typedef CanPasteBuilderWidget =
    Widget Function(BuildContext context, bool canPaste);

class CanPasteBuilder extends StatelessWidget {
  final CanPasteBuilderWidget builder;
  const CanPasteBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AppConfigCubit, AppConfigState, bool>(
      selector: (state) {
        return state.config.lastFocusedWindowId != null &&
            state.config.smartPaste;
      },
      builder: (context, canPaste) {
        return CanPasteScope(
          canPaste: canPaste,
          child: builder(context, canPaste),
        );
      },
    );
  }
}
