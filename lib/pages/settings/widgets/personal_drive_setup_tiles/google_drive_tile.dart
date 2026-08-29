import 'package:clipboard/base/bloc/drive_setup_cubit/drive_setup_cubit.dart';
import 'package:clipboard/base/constants/font_variations.dart';
import 'package:clipboard/base/constants/strings/asset_constants.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/pages/settings/widgets/personal_drive_setup_tiles/personal_drive_trailing.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/dialogs/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoogleDriveSetupTile extends StatelessWidget {
  const GoogleDriveSetupTile({super.key});

  Future<void> _onAction(
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
    final cubit = context.read<DriveSetupCubit>();

    return BlocBuilder<DriveSetupCubit, DriveSetupState>(
      builder: (context, state) {
        bool alreadyConnected = false;
        bool waitingForCallback = false;
        bool isLoading = false;
        String subtitle = context.locale.settings__drive__disconnected;

        switch (state) {
          case DriveSetupFetching() || DriveSetupRefreshingToken():
            subtitle = context.locale.settings__drive__loading;
            isLoading = true;
          case DriveSetupVerifyingCode():
            subtitle = context.locale.settings__drive__authorizing;
            isLoading = true;
          case DriveSetupUnknown(:final waiting):
            waitingForCallback = waiting;
            subtitle = waitingForCallback
                ? context.locale.settings__drive__authorizing
                : context.locale.settings__drive__disconnected;
          case DriveSetupDone():
            final account =
                state.token.displayText ?? state.token.accountId ?? "?";
            subtitle =
                "${context.locale.settings__drive__connected} - $account";
            alreadyConnected = true;
          case DriveSetupError():
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
          subtitle: Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: PersonalDriveTrailing(
            isLoading: isLoading,
            isConnected: alreadyConnected,
            provider: ActiveCloudStorageProvider.googleDrive,
            pendingAction: waitingForCallback
                ? IconButton(
                    icon: const Icon(Icons.close_rounded),
                    tooltip: context.mlocale.cancelButtonLabel.title,
                    onPressed: () => cubit.cancelPendingSetup(),
                  )
                : null,
          ),
          onTap: isLoading
              ? null
              : () => _onAction(
                  context,
                  waitingForCallback: waitingForCallback,
                  alreadyConnected: alreadyConnected,
                ),
        );
      },
    );
  }
}
