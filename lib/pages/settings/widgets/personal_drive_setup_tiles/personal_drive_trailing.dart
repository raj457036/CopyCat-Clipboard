import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/yarn_ball_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonalDriveTrailing extends StatelessWidget {
  final bool isLoading;
  final bool isConnected;
  final ActiveCloudStorageProvider provider;
  final Widget? pendingAction;

  const PersonalDriveTrailing({
    super.key,
    required this.isLoading,
    required this.isConnected,
    required this.provider,
    this.pendingAction,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const YarnBallLoading(size: 20);
    }

    if (pendingAction != null) {
      return pendingAction!;
    }

    if (!isConnected) {
      return const SizedBox.shrink();
    }

    return BlocSelector<AppConfigCubit, AppConfigState, bool>(
      selector: (appState) =>
          appState.config.activeStorageProvider == provider,
      builder: (context, isDefault) {
        if (isDefault) {
          return Tooltip(
            message: context.locale.settings__drive__default_tooltip,
            child: Icon(
              Icons.check_circle_rounded,
              color: context.colors.primary,
            ),
          );
        }

        return TextButton(
          style: TextButton.styleFrom(
            visualDensity: VisualDensity.compact,
          ),
          onPressed: () {
            context.read<AppConfigCubit>().changeActiveStorageProvider(
              provider,
            );
          },
          child: Text(context.locale.settings__drive__set_default),
        );
      },
    );
  }
}
