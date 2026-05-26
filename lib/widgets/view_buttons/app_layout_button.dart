import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/app_layout_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppLayoutToggleButton extends StatelessWidget {
  final bool compact;
  const AppLayoutToggleButton({super.key, this.compact = false});

  void changeLayout(BuildContext context, AppLayout layout) {
    context.read<AppConfigCubit>().changeAppLayout(layout);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AppLayoutBuilder(
      builder: (context, layoutView, supported) {
        if (!supported) return const SizedBox.shrink();
        return IconButton(
          onPressed: () {
            switch (layoutView.layout) {
              case AppLayout.grid:
                changeLayout(context, AppLayout.list);
              case AppLayout.list:
                changeLayout(context, AppLayout.grid);
            }
          },

          style: IconButton.styleFrom(
            shape: compact ? const RoundedRectangleBorder() : null,
            backgroundColor: compact ? null : colors.surfaceContainerHighest,
            maximumSize: compact ? null : const Size.square(kToolbarHeight),
            padding: compact
                ? EdgeInsets.zero
                : const EdgeInsets.all(padding10),
          ),
          iconSize: compact ? 20 : null,
          icon: layoutView.layout == AppLayout.grid
              ? const Icon(Icons.view_agenda_rounded)
              : const Icon(Icons.grid_view_rounded),
          tooltip: layoutView.layout == AppLayout.grid
              ? context.locale.view_button__switch_to_list
              : context.locale.view_button__switch_to_grid,
        );
      },
    );
  }
}
