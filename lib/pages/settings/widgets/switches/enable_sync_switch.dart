import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/monetization_cubit/monetization_cubit.dart';
import 'package:clipboard/base/bloc/sync_status_cubit/sync_status_cubit.dart';
import 'package:clipboard/base/constants/numbers/values.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/base/sync/sync_orchestrator.dart';
import 'package:clipboard/di/di.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnableSyncSwitch extends StatelessWidget {
  const EnableSyncSwitch({super.key});

  void _toggleEnableSync(BuildContext context, bool enabled) {
    final appConfigCubit = context.read<AppConfigCubit>();
    appConfigCubit.changeSync(enabled);

    final syncOrchestrator = sl<SyncOrchestrator>();
    final syncInterval =
        context.read<MonetizationCubit>().active?.syncInterval ??
        defaultBestEffortSyncInterval;

    if (enabled) {
      syncOrchestrator.start(
        syncSpeed: appConfigCubit.state.config.syncSpeed,
        intervalSeconds: syncInterval,
      );
      context.read<SyncStatusCubit>().syncAll(const SyncAllParams());
    } else {
      syncOrchestrator.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;
    return BlocSelector<AppConfigCubit, AppConfigState, bool>(
      selector: (state) {
        switch (state) {
          case AppConfigLoaded(:final config):
            return config.enableSync;
          default:
            return false;
        }
      },
      builder: (context, state) {
        return SwitchListTile(
          value: state,
          onChanged: (enabled) => _toggleEnableSync(context, enabled),
          title: Text(context.locale.settings__switch__enable_sync__title),
          subtitle: Text(
            context.locale.settings__switch__enable_sync__subtitle,
            style: textTheme.bodyMedium?.copyWith(color: colors.outline),
          ),
        );
      },
    );
  }
}
