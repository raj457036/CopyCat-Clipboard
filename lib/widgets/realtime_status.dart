import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/realtime_clip_sync_cubit/realtime_clip_sync_cubit.dart';
import 'package:clipboard/base/bloc/realtime_collection_sync_cubit/realtime_collection_sync_cubit.dart';
import 'package:clipboard/base/db/app_config/appconfig.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RealTimeConnectionStatus extends StatelessWidget {
  final Widget child;
  const RealTimeConnectionStatus({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Builder(
      builder: (context) {
        final isRealTimeActive =
            context.watch<AppConfigCubit>().state.config.syncSpeed ==
                SyncSpeed.realtime;
        final rtClip = context.watch<RealtimeClipSyncCubit>().state;
        final rtCollection = context.watch<RealtimeCollectionSyncCubit>().state;

        if (!isRealTimeActive) {
          return child;
        }

        Icon indicator = const Icon(Icons.all_inclusive);
        String message = context.locale.app__realtime_connecting;
        switch (rtClip) {
          case RealtimeClipSyncUnknown():
            indicator = const Icon(
              Icons.all_inclusive,
              size: 16,
            );
            message = context.locale.app__realtime_connecting;
          case RealtimeClipSyncConnecting():
            indicator = const Icon(
              Icons.all_inclusive,
              color: Colors.yellow,
              size: 16,
            );
            message = context.locale.app__realtime_connecting;
          case RealtimeClipSyncConnected():
            indicator = const Icon(
              Icons.all_inclusive,
              color: Colors.lightGreen,
              size: 16,
            );
            message = context.locale.app__realtime_connected;
          case RealtimeClipSyncDisconnected():
            indicator = const Icon(
              Icons.all_inclusive,
              color: Colors.red,
              size: 16,
            );
            message = context.locale.app__realtime_disconnected;
        }

        switch (rtCollection) {
          case RealtimeCollectionSyncUnknown():
            indicator = const Icon(Icons.all_inclusive, color: Colors.grey);
            message = context.locale.app__realtime_connecting;

          case RealtimeCollectionSyncConnecting():
            indicator = const Icon(
              Icons.all_inclusive,
              color: Colors.amber,
              size: 16,
            );
            message = context.locale.app__realtime_connecting;
          case RealtimeCollectionSyncConnected():
            indicator = const Icon(
              Icons.all_inclusive,
              color: Colors.green,
              size: 16,
            );
            message = context.locale.app__realtime_connected;
          case RealtimeCollectionSyncDisconnected():
            indicator = const Icon(
              Icons.all_inclusive,
              color: Colors.red,
              size: 16,
            );
            message = context.locale.app__realtime_disconnected;
        }

        return Badge(
          offset: Offset.zero,
          label: Tooltip(
            message: message,
            child: indicator,
          ),
          backgroundColor: colors.surface,
          child: child,
        );
      },
    );
  }
}
