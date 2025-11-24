import 'package:animate_do/animate_do.dart';
import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/pages/settings/widgets/switches/smart_paste_switch.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/loop_video_player.dart';
import 'package:flutter/material.dart';

class SmartPasteStep extends StatelessWidget {
  final VoidCallback onContinue;
  const SmartPasteStep({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return ZoomIn(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.switch_access_shortcut_add_rounded,
                size: 32,
              ),
              height10,
              Text(
                "Smart Paste",
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium,
              ),
              height10,
              const LoopVideoPlayer(
                width: 620,
                borderRadius: radius16,
                url: smartPasteDemoVideo,
              ),
              height10,
              const SizedBox(width: 620, child: SmartPasteSwitch()),
              height10,
              FilledButton(
                onPressed: onContinue,
                child: Text(
                  context.mlocale.continueButtonLabel.title,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
