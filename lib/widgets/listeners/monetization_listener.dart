import 'dart:async';

import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/monetization_cubit/monetization_cubit.dart';
import 'package:clipboard/base/bloc/user_devices_cubit/user_devices_cubit.dart';
import 'package:clipboard/base/data/services/notification_service.dart';
import 'package:clipboard/base/domain/model/notification_message.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/logging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MonetizationListener extends StatelessWidget {
  final AppConfigCubit appConfigCubit;
  final Widget child;

  const MonetizationListener({
    super.key,
    required this.appConfigCubit,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<MonetizationCubit, MonetizationState>(
      listener: (context, state) async {
        state.whenOrNull(
          active: (subscription) async {
            final deviceCubit = context.read<UserDevicesCubit>();
            try {
              await appConfigCubit.load(subscription);
              unawaited(deviceCubit.fetchDevices());
              await deviceCubit.registerCurrentDevice();
              await deviceCubit.setupSyncOrchestrator();
            } catch (e, stack) {
              logger.e('Sync startup failed', error: e, stackTrace: stack);
              InAppNotificationService.i.notify(
                NotificationMessage(
                  id: 'sync-startup-failed',
                  body: Failure.fromException(e).message,
                ),
              );
            }
          },
        );
      },
      child: child,
    );
  }
}
