import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universal_io/io.dart';

class LanInstantSyncSwitchTile extends StatelessWidget {
  const LanInstantSyncSwitchTile({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppConfigCubit>();
    return BlocSelector<
      AppConfigCubit,
      AppConfigState,
      ({bool lanInstantSync, bool lanAutoWrite})
    >(
      selector: (state) {
        switch (state) {
          case AppConfigLoaded(:final config):
            return (
              lanInstantSync: config.lanInstantSync,
              lanAutoWrite: config.lanAutoWrite,
            );
          default:
            return (lanInstantSync: false, lanAutoWrite: false);
        }
      },
      builder: (context, cfg) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              value: cfg.lanInstantSync,
              onChanged: cubit.toggleLanInstantSync,
              title: const Text('LAN Instant Sync'),
              subtitle: const Text(
                'Sync clipboard instantly with devices on the same network.',
              ),
            ),
            if (cfg.lanInstantSync && !Platform.isAndroid)
              SwitchListTile(
                value: cfg.lanAutoWrite,
                onChanged: cubit.toggleLanAutoWrite,
                title: const Text('Auto-write received clips'),
                subtitle: const Text(
                  'Automatically write clips received via LAN to the system clipboard.',
                ),
              ),
          ],
        );
      },
    );
  }
}
