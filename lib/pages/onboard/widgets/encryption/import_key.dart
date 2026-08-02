import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/data/services/e2ee_qr_transfer_service.dart';
import 'package:clipboard/base/data/services/notification_service.dart'
    show InAppNotificationService;
import 'package:clipboard/base/domain/model/notification_message.dart'
    show NotificationMessage;
import 'package:clipboard/base/domain/repositories/clipboard.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/pages/onboard/widgets/locale_and_logout.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/dialogs/confirm_dialog.dart';
import 'package:clipboard/widgets/dialogs/e2ee_dialogs/e2ee_passcode_prompt_dialog.dart';
import 'package:clipboard/widgets/dialogs/e2ee_dialogs/e2ee_qr_scan_action_button.dart';
import 'package:clipboard/widgets/dialogs/info_dialog.dart';
import 'package:clipboard/widgets/dialogs/e2ee_dialogs/scan_qr_e2ee.dart';
import 'package:clipboard/widgets/yarn_ball_loading.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImportEncryptionKeyStep extends StatefulWidget {
  final String importableKeyId;
  final ClipboardRepository clipboardRepository;
  final VoidCallback onContinue;
  final VoidCallback onImportSuccess;
  const ImportEncryptionKeyStep({
    super.key,
    required this.importableKeyId,
    required this.clipboardRepository,
    required this.onContinue,
    required this.onImportSuccess,
  });

  @override
  State<ImportEncryptionKeyStep> createState() =>
      _ImportEncryptionKeyStepState();
}

class _ImportEncryptionKeyStepState extends State<ImportEncryptionKeyStep> {
  late final AuthCubit authCubit;
  late final AppConfigCubit appConfigCubit;

  bool importing = false;
  bool saving = false;
  String? importedKey;

  @override
  void initState() {
    super.initState();
    authCubit = context.read();
    appConfigCubit = context.read();
  }

  Future<void> importEnc2Key() async {
    setState(() {
      importing = true;
    });
    final windowAction = context.windowAction;
    final locale = context.locale;
    await wait(100);
    try {
      final pickedFile = await FilePicker.pickFiles(
        type: isDesktopPlatform ? FileType.custom : FileType.any,
        allowedExtensions: isDesktopPlatform ? ['enc2'] : null,
        withData: true,
      );

      await windowAction?.show();

      if (pickedFile == null) return;
      if (pickedFile.files.first.bytes == null) return;
      final content = utf8.decode(pickedFile.files.first.bytes!);
      final secret = E2EEQrTransferService.decodeKeyFile(content);
      importedKey = secret?.enc2;

      if (secret == null || secret.enc2Id != widget.importableKeyId) {
        importedKey = null;

        InAppNotificationService.i.notify(
          NotificationMessage(
            id: "invalid_key",
            body: locale.onboarding__snackbar__invalid_key,
          ),
        );
        return;
      }
    } catch (e) {
      InAppNotificationService.i.notify(
        NotificationMessage(
          id: "import_key_failed",
          body: Failure.fromException(e).message,
        ),
      );
    } finally {
      await wait(200);
      setState(() {
        importing = false;
      });
      saveAndContinue();
    }
  }

  Future<void> importEnc2KeyFromQr() async {
    setState(() {
      importing = true;
    });

    final locale = context.locale;

    try {
      final payload = await showDialog<String>(
        context: context,
        builder: (_) => const ScanQrE2eeDialog(),
      );
      if (!mounted || payload == null || payload.isEmpty) return;

      final passcode = await E2EEPasscodePromptDialog.show(context);
      if (!mounted || passcode == null || passcode.isEmpty) return;

      final secret = E2EEQrTransferService.decryptPayload(
        payload: payload,
        passcode: passcode,
      );

      if (secret == null || secret.enc2Id != widget.importableKeyId) {
        importedKey = null;
        InAppNotificationService.i.notify(
          NotificationMessage(
            id: 'invalid_qr_key',
            body: locale.onboarding__snackbar__invalid_key,
          ),
        );
        return;
      }

      importedKey = secret.enc2;
    } catch (e) {
      InAppNotificationService.i.notify(
        NotificationMessage(
          id: 'import_qr_key_failed',
          body: Failure.fromException(e).message,
        ),
      );
    } finally {
      await wait(200);
      if (mounted) {
        setState(() {
          importing = false;
        });
      }
      saveAndContinue();
    }
  }

