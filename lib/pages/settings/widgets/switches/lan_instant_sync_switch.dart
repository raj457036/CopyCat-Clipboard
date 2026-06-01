import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/data/services/lan_sync_service.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/di/di.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/badges.dart';
import 'package:clipboard/widgets/subscription/subscription_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_io/io.dart';

class LanInstantSyncSwitchTile extends StatelessWidget {
  /// When false (Android background service not running), the tile and switch
  /// are disabled. Defaults to true so desktop usage requires no change.
  final bool serviceActive;

  const LanInstantSyncSwitchTile({super.key, this.serviceActive = true});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppConfigCubit>();
    final textTheme = context.textTheme;
    final colors = context.colors;

    return HasAccessToFeature(
      hasAccess: (subscription) =>
          subscription.isActive && !subscription.isFree,
      builder: (context, hasAccess, _) {
        return BlocSelector<AppConfigCubit, AppConfigState, bool>(
          selector: (state) {
            switch (state) {
              case AppConfigLoaded(:final config):
                return config.lanInstantSync;
              default:
                return false;
            }
          },
          builder: (context, enabled) {
            return ListTile(
              leading: const Icon(Icons.wifi_tethering_rounded),
              title: Row(
                spacing: 4,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(context.locale.settings__lan__title),
                  const ProBadge(),
                ],
              ),
              subtitle: serviceActive
                  ? _LanSubtitle(enabled: enabled && hasAccess)
                  : Text(context.locale.settings__lan__service_inactive),
              subtitleTextStyle: textTheme.bodyMedium?.copyWith(
                color: serviceActive ? colors.outline : colors.error,
              ),
              enabled: serviceActive && hasAccess,
              onTap: serviceActive && hasAccess && enabled
                  ? () => context.goNamed(RouteConstants.lanMesh)
                  : null,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (enabled) const VerticalDivider(),
                  Switch(
                    mouseCursor: (serviceActive && hasAccess)
                        ? SystemMouseCursors.click
                        : SystemMouseCursors.forbidden,
                    value: enabled && hasAccess,
                    onChanged: (serviceActive && hasAccess)
                        ? cubit.toggleLanInstantSync
                        : null,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _LanSubtitle extends StatelessWidget {
  final bool enabled;

  const _LanSubtitle({required this.enabled});

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return Text(context.locale.settings__lan__subtitle__disabled);
    }

    if (Platform.isAndroid || Platform.isIOS) {
      return Text(context.locale.settings__lan__subtitle__mobile);
    }

    final service = sl<LanSyncService>();
    return StreamBuilder<List<LanPeer>>(
      stream: service.peersStream,
      initialData: service.currentPeers,
      builder: (context, snapshot) {
        final count = snapshot.data?.length ?? 0;
        return Text(
          count == 0
              ? context.locale.settings__lan__searching
              : context.locale.settings__lan__devices_found(count: count),
        );
      },
    );
  }
}
