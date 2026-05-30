import 'package:clipboard/base/bloc/drive_setup_cubit/drive_setup_cubit.dart';
import 'package:clipboard/base/constants/font_variations.dart';
import 'package:clipboard/base/constants/strings/asset_constants.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/dialogs/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoogleDriveSetup extends StatelessWidget {
  const GoogleDriveSetup({super.key});

  Future<void> connectGDrive(
    BuildContext context, {
    bool alreadyConnected = false,
  }) async {
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
    final dense = context.isMobile;
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
          margin: dense ? const EdgeInsets.all(padding12) : EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(padding12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.locale.settings__text__cloud__title,
                  style: textTheme.titleMedium?.copyWith(
                    fontVariations: fontVarW700,
                  ),
                ),
                Text(
                  "${hasError ? "${context.locale.settings__text__gdrive__error}\n\n" : ''}${context.locale.settings__text__gdrive__info}",
                ),
                height12,
                ListTile(
                  tileColor: colors.secondaryContainer,
                  title: Text(
                    context.locale.settings__text__cloud__name,
                    style: textTheme.titleMedium,
                  ),
                  shape: const RoundedRectangleBorder(borderRadius: radius8),
                  contentPadding: const EdgeInsets.all(padding12),
                  trailing: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(185, 40),
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
                // height12,
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
              ],
            ),
          ),
        );
      },
    );
  }
}
