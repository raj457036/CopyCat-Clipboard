import 'package:clipboard/di/di.dart';
import 'package:clipboard/pages/onboard/widgets/encryption/export_key.dart';
import 'package:clipboard/pages/onboard/widgets/encryption/generate_key.dart';
import 'package:clipboard/pages/onboard/widgets/encryption/import_key.dart';
import 'package:clipboard/pages/onboard/widgets/to_login_page.dart';
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/domain/model/auth_user/auth_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EncryptionStep extends StatelessWidget {
  final VoidCallback onContinue;
  const EncryptionStep({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthCubit, AuthState, AuthUser?>(
      selector: (state) {
        return state.mapOrNull(authenticated: (value) => value.user);
      },
      builder: (context, user) {
        bool imported = false;

        return BlocBuilder<AppConfigCubit, AppConfigState>(
          builder: (context, _) {
            final appConfigCubit = context.read<AppConfigCubit>();
            return FutureBuilder<String?>(
              future: appConfigCubit.getE2EEKey(),
              builder: (context, snapshot) {
                final enc2Key = snapshot.data;
                if (user == null) {
                  return const Center(child: ToLoginPageButton());
                }
                final keyId = user.enc2KeyId;
                final enc1 = user.enc1;

                if (keyId == null || enc1 == null) {
                  return GenerateEncryptionKeyStep(onContinue: onContinue);
                }

                if (enc2Key == null) {
                  return ImportEncryptionKeyStep(
                    importableKeyId: keyId,
                    clipboardRepository: sl(instanceName: "remote"),
                    onImportSuccess: () => imported = true,
                    onContinue: onContinue,
                  );
                }
                return ExportEncryptionKeyStep(
                  exportableKeyId: keyId,
                  exportableEnc2Key: enc2Key,
                  onContinue: onContinue,
                  skipExportWarning: imported,
                );
              },
            );
          },
        );
      },
    );
  }
}
