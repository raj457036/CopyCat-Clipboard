import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:clipboard/widgets/dialogs/confirm_dialog.dart';
import 'package:clipboard/widgets/dialogs/info_dialog.dart';
import 'package:copycat_base/common/failure.dart';
import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:copycat_base/utils/snackbar.dart';
import 'package:copycat_base/utils/utility.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';

class ExportEncryptionKeyStep extends StatefulWidget {
  final String exportableKeyId;
  final String exportableEnc2Key;
  final VoidCallback onContinue;
  final bool skipExportWarning;
  const ExportEncryptionKeyStep({
    super.key,
    required this.exportableKeyId,
    required this.exportableEnc2Key,
    required this.onContinue,
    this.skipExportWarning = false,
  });

  @override
  State<ExportEncryptionKeyStep> createState() =>
      _ExportEncryptionKeyStepState();
}

class _ExportEncryptionKeyStepState extends State<ExportEncryptionKeyStep> {
  bool exporting = false;
  bool exported = false;

  Future<void> exportEnc2Key() async {
    setState(() {
      exporting = true;
    });
    try {
      final locale = context.locale;
      final windowAction = context.windowAction;
      final json = {
        "enc2Id": widget.exportableKeyId,
        "enc2": widget.exportableEnc2Key,
      };
      final content = jsonEncode(json);

      final path = await FilePicker.platform.saveFile(
          fileName: "copycat-e2ee-vault-key.enc2",
          type: FileType.custom,
          allowedExtensions: ['enc2'],
          bytes: utf8.encode(content));
      await windowAction?.show();
      if (path != null) {
        exported = true;
        if (isDesktopPlatform) {
          await File(path).writeAsString(content);
        }
        showTextSnackbar(
          locale.onboarding__snackbar__export_success,
          success: true,
        );
      }
    } catch (e) {
      showFailureSnackbar(Failure.fromException(e));
    } finally {
      setState(() {
        exporting = false;
      });
    }
  }

  Future<void> doItLater() async {
    if (exported || widget.skipExportWarning) {
      widget.onContinue();
      return;
    }
    final answer = await ConfirmDialog(
      title: context.locale.onboarding__dialog__skip_export__title,
      message: context.locale.onboarding__dialog__skip_export__subtitle,
      confirmationDelay: 5,
    ).show(context);

    if (!answer) return;
    widget.onContinue();
  }

  Future<void> whyExportKey() async {
    await InfoDialog(
      title: context.locale.onboarding__dialog__export_info__title,
      message: context.locale.onboarding__dialog__export_info__subtitle,
    ).open(context);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return ZoomIn(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.lock,
              size: 28,
            ),
            height10,
            Text(
              context.locale.onboarding__text__export_key_headline,
              style: textTheme.headlineMedium,
            ),
            height16,
            if (exporting)
              const CircularProgressIndicator()
            else
              FadeIn(
                child: Column(
                  children: [
                    Text(
                      context.locale.onboarding__text__export_key_title,
                      textAlign: TextAlign.center,
                      style: textTheme.titleMedium,
                    ),
                    height16,
                    OverflowBar(
                      children: [
                        FilledButton.icon(
                          onPressed: exportEnc2Key,
                          label: Text(
                            context.locale.onboarding__button__export_key,
                          ),
                          icon: const Icon(Icons.key),
                        ),
                        width10,
                        TextButton(
                          onPressed: doItLater,
                          child: Text(
                            context.mlocale.continueButtonLabel.title,
                          ),
                        ),
                      ],
                    ),
                    height20,
                    TextButton.icon(
                      style: TextButton.styleFrom(),
                      onPressed: whyExportKey,
                      label: Text(
                        context.locale.onboarding__button__why_important,
                      ),
                      icon: const Icon(Icons.info),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
