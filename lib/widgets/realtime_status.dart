import 'dart:async';

import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:clipboard/base/l10n/generated/app_localizations.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/di/di.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RealTimeConnectionStatus extends StatefulWidget {
  final Widget child;
  const RealTimeConnectionStatus({super.key, required this.child});

  @override
  State<RealTimeConnectionStatus> createState() =>
      _RealTimeConnectionStatusState();
}

class _RealTimeConnectionStatusState extends State<RealTimeConnectionStatus> {
  late CrossSyncListenerStatus _status;
  StreamSubscription<CrossSyncStatusEvent>? _sub;

  @override
  void initState() {
    super.initState();
    final listener = sl<ClipCrossSyncListener>();
    _status = listener.currentStatus;
    _sub = listener.onStatusChange.listen((event) {
      if (mounted) setState(() => _status = event.$1);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  (Color, String) _badgeAppearance(
    CrossSyncListenerStatus status,
    AppLocalizations locale,
  ) => switch (status) {
    CrossSyncListenerStatus.connected => (
      Colors.green,
      locale.app__realtime_connected,
    ),
    CrossSyncListenerStatus.connecting => (
      Colors.orange,
      locale.app__realtime_connecting,
    ),
    _ => (Colors.red, locale.app__realtime_disconnected),
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return BlocSelector<AppConfigCubit, AppConfigState, bool>(
      selector: (state) =>
          state.config.syncSpeed == SyncSpeed.realtime &&
          state.config.enableSync,
      builder: (context, isRealTimeActive) {
        if (!isRealTimeActive) return widget.child;

        final (iconColor, tooltip) = _badgeAppearance(_status, context.locale);

        return Badge(
          offset: Offset.zero,
          label: Tooltip(
            message: tooltip,
            child: Icon(Icons.all_inclusive, color: iconColor, size: 16),
          ),
          backgroundColor: colors.surface,
          child: widget.child,
        );
      },
    );
  }
}
