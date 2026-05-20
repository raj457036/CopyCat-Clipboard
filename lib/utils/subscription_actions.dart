import 'package:clipboard/routes/routes.dart';
import 'package:clipboard/widgets/dialogs/subscription_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Utility function to show the subscription dialog.
Future<void> showUpgradePlanDialog() async {
  final context = rootNavigationKey.currentContext!;
  SubscriptionInfoDialog(
    monetizationCubit: context.read(),
    entitlementGrantMode: false,
  ).open(context);
}
