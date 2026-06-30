import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/di/di.dart';
import 'package:clipboard/pages/onboard/widgets/android_background_clipboard.dart';
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
import 'package:universal_io/universal_io.dart';

class OnBoardPage extends StatefulWidget {
  final int startingStep;

  const OnBoardPage({super.key, required this.startingStep});

  @override
  State<OnBoardPage> createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> {
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    currentStep = widget.startingStep;
  }

  void goToPage(int step) {
    setState(() {
      currentStep = step;
    });
    context.go('/onboard?page=$step');
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
      child: Scaffold(
        body: SafeArea(
          child: switch (currentStep) {
            0 => Padding(
              padding: const EdgeInsets.all(padding16),
              child: WelcomeStep(onContinue: () => goToPage(1)),
            ),
            1 => Padding(
              padding: const EdgeInsets.all(padding16),

              child: EncryptionStep(
                onContinue: () {
                  if (Platform.isAndroid) {
                    goToPage(2);
                    return;
                  }

                  if (isDesktopPlatform) {
                    goToPage(3);
                  } else {
                    goToPage(5);
                  }
                },
              ),
            ),
            2 => AndroidBackgroundClipboardStep(onContinue: () => goToPage(5)),
            3 => Padding(
              padding: const EdgeInsets.all(padding16),
              child: SmartPasteStep(onContinue: () => goToPage(4)),
            ),
            4 => Padding(
              padding: const EdgeInsets.all(padding16),
              child: KeyboardShortcutStep(onContinue: () => goToPage(5)),
            ),
            5 => Padding(
              padding: const EdgeInsets.all(padding16),
              child: SyncRestoreStep(
                onContinue: finishOnboarding,
                clipboardRepository: sl(instanceName: "remote"),
                collectionRepository: sl(),
                restorationStatusRepository: sl(),
              ),
            ),
            _ => const SizedBox.shrink(),
          },
        ),
      ),
    );
  }
}
