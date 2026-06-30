import 'package:animate_do/animate_do.dart';
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
      duration: Durations.short2,
      child: Scaffold(
        appBar: AppBar(title: Text(context.locale.abc_title)),
        body: AndroidBgClipboardSettings(
          bgService: sl(),
          deviceId: sl(instanceName: "device_id"),
          liteMode: true,
        ),
        bottomNavigationBar: BottomAppBar(
          child: Center(
            child: FilledButton(
              onPressed: onContinue,
              child: Text(context.mlocale.continueButtonLabel.title),
            ),
          ),
        ),
      ),
    );
  }
}
