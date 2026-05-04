import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/badges.dart';
import 'package:clipboard/widgets/subscription/subscription_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TypeToSearchSwitch extends StatelessWidget {
  const TypeToSearchSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;

    return BlocSelector<AppConfigCubit, AppConfigState, bool>(
      selector: (state) {
        switch (state) {
          case AppConfigLoaded(:final config):
            return config.enableTypeToSearch;
          default:
            return false;
        }
      },
      builder: (context, enabled) {
        return HasAccessToFeature(
          hasAccess: (subscription) =>
              subscription.isActive && !subscription.isFree,
          builder: (context, hasAccess, _) {
            return SwitchListTile(
              value: enabled,
              onChanged: hasAccess
                  ? context.read<AppConfigCubit>().toggleTypeToSearch
                  : null,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(context.locale.settings__switch__type_search__title),
                  width8,
                  const ProBadge(),
                ],
              ),
              subtitle: Text(
                context.locale.settings__switch__type_search__subtitle,
                style: textTheme.bodyMedium?.copyWith(color: colors.outline),
              ),
            );
          },
        );
      },
    );
  }
}
