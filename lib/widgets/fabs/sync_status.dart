import 'package:animate_do/animate_do.dart';
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/bloc/sync_status_cubit/sync_status_cubit.dart';
import 'package:clipboard/base/bloc/user_devices_cubit/user_devices_cubit.dart';
import 'package:clipboard/base/bloc/user_devices_cubit/user_devices_state.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/realtime_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SyncStatusFAB extends StatelessWidget {
  const SyncStatusFAB({super.key});

  void _triggerManualSync(BuildContext context) {
    context.read<SyncStatusCubit>().syncAll(const SyncAllParams(force: true));
  }

  _SyncFabPresentation _resolvePresentation(
    BuildContext context,
    SyncStatusState syncState,
    bool syncEligible,
  ) {
    if (!syncEligible) {
      return _SyncFabPresentation(
        disabled: true,
        isSyncing: false,
        icon: Icons.sync_disabled_rounded,
        message: context.locale.fab__sync_unavailable,
      );
    }

    return switch (syncState) {
      SyncStatusUnknown() || SyncStatusDisabled() => _SyncFabPresentation(
        disabled: false,
        isSyncing: false,
        icon: Icons.cloud_rounded,
        message: context.locale.fab__sync,
      ),
      SyncingStatus() || SyncStatusDecrypting() => _SyncFabPresentation(
        disabled: true,
        isSyncing: true,
        icon: Icons.cloud_rounded,
        message: context.locale.app__syncing,
      ),
      SyncStatusComplete() => _SyncFabPresentation(
        disabled: false,
        isSyncing: false,
        icon: Icons.cloud_done_rounded,
        message: context.locale.fab__sync_up_to_date,
      ),
      SyncStatusFailed(:final failure) => _SyncFabPresentation(
        disabled: false,
        isSyncing: false,
        icon: Icons.sync_problem_rounded,
        message: context.locale.fab__sync_failed(message: failure.message),
      ),
      _ => _SyncFabPresentation(
        disabled: false,
        isSyncing: false,
        icon: Icons.cloud_rounded,
        message: context.locale.fab__sync,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocSelector<AuthCubit, AuthState, bool>(
      selector: (state) => state is LocalAuthenticatedAuthState,
      builder: (context, isLocal) {
        if (isLocal) return const SizedBox.shrink();

        final syncEnabled = context.select(
          (AppConfigCubit cubit) => cubit.state.config.enableSync,
        );
        final deviceAccessAllowed = context.select(
          (UserDevicesCubit cubit) =>
              cubit.state.accessStatus == DeviceAccessStatus.allowed,
        );
        final syncState = context.select(
          (SyncStatusCubit cubit) => cubit.state,
        );
        final presentation = _resolvePresentation(
          context,
          syncState,
          syncEnabled && deviceAccessAllowed,
        );

        return RealTimeConnectionStatus(
          child: FloatingActionButton.small(
            onPressed: presentation.disabled
                ? null
                : () => _triggerManualSync(context),
            tooltip: isDesktopPlatform
                ? '${presentation.message} • ${keyboardShortcut(key: 'R')}'
                : presentation.message,
            mouseCursor: SystemMouseCursors.click,
            heroTag: "sync-fab",
            backgroundColor: colors.secondary,
            foregroundColor: colors.onSecondary,
            child: presentation.isSyncing
                ? const Flash(
                    delay: Durations.medium4,
                    duration: Duration(seconds: 12),
                    child: Icon(Icons.cloud),
                  )
                : Icon(presentation.icon),
          ),
        );
      },
    );
  }
}

class _SyncFabPresentation {
  final bool disabled;
  final bool isSyncing;
  final IconData icon;
  final String message;

  const _SyncFabPresentation({
    required this.disabled,
    required this.isSyncing,
    required this.icon,
    required this.message,
  });
}
