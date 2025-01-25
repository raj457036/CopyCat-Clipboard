import 'package:clipboard/widgets/dialogs/confirm_dialog.dart';
import 'package:copycat_base/bloc/drive_setup_cubit/drive_setup_cubit.dart';
import 'package:copycat_base/constants/font_variations.dart';
import 'package:copycat_base/constants/strings/asset_constants.dart';
import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoogleDriveSetup extends StatelessWidget {
  const GoogleDriveSetup({super.key});

  Future<void> connectGDrive(BuildContext context,
      {bool alreadyConnected = false}) async {
    final cubit = context.read<DriveSetupCubit>();
    if (alreadyConnected) {
      final confirm = await ConfirmDialog(
        title: context.locale.settings__dialog__conn_gdrive__title,
        message: context.locale.settings__dialog__conn_gdrive__subtitle,
      ).show(context);

      if (!confirm) return;
      await cubit.startSetup(force: true);
      return;
    }
    await cubit.startSetup();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;
    return BlocBuilder<DriveSetupCubit, DriveSetupState>(
      builder: (context, state) {
        String text = context.locale.settings__drive__connected;
        bool buttonDisabled = false;
        bool alreadyConnected = false;
        bool hasError = false;
        switch (state) {
          case DriveSetupFetching() || DriveSetupRefreshingToken():
            text = context.locale.settings__drive__loading;
            buttonDisabled = true;
          case DriveSetupVerifyingCode():
            text = context.locale.settings__drive__authorizing;
            buttonDisabled = true;
          case DriveSetupUnknown(:final waiting):
            text = waiting
                ? context.locale.settings__drive__authorizing
                : context.locale.settings__drive__loading;
            buttonDisabled = true;
          case DriveSetupDone():
            text = context.locale.settings__drive__connected;
            buttonDisabled = false;
            alreadyConnected = true;
          case DriveSetupError():
            text = context.locale.settings__drive__disconnected;
            buttonDisabled = false;
            hasError = true;
        }
        return Card(
          elevation: 0.5,
          margin: const EdgeInsets.symmetric(horizontal: padding16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: padding16,
                  right: padding16,
                  top: padding16,
                ),
                child: Text(
                  context.locale.settings__text__cloud__title,
                  style: textTheme.titleMedium
                      ?.copyWith(fontVariations: fontVarW700),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: padding16,
                  vertical: padding8,
                ),
                child: Text(
                    "${hasError ? "${context.locale.settings__text__gdrive__error}\n\n" : ''}${context.locale.settings__text__gdrive__info}"),
              ),
              ListTile(
                tileColor: colors.secondaryContainer,
                minLeadingWidth: 20,
                title: Text(
                  context.locale.settings__text__cloud__name,
                  style: textTheme.titleMedium
                      ?.copyWith(fontVariations: fontVarW700),
                ),
                // subtitle: const Text(
                //   "🔗 linked email...",
                // ),
                trailing: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    fixedSize: const Size(185, 40),
                    textStyle: textTheme.labelLarge?.copyWith(
                      fontVariations: fontVarW700,
                    ),
                  ),
                  onPressed: buttonDisabled
                      ? null
                      : () => connectGDrive(
                            context,
                            alreadyConnected: alreadyConnected,
                          ),
                  label: Text(text),
                  icon: const Image(
                    image: AssetImage(AssetConstants.googleDriveLogo),
                    height: 22,
                  ),
                ),
              ),
              // ListTile(
              //   contentPadding: const EdgeInsets.symmetric(
              //     horizontal: padding16,
              //   ),
              //   title: Text(
              //     context.locale.settings__tile__other_cloud__title,
              //   ),
              //   subtitle: Text(
              //     context.locale.settings__tile__other_cloud__subtitle,
              //   ),
              //   trailing: const Icon(Icons.chevron_right),
              //   onTap: () => {},
              // ),
              height12,
            ],
          ),
        );
      },
    );
  }
}
