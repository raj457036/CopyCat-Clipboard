import 'package:animate_do/animate_do.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/di/di.dart';
import 'package:clipboard/pages/settings/pages/android_bg_clipboard/android_bg_clipboard_settings.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';

class AndroidBackgroundClipboardStep extends StatelessWidget {
  final VoidCallback onContinue;
  const AndroidBackgroundClipboardStep({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return ZoomIn(
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: padding12),
              child: Text(
                context.locale.abc_title,
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Material(
                child: AndroidBgClipboardSettings(
                  bgService: sl(),
                  deviceId: sl(instanceName: "device_id"),
                  embedInParentScaffold: true,
                  minimalMode: true,
                ),
              ),
            ),
            height10,
            FilledButton(
              onPressed: onContinue,
              child: Text(context.mlocale.continueButtonLabel.title),
            ),
          ],
        ),
      ),
    );
  }
}
