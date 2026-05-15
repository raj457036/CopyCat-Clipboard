import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
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

  void finishOnboarding() {
    context.read<AppConfigCubit>().changeOnBoardStatus(true);
    context.read<AuthCubit>().setOnboardingCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return TitlebarView(
      hideLayoutToggle: true,
      hideTabToggle: true,
      hidePasteStackToggle: true,
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
                onContinue: finishOnboarding,
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
