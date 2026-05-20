import 'package:clipboard/utils/subscription_actions.dart';
import 'package:flutter/material.dart';

/// A [TextButton] that opens the paywall, used inside collection read-only
/// banners and prompts.
class CollectionUpgradeAction extends StatelessWidget {
  const CollectionUpgradeAction({super.key});

  @override
  Widget build(BuildContext context) {
    return const TextButton(
      onPressed: showUpgradePlanDialog,
      child: Text('Upgrade'),
    );
  }
}
