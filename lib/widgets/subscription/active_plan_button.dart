import 'package:clipboard/base/bloc/monetization_cubit/monetization_cubit.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/dialogs/subscription_info.dart';
import 'package:clipboard/widgets/local_user.dart';
import 'package:clipboard/widgets/subscription/subscription_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivePlanButton extends StatelessWidget {
  final bool plain;
  const ActivePlanButton({super.key, this.plain = false});

  Future<void> action(
    BuildContext context, {
    bool entitlementGrantMode = false,
  }) async {
    SubscriptionInfoDialog(
      monetizationCubit: context.read<MonetizationCubit>(),
      entitlementGrantMode: entitlementGrantMode,
    ).open(context);
  }

  @override
  Widget build(BuildContext context) {
    return DisableForLocalUser(
      child: SubscriptionBuilder(
        builder: (context, subscription) {
          String label = context.locale.paywall_dialog__text__upgrade;

          if (subscription != null && !subscription.isFree) {
            label = subscription.planName;
          }

          Widget button;
          if (plain) {
            button = TextButton(
              onPressed: () => action(context),
              child: Text(label),
            );
          } else {
            button = ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: context.colors.onPrimary,
              ),
              onPressed: () => action(context),
              onLongPress: () => action(context, entitlementGrantMode: true),
              icon: const Icon(Icons.loyalty_rounded),
              label: Text(label),
            );
          }
          return ExcludeFocus(child: button);
        },
      ),
    );
  }
}
