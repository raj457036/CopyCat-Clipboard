import 'package:copycat_base/bloc/window_action_cubit/window_action_cubit.dart';
import 'package:copycat_base/constants/key.dart';
import 'package:copycat_base/constants/strings/strings.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:copycat_base/utils/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upgrader/upgrader.dart';

final upgrader = Upgrader(
  debugLogging: kDebugMode,
  languageCode: rootNavKey.currentContext?.locale.localeName,
  storeController: UpgraderStoreController(
    onMacOS: () => UpgraderAppcastStore(
      appcastURL: kDebugMode ? devMacAppcastUrl : macAppcastUrl,
    ),
    onWindows: () => UpgraderAppcastStore(
      appcastURL: kDebugMode ? devWindowsAppcastUrl : windowsAppcastUrl,
    ),
    onLinux: () => UpgraderAppcastStore(
      appcastURL: kDebugMode ? devLinuxAppcastUrl : linuxAppcastUrl,
    ),
  ),
  willDisplayUpgrade: ({
    required bool display,
    String? installedVersion,
    UpgraderVersionInfo? versionInfo,
  }) {
    final context = rootNavKey.currentContext;
    if (display && context != null && context.mounted && isDesktopPlatform) {
      context.read<WindowActionCubit>()
        ..setWindowdView()
        ..show();
    }
  },
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
      shouldPopScope: () => true,
      child: child,
    );
  }
}
