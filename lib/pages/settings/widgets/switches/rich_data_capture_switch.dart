import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/data/services/clipboard_service.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/di/di.dart';
import 'package:clipboard/widgets/badges.dart';
import 'package:clipboard/widgets/subscription/subscription_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RichDataCaptureSwitchTile extends StatelessWidget {
  const RichDataCaptureSwitchTile({super.key});

  void _setRichDataCapture(BuildContext context, bool enabled) {
    final appConfigCubit = context.read<AppConfigCubit>();
    appConfigCubit.toggleRichDataCapture(enabled);
    sl<ClipboardService>().setRichDataEnabled(enabled);
  }

  @override
  Widget build(BuildContext context) {
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
              secondary: const Icon(Icons.data_object_rounded),
              value: enabled && hasAccess,
              onChanged: hasAccess
                  ? (value) => _setRichDataCapture(context, value)
                  : null,
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
