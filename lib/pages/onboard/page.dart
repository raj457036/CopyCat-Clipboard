import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/sync_status_cubit/sync_status_cubit.dart';
import 'package:clipboard/base/bloc/drive_setup_cubit/drive_setup_cubit.dart';
import 'package:clipboard/base/bloc/offline_persistance_cubit/offline_persistance_cubit.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/di/di.dart';
import 'package:clipboard/pages/onboard/widgets/encryption.dart';
import 'package:clipboard/pages/onboard/widgets/keyboard_shortcut.dart';
import 'package:clipboard/pages/onboard/widgets/smart_paste.dart';
import 'package:clipboard/pages/onboard/widgets/syncing/sync_restore_step.dart';
import 'package:clipboard/pages/onboard/widgets/welcome.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/titlebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OnBoardPage extends StatefulWidget {
  final int startingStep;

  const OnBoardPage({super.key, required this.startingStep});

  @override
  State<OnBoardPage> createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> {
  late int currentStep;

  @override
  void initState() {
    super.initState();
    currentStep = widget.startingStep;
  }

  void goToPage(int step) {
    setState(() {
      currentStep = step;
    });
  }

  void goHome() {
    context.read<DriveSetupCubit>().fetch();
    context.read<OfflinePersistenceCubit>().startListeners();
    // starts
    context.read<SyncStatusCubit>().start();
    context.read<AppConfigCubit>().changeOnBoardStatus(true);
    context.goNamed(RouteConstants.home);
  }

  @override
  Widget build(BuildContext context) {
    return TitlebarView(
      hideLayoutToggle: true,
      hideTabToggle: true,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(padding16),
            child: switch (currentStep) {
              0 => WelcomeStep(onContinue: () => goToPage(1)),
              1 => EncryptionStep(
                onContinue: () {
                  if (isDesktopPlatform) {
                    goToPage(2);
                  } else {
                    goToPage(4);
                  }
                },
              ),
              2 => SmartPasteStep(onContinue: () => goToPage(3)),
              3 => KeyboardShortcutStep(onContinue: () => goToPage(4)),
              4 => SyncRestoreStep(
                onContinue: goHome,
                clipboardRepository: sl(instanceName: "remote"),
                collectionRepository: sl(),
                restorationStatusRepository: sl(),
              ),
              _ => const SizedBox.shrink(),
            },
          ),
        ),
      ),
    );
  }
}
