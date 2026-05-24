import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/monetization_cubit/monetization_cubit.dart';
import 'package:clipboard/base/constants/numbers/duration.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/base/sync/sync_orchestrator.dart';
import 'package:clipboard/di/di.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/badges.dart';
import 'package:clipboard/widgets/settings_menu_dropdown.dart';
import 'package:clipboard/widgets/subscription/subscription_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SyncModeDropdown extends StatelessWidget {
  const SyncModeDropdown({super.key});

  void _setSyncMode(BuildContext context, SyncSpeed speed) {
    final appConfigCubit = context.read<AppConfigCubit>();
    final monetizationCubit = context.read<MonetizationCubit>();
    appConfigCubit.changeSyncMode(speed);

    // NOTE(raj): This condition is always false since the dropdown is
    // disabled when sync is not enabled. This is just a reminder to
    // not change the ochestrator's state when sync is disabled.
    if (!appConfigCubit.state.config.enableSync) return;

    final syncSpeed = appConfigCubit.state.config.syncSpeed;
    final syncInterval = monetizationCubit.state.whenOrNull(
      active: (s) => s.syncInterval,
    );

    switch (syncSpeed) {
      case SyncSpeed.realtime:
        sl<SyncOrchestrator>().start(
          syncSpeed: SyncSpeed.realtime,
          intervalSeconds: syncInterval,
        );
      case SyncSpeed.balanced:
        sl<SyncOrchestrator>().start(
          syncSpeed: SyncSpeed.balanced,
          intervalSeconds: syncInterval,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;
    return HasAccessToFeature(
      hasAccess: (subscription) => subscription.syncInterval < $10S,
      builder: (context, hasAccess, _) {
        return BlocSelector<AppConfigCubit, AppConfigState, (SyncSpeed, bool)>(
          selector: (state) {
            switch (state) {
              case AppConfigLoaded(:final config):
                return (config.syncSpeed, config.enableSync);
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
                style: textTheme.bodyMedium?.copyWith(color: colors.outline),
              ),
              trailing: SettingsMenuDropdown<SyncSpeed>(
                value: speed,
                maxWidth: 190,
                items: [
                  SettingsDropdownItem(
                    value: SyncSpeed.realtime,
                    enabled: hasAccess,
                  ),
                  const SettingsDropdownItem(value: SyncSpeed.balanced),
                ],
                itemBuilder: (context, value) {
                  return switch (value) {
                    SyncSpeed.realtime => (
                      leading: null,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(context.locale.settings__sync_mode__realtime),
                          width8,
                          const ProBadge(),
                        ],
                      ),
                      trailing: null,
                    ),
                    SyncSpeed.balanced => (
                      leading: null,
                      child: Text(context.locale.settings__sync_mode__balanced),
                      trailing: null,
                    ),
                  };
                },
                onSelected: enabled
                    ? (speed) => _setSyncMode(context, speed)
                    : null,
              ),
            );
          },
        );
      },
    );
  }
}
