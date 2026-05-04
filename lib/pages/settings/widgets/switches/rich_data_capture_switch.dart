import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/widgets/badges.dart';
import 'package:clipboard/widgets/subscription/subscription_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RichDataCaptureSwitchTile extends StatelessWidget {
  const RichDataCaptureSwitchTile({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppConfigCubit>();
    return HasAccessToFeature(
      hasAccess: (subscription) =>
          subscription.isActive && !subscription.isFree,
      builder: (context, hasAccess, _) {
        return BlocSelector<AppConfigCubit, AppConfigState, bool>(
          selector: (state) {
            switch (state) {
              case AppConfigLoaded(:final config):
                return config.richDataCapture;
              default:
                return false;
            }
          },
          builder: (context, enabled) {
            return SwitchListTile(
              value: enabled && hasAccess,
              onChanged: hasAccess ? cubit.toggleRichDataCapture : null,
              title: Row(
                spacing: padding8,
                children: [
                  Text(
                    context.locale.settings__switch__rich_data_capture__title,
                  ),
                  const ProBadge(),
                ],
              ),
              subtitle: Text(
                context.locale.settings__switch__rich_data_capture__subtitle,
              ),
            );
          },
        );
      },
    );
  }
}
