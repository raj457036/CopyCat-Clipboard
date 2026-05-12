import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/monetization_cubit/monetization_cubit.dart';
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
      listenWhen: (prev, current) {
        if (current is MonetizationActive && prev is MonetizationActive) {
          return !current.subscription.isSameAs(prev.subscription);
        }
        return true;
      },
      listener: (context, state) async {
        state.whenOrNull(
          active: (appConfig) {
            appConfigCubit.load(appConfig);
          },
        );
      },
      child: child,
    );
  }
}
