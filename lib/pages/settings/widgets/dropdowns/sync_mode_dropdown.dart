import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/subscription/subscription_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SyncModeTile extends StatelessWidget {
  const SyncModeTile({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;
    return BlocSelector<AppConfigCubit, AppConfigState, bool>(
      selector: (state) {
        return state.maybeWhen(
          loaded: (config, _, _) => config.enableSync,
          orElse: () => false,
        );
      },
      builder: (context, enabled) {
        return SubscriptionBuilder(
          builder: (context, subscription) {
            final isProSync =
                subscription != null &&
                subscription.isActive &&
                !subscription.isFree;
            final speed = isProSync ? SyncSpeed.realtime : SyncSpeed.balanced;
            final speedLabel = switch (speed) {
              SyncSpeed.realtime =>
                context.locale.settings__sync_mode__realtime,
              SyncSpeed.balanced =>
                context.locale.settings__sync_mode__balanced,
            };
            final speedColor = switch (speed) {
              SyncSpeed.realtime => colors.onPrimaryContainer,
              SyncSpeed.balanced => colors.onSurfaceVariant,
            };
            final speedBackground = switch (speed) {
              SyncSpeed.realtime => colors.primaryContainer,
              SyncSpeed.balanced => colors.surfaceContainerHighest,
            };
            final speedIcon = switch (speed) {
              SyncSpeed.realtime => Icons.all_inclusive_rounded,
              SyncSpeed.balanced => Icons.sync_rounded,
            };

            return ListTile(
              leading: const Icon(Icons.sync_alt_rounded),
              enabled: enabled,
              title: Text(context.locale.settings__dropdown__sync_mode__title),
              trailing: Chip(
                shape: const StadiumBorder(),
                side: BorderSide(color: speedBackground),
                backgroundColor: speedBackground,
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(speedIcon, size: 14, color: speedColor),
                    width6,
                    Text(
                      speedLabel,
                      style: textTheme.labelMedium?.copyWith(color: speedColor),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
