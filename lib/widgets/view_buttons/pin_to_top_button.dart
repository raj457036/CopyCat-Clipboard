import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/window_action_cubit/window_action_cubit.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PinToTopButton extends StatelessWidget {
  const PinToTopButton({super.key});

  Future<void> toggle(BuildContext context, bool pinned) async {
    final appConfigCubit = context.read<AppConfigCubit>();
    final windowActionCubit = context.read<WindowActionCubit>();
    await appConfigCubit.setPinned(pinned);
    await windowActionCubit.alwaysOnTop(pinned);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return BlocSelector<AppConfigCubit, AppConfigState, bool>(
      selector: (state) {
        return state.config.pinned;
      },
      builder: (context, pinned) {
        return IconButton(
          onPressed: () => toggle(context, !pinned),
          padding: EdgeInsets.zero,
          style: IconButton.styleFrom(shape: const RoundedRectangleBorder()),
          color: pinned ? colors.error : colors.outlineVariant,
          iconSize: 20,
          icon: const Icon(Icons.push_pin_rounded),
          tooltip: pinned
              ? context.locale.view_button__unpin
              : context.locale.view_button__pin,
        );
      },
    );
  }
}
