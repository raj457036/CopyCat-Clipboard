import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/widgets/badges.dart';
import 'package:clipboard/widgets/subscription/subscription_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AutoWriteOnReceiveSwitchTile extends StatelessWidget {
  final bool enabled;
  final Function(bool)? onChanged;

  const AutoWriteOnReceiveSwitchTile({
    super.key,
    this.enabled = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppConfigCubit>();
    return HasAccessToFeature(
      hasAccess: (subscription) =>
          subscription.isActive && !subscription.isFree,
      builder: (context, hasAccess, _) {
        return BlocSelector<AppConfigCubit, AppConfigState, bool>(
          selector: (state) => state is AppConfigLoaded
              ? state.config.autoWriteOnReceive
              : false,
          builder: (context, value) {
            return SwitchListTile(
              secondary: const Icon(Icons.auto_fix_high_rounded),
              title: Row(
                spacing: 8,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(context.locale.settings__auto_write__title),
                  const ProBadge(),
                ],
              ),
              subtitle: Text(context.locale.settings__auto_write__subtitle),
              value: value && hasAccess,
              onChanged: (enabled && hasAccess)
                  ? (val) {
                      cubit.toggleAutoWriteOnReceive(val);
                      onChanged?.call(val);
                    }
                  : null,
            );
          },
        );
      },
    );
  }
}
