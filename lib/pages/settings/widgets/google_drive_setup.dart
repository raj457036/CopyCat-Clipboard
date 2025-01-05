import 'package:clipboard/widgets/dialogs/confirm_dialog.dart';
import 'package:copycat_base/bloc/drive_setup_cubit/drive_setup_cubit.dart';
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
              title: context.locale.reconnectGoogleDrive,
              message: context.locale.reconnectGoogleDriveDesc)
          .show(context);

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
        String text = context.locale.connected;
        bool buttonDisabled = false;
        bool alreadyConnected = false;
        bool hasError = false;
        switch (state) {
          case DriveSetupFetching() || DriveSetupRefreshingToken():
            text = context.locale.loading;
            buttonDisabled = true;
          case DriveSetupVerifyingCode():
            text = context.locale.authorizing;
            buttonDisabled = true;
          case DriveSetupUnknown(:final waiting):
            text =
                waiting ? context.locale.authorizing : context.locale.loading;
            buttonDisabled = true;
          case DriveSetupDone():
            text = context.locale.connected;
            buttonDisabled = false;
            alreadyConnected = true;
          case DriveSetupError():
            text = context.locale.connectNow;
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
                  "Cloud Storage",
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: padding16,
                  vertical: padding8,
                ),
                child: Text(
                  context.locale.cloudStorageInfo(
                    hasError ? context.locale.cloudStorageInfoDefault : '',
                  ),
                ),
              ),
              ListTile(
                tileColor: colors.secondaryContainer,
                minLeadingWidth: 20,
                title: Text(
                  "Google Drive",
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // subtitle: const Text(
                //   "🔗 linked email...",
                // ),
                trailing: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    fixedSize: const Size(185, 40),
                    textStyle: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
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
              //   title: const Text('Setup Other Cloud Drive'),
              //   subtitle: const Text(
              //       "Setup other cloud drives like Dropbox, OneDrive, etc."),
              //   trailing: const Icon(Icons.chevron_right),
              //   onTap: () => {},
              // ),
              height10,
            ],
          ),
        );
      },
    );
  }
}
