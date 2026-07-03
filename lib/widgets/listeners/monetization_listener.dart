import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/monetization_cubit/monetization_cubit.dart';
import 'package:clipboard/base/bloc/user_devices_cubit/user_devices_cubit.dart';
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
            await appConfigCubit.load(subscription);
            final accessStatus = await deviceCubit.registerCurrentDevice();
            await deviceCubit.setupSyncOrchestrator(
              accessStatus: accessStatus,
              subscription: subscription,
              syncInterval: subscription.syncInterval,
            );
          },
        );
      },
      child: child,
    );
  }
}
