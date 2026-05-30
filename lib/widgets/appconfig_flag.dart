import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart'
    show AppConfig;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef AppConfigFlagBuilder = Widget Function(BuildContext context);
typedef AppConfigFlagTest = bool Function(AppConfig config);

/// A widget that conditionally builds based on a test on the AppConfig.
/// If the test returns false, it shows the [child] widget or nothing if [child] is not provided.
class AppConfigBuilder extends StatelessWidget {
  final AppConfigFlagTest when;
  final AppConfigFlagBuilder builder;
  final Widget? child;

  const AppConfigBuilder({
    super.key,
    required this.when,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AppConfigCubit, AppConfigState, bool>(
      selector: (state) => when(state.config),
      builder: (context, isEnabled) {
        if (!isEnabled) return child ?? const SizedBox.shrink();
        return builder(context);
      },
    );
  }
}
