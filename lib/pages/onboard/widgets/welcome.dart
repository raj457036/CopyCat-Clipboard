import 'package:animate_do/animate_do.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/pages/onboard/widgets/locale_and_logout.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';

class WelcomeStep extends StatelessWidget {
  final VoidCallback onContinue;

  const WelcomeStep({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return ZoomIn(
      child: FadeIn(
        delay: Durations.short2,
        child: Material(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Spacer(),
                Text(
                  context.locale.onboarding__text__welcome,
                  style: textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
                height10,
                Text(
                  context.locale.app__name,
                  style: textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
                height20,
                IconButton.filled(
                  onPressed: onContinue,
                  icon: const Icon(Icons.chevron_right),
                ),
                height10,
                Text(
                  context.locale.onboarding__text__lets_continue,
                  style: textTheme.labelLarge,
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                const LocaleAndLogoutRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
