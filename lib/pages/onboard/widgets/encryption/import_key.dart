import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/repositories/clipboard.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/pages/onboard/widgets/locale_and_logout.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/snackbar.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/dialogs/confirm_dialog.dart';
import 'package:clipboard/widgets/dialogs/info_dialog.dart';
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
      final pickedFile = await FilePicker.platform.pickFiles(
        type: isDesktopPlatform ? FileType.custom : FileType.any,
        allowedExtensions: isDesktopPlatform ? ['enc2'] : null,
        withData: true,
      );

      await windowAction?.show();

      if (pickedFile == null) return;
      if (pickedFile.files.first.bytes == null) return;
      final content = utf8.decode(pickedFile.files.first.bytes!);
      final json = jsonDecode(content);
      final importedKeyId = json["enc2Id"];
      importedKey = json["enc2"];

      if (importedKeyId == null ||
          importedKeyId != widget.importableKeyId ||
          importedKey == null) {
        importedKey = null;
        showFailureSnackbar(
          Failure.fromMessage(
            locale.onboarding__snackbar__invalid_key,
          ),
        );
        return;
      }
    } catch (e) {
      showFailureSnackbar(Failure.fromException(e));
    } finally {
      await wait(200);
      setState(() {
        importing = false;
      });
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
      widget.onImportSuccess();
    } catch (e) {
      showFailureSnackbar(Failure.fromException(e));
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
      await result.fold((l) async => showFailureSnackbar(l), (_) async {
        await authCubit.removeEncryptionSetup();
        showTextSnackbar(
          locale.onboarding__snackbar__reset_key__success,
          success: true,
        );
      });
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
                const Icon(
                  Icons.lock,
                  size: 28,
                ),
                height10,
                Text(
                  context.locale.onboarding__text__import_key_headline,
                  style: textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                height16,
                if (importing || saving)
                  const CircularProgressIndicator()
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
                          children: [
                            FilledButton.icon(
                              onPressed: importEnc2Key,
                              label: Text(
                                context.locale.onboarding__button__import_key,
                              ),
                              icon: const Icon(Icons.key),
                            ),
                            width10,
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
