import 'package:clipboard/base/bloc/drive_setup_cubit/drive_setup_cubit.dart';
import 'package:clipboard/base/constants/font_variations.dart';
import 'package:clipboard/base/constants/strings/asset_constants.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/dialogs/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoogleDriveSetupTile extends StatelessWidget {
  const GoogleDriveSetupTile({super.key});

  Future<void> onAction(
    BuildContext context, {
    required bool waitingForCallback,
    bool alreadyConnected = false,
  }) async {
    final cubit = context.read<DriveSetupCubit>();

    if (waitingForCallback) {
      cubit.cancelPendingSetup();
      return;
    }

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
        String actionText = 'Connect';
        bool buttonDisabled = false;
        bool alreadyConnected = false;
        bool waitingForCallback = false;
        String subtitle = context.locale.settings__drive__disconnected;
        ButtonStyle? actionStyle;

        switch (state) {
          case DriveSetupFetching() || DriveSetupRefreshingToken():
            actionText = context.locale.settings__drive__loading;
            subtitle = context.locale.settings__drive__loading;
            buttonDisabled = true;
          case DriveSetupVerifyingCode():
            actionText = context.locale.settings__drive__authorizing;
            subtitle = context.locale.settings__drive__authorizing;
            buttonDisabled = true;
          case DriveSetupUnknown(:final waiting):
            waitingForCallback = waiting;
            if (waitingForCallback) {
              actionText = context.mlocale.cancelButtonLabel.title;
              subtitle = context.locale.settings__drive__authorizing;
              actionStyle = ElevatedButton.styleFrom(
                backgroundColor: colors.errorContainer,
                foregroundColor: colors.onErrorContainer,
              );
            } else {
              actionText = context.locale.settings__drive__connect;
              subtitle = context.locale.settings__drive__disconnected;
            }
          case DriveSetupDone():
            actionText = context.locale.settings__drive__connected;
            final account =
                state.token.displayText ?? state.token.accountId ?? "?";
            subtitle =
                "${context.locale.settings__drive__connected} - $account";
            alreadyConnected = true;
          case DriveSetupError():
            actionText = context.locale.settings__drive__connect;
            subtitle = context.locale.settings__drive__disconnected;
        }

        return ListTile(
          leading: const Image(
            image: AssetImage(AssetConstants.googleDriveLogo),
            height: 22,
          ),
          title: Text(
            context.locale.settings__text__cloud__name,
            style: textTheme.titleMedium?.copyWith(fontVariations: fontVarW700),
          ),
          subtitle: Text(subtitle),
          trailing: ElevatedButton(
            style: actionStyle,
            onPressed: buttonDisabled
                ? null
                : () => onAction(
                    context,
                    waitingForCallback: waitingForCallback,
                    alreadyConnected: alreadyConnected,
                  ),
            child: Text(actionText),
          ),
        );
      },
    );
  }
}
