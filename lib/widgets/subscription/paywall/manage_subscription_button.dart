import 'package:clipboard/base/bloc/monetization_cubit/monetization_cubit.dart';
import 'package:clipboard/base/data/services/notification_service.dart'
    show InAppNotificationService;
import 'package:clipboard/base/domain/model/notification_message.dart'
    show NotificationMessage;
import 'package:clipboard/base/domain/model/subscription/subscription.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/datetime_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ManageSubscriptionButton extends StatelessWidget {
  const ManageSubscriptionButton({super.key});

  Future<void> manageSubscription(
    BuildContext context,
    Subscription subscription,
  ) async {
    if (subscription.managementUrl != null) {
      launchUrlString(subscription.managementUrl!);
      return;
    }
    if (subscription.source == "PROMO") {
      final till = dateTimeFormatter(
        context.locale.localeName,
      ).format(subscription.activeTill!);

      InAppNotificationService.i.notify(
        NotificationMessage(
          id: "promo_code_applied",
          body: context.locale.manage_sub__ack__promo_sub(till: till),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MonetizationCubit, MonetizationState>(
      builder: (context, state) {
        return state.when(
          unknown: () => const SizedBox.shrink(),
          active: (sub) {
            return ElevatedButton(
              onPressed: () => manageSubscription(context, sub),
              child: Text(context.locale.manage_sub__button__text),
            );
          },
        );
      },
    );
  }
}
