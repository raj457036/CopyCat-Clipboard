import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/badges.dart';
import 'package:clipboard/widgets/subscription/subscription_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DragAndDropSwitchTile extends StatelessWidget {
  const DragAndDropSwitchTile({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;
    return BlocSelector<AppConfigCubit, AppConfigState, bool>(
      selector: (state) {
        switch (state) {
          case AppConfigLoaded(:final config):
            return config.enableDragNDrop;
          default:
            return false;
        }
      },
      builder: (context, enabled) {
        return HasAccessToFeature(
          hasAccess: (subscription) =>
              subscription.isActive && subscription.dragNdrop,
          builder: (context, hasAccess, _) {
            return SwitchListTile(
              secondary: const Icon(Icons.back_hand_rounded),
              value: enabled,
              onChanged: hasAccess
                  ? context.read<AppConfigCubit>().toggleDragNDrop
                  : null,
              title: ProBadge(
                child: Text(
                  context.locale.settings__switch__drag_n_drop__title,
                ),
              ),
              subtitle: Text(
                context.locale.settings__switch__drag_n_drop__subtitle,
                style: textTheme.bodyMedium?.copyWith(color: colors.outline),
              ),
            );
          },
        );
      },
    );
  }
}
