import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/sync_status_cubit/sync_status_cubit.dart';
import 'package:clipboard/base/bloc/user_devices_cubit/user_devices_cubit.dart';
import 'package:clipboard/base/bloc/user_devices_cubit/user_devices_state.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/base/sync/sync_orchestrator.dart';
import 'package:clipboard/di/di.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnableSyncSwitch extends StatelessWidget {
  const EnableSyncSwitch({super.key});

  Future<void> _toggleEnableSync(BuildContext context, bool enabled) async {
    final appConfigCubit = context.read<AppConfigCubit>();
    final syncStatusCubit = context.read<SyncStatusCubit>();
    final deviceCubit = context.read<UserDevicesCubit>();

    if (enabled) {
      if (deviceCubit.state.accessStatus == DeviceAccessStatus.allowed) {
        appConfigCubit.changeSync(enabled);
        await deviceCubit.setupSyncOrchestrator();
        syncStatusCubit.syncAll(const SyncAllParams());
      } else {
        appConfigCubit.changeSync(false);
        sl<SyncOrchestrator>().stop();
        sl<SyncStatusCubit>().markDisabled();
      }
    } else {
      appConfigCubit.changeSync(false);
      sl<SyncOrchestrator>().stop();
      sl<SyncStatusCubit>().markDisabled();
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
          secondary: const Icon(Icons.cloud_sync_rounded),
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
