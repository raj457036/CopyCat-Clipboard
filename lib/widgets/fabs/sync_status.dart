import 'package:animate_do/animate_do.dart';
import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/bloc/sync_status_cubit/sync_status_cubit.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/realtime_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SyncStatusFAB extends StatelessWidget {
  const SyncStatusFAB({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final syncStatusCubit = context.read<SyncStatusCubit>();

    return BlocSelector<AuthCubit, AuthState, bool>(
      selector: (state) => state is LocalAuthenticatedAuthState,
      builder: (context, isLocal) {
        if (isLocal) return const SizedBox.shrink();

        return BlocBuilder<SyncStatusCubit, SyncStatusState>(
          builder: (context, state) {
            bool disabled = false;
            IconData icon = Icons.sync_rounded;
            bool isSyncing = false;
            String message = context.locale.fab__sync;

            switch (state) {
              case SyncStatusUnknown():
                disabled = true;
                isSyncing = false;
                icon = Icons.sync_lock_rounded;
                message = context.locale.fab__sync_unavailable;
              case SyncingStatus():
                disabled = true;
                isSyncing = true;
              case SyncStatusComplete():
                disabled = false;
                isSyncing = false;
                icon = Icons.sync_rounded;
                message = context.locale.fab__sync_up_to_date;
              case SyncStatusFailed(:final failure):
                disabled = false;
                isSyncing = false;
                icon = Icons.sync_problem_rounded;
                message = context.locale.fab__sync_failed(
                  message: failure.message,
                );
            }

            return RealTimeConnectionStatus(
              child: FloatingActionButton.small(
                onPressed: disabled
                    ? null
                    : () => syncStatusCubit.syncAll(const SyncAllParams(force: true)),
                tooltip: isDesktopPlatform
                    ? '$message • ${keyboardShortcut(key: 'R')}'
                    : message,
                mouseCursor: SystemMouseCursors.click,
                heroTag: "sync-fab",
                backgroundColor: colors.secondary,
                foregroundColor: colors.onSecondary,
                child: Spin(
                  infinite: true,
                  delay: Durations.short4,
                  spins: -1,
                  curve: Curves.ease,
                  animate: isSyncing,
                  child: isSyncing ? const Icon(Icons.sync_rounded) : Icon(icon),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
