import 'package:clipboard/base/bloc/monetization_cubit/monetization_cubit.dart';
import 'package:clipboard/widgets/dialogs/subscription_info.dart';
import 'package:clipboard/widgets/local_user.dart';
import 'package:clipboard/widgets/subscription/subscription_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActivePlanButton extends StatelessWidget {
  const ActivePlanButton({super.key});

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
          String label = subscription?.planName ?? "Free";
          return Focus(
            skipTraversal: true,
            descendantsAreFocusable: false,
            child: ElevatedButton.icon(
              onPressed: () => action(context),
              onLongPress: () => action(context, entitlementGrantMode: true),
              icon: const Icon(Icons.loyalty_rounded),
              label: Text(label),
            ),
          );
        },
      ),
    );
  }
}
