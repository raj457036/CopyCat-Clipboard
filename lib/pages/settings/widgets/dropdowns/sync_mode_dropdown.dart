import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/constants/numbers/duration.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/db/app_config/appconfig.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/badges.dart';
import 'package:clipboard/widgets/subscription/subscription_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SyncModeDropdown extends StatelessWidget {
  const SyncModeDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;
    final cubit = context.read<AppConfigCubit>();
    return SubscriptionBuilder(
      builder: (context, subscription) {
        return BlocSelector<AppConfigCubit, AppConfigState, (SyncSpeed, bool)>(
          selector: (state) {
            switch (state) {
              case AppConfigLoaded(:final config):
                return (
                  config.syncSpeed,
                  config.enableSync,
                );
              default:
                return (SyncSpeed.balanced, false);
            }
          },
          builder: (context, state) {
            final (speed, enabled) = state;
            return ListTile(
              enabled: enabled,
              title: Text(context.locale.settings__dropdown__sync_mode__title),
              subtitle: Text(
                context.locale.settings__dropdown__sync_mode__subtitle,
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.outline,
                ),
              ),
              trailing: DropdownButtonHideUnderline(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 185),
                  child: DropdownButton<SyncSpeed>(
                    value: speed,
                    isExpanded: true,
                    padding: const EdgeInsets.symmetric(horizontal: padding16),
                    borderRadius: radius26,
                    items: [
                      if (subscription != null)
                        DropdownMenuItem(
                          enabled: subscription.syncInterval < $10S,
                          value: SyncSpeed.realtime,
                          child: Row(
                            spacing: 8,
                            children: [
                              Text(
                                context.locale.settings__sync_mode__realtime,
                              ),
                              const ProBadge(),
                            ],
                          ),
                        ),
                      DropdownMenuItem(
                        value: SyncSpeed.balanced,
                        child: Text(
                          context.locale.settings__sync_mode__balanced,
                        ),
                      ),
                    ],
                    onChanged: enabled ? cubit.changeSyncMode : null,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
