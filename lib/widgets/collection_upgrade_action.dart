import 'package:clipboard/utils/monetization.dart';
import 'package:flutter/material.dart';

/// A [TextButton] that opens the paywall, used inside collection read-only
/// banners and prompts.
class CollectionUpgradeAction extends StatelessWidget {
  const CollectionUpgradeAction({super.key});

  @override
  Widget build(BuildContext context) {
    return const TextButton(onPressed: presentPaywall, child: Text('Upgrade'));
  }
}
