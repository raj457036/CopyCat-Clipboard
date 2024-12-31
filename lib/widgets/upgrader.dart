import 'package:copycat_base/constants/key.dart';
import 'package:copycat_base/constants/strings/strings.dart';
import 'package:copycat_base/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

final upgrader = Upgrader(
  storeController: UpgraderStoreController(
    onMacOS: () => UpgraderAppcastStore(appcastURL: macAppcastUrl),
    onWindows: () => UpgraderAppcastStore(appcastURL: windowsAppcastUrl),
    onLinux: () => UpgraderAppcastStore(appcastURL: linuxAppcastUrl),
  ),
);

class UpgraderBuilder extends StatelessWidget {
  final Widget? child;
  const UpgraderBuilder({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      navigatorKey: rootNavKey,
      upgrader: upgrader,
      showIgnore: false,
      shouldPopScope: () => true,
      dialogStyle: isApplePlatform
          ? UpgradeDialogStyle.cupertino
          : UpgradeDialogStyle.material,
      child: child,
    );
  }
}