  Future<void> saveAndContinue() async {
    if (importedKey == null) return;

    setState(() {
      saving = true;
    });
    try {
      await appConfigCubit.setE2EEKey(importedKey);
      await appConfigCubit.toggleAutoEncrypt(true);
      await authCubit.encryptionKeySetupCompleted();
      widget.onImportSuccess();
    } catch (e) {
      InAppNotificationService.i.notify(
        NotificationMessage(
          id: "save_key_failed",
          body: Failure.fromException(e).message,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          saving = false;
        });
      }
    }
  }

  Future<void> doItLater() async {
    final answer = await ConfirmDialog(
      title: context.locale.onboarding__dialog__skip_import__title,
      message: context.locale.onboarding__dialog__skip_import__subtitle,
      confirmationDelay: 5,
    ).show(context);

    if (!answer) return;
    widget.onContinue();
  }

  Future<void> resetEncryption() async {
    final locale = context.locale;
    final answer = await ConfirmDialog(
      title: locale.onboarding__dialog__reset_key__title,
      message: locale.onboarding__dialog__reset_key__subtitle,
      confirmationDelay: 10,
    ).show(context);

    if (!answer) return;

    setState(() {
      saving = true;
    });

    try {
      final result = await widget.clipboardRepository.deleteAllEncrypted();
      await result.fold(
        (l) async => InAppNotificationService.i.notify(
          NotificationMessage(
            id: "reset_key_failed",
            body: Failure.fromException(l).message,
          ),
        ),
        (_) async {
          await authCubit.removeEncryptionSetup();
          InAppNotificationService.i.notify(
            NotificationMessage(
              id: "reset_key_success",
              body: locale.onboarding__snackbar__reset_key__success,
            ),
          );
        },
      );
    } finally {
      setState(() {
        saving = false;
      });
    }
  }

  Future<void> whereIsMyKey() async {
    await InfoDialog(
      title: context.locale.onboarding__dialog__import_info__title,
      message: context.locale.onboarding__dialog__import_info__subtitle,
    ).open(context);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ZoomIn(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock, size: 28),
                height10,
                Text(
                  context.locale.onboarding__text__import_key_headline,
                  style: textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                height16,
                if (importing || saving)
                  const YarnBallLoading()
                else
                  FadeIn(
                    child: Column(
                      children: [
                        Text(
                          context.locale.onboarding__text__import_key_title,
                          textAlign: TextAlign.center,
                          style: textTheme.titleMedium,
                        ),
                        height16,
                        OverflowBar(
                          overflowAlignment: OverflowBarAlignment.center,
                          children: [
                            FilledButton.icon(
                              onPressed: importEnc2Key,
                              label: Text(
                                context.locale.onboarding__button__import_key,
                              ),
                              icon: const Icon(Icons.key),
                            ),
                            E2EEQrScanActionButton(
                              onPressed: importEnc2KeyFromQr,
                              label: context.locale.transfer__scan_qr,
                            ),
                            TextButton(
                              onPressed: doItLater,
                              child: Text(
                                context.locale.onboarding__button__do_it_later,
                              ),
                            ),
                          ],
                        ),
                        height20,
                        TextButton.icon(
                          style: TextButton.styleFrom(),
                          onPressed: whereIsMyKey,
                          label: Text(
                            context.locale.onboarding__button__where_key,
                          ),
                          icon: const Icon(Icons.info),
                        ),
                        const SizedBox(width: 50, child: Divider(height: 40)),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: colors.error,
                          ),
                          onPressed: resetEncryption,
                          icon: const Icon(Icons.lock_reset_rounded),
                          label: Text(
                            context.locale.onboarding__button__reset_key,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        LocaleAndLogoutRow(enableLogout: !(importing || saving)),
      ],
    );
  }
}
