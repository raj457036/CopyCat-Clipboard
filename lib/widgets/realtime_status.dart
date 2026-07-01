import 'package:flutter/material.dart';
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RealTimeConnectionStatus extends StatelessWidget {
  final Widget child;
  const RealTimeConnectionStatus({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Builder(
      builder: (context) {
        final isRealTimeActive =
            context.watch<AppConfigCubit>().state.config.syncSpeed ==
            SyncSpeed.realtime;

        if (!isRealTimeActive) {
          return child;
        }

        return Badge(
          offset: Offset.zero,
          label: Tooltip(
            message: context.locale.app__realtime_connected,
            child: const Icon(
              Icons.all_inclusive,
              color: Colors.green,
              size: 16,
            ),
          ),
          backgroundColor: colors.surface,
          child: child,
        );
      },
    );
  }
}
