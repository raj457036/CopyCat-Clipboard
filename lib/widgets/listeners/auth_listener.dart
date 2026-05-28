import 'dart:async';

import 'package:clipboard/base/background/encryption_worker.dart';
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/bloc/monetization_cubit/monetization_cubit.dart';
import 'package:clipboard/base/bloc/offline_persistance_cubit/offline_persistance_cubit.dart';
import 'package:clipboard/base/bloc/review_prompt_cubit/review_prompt_cubit.dart';
import 'package:clipboard/base/bloc/sync_status_cubit/sync_status_cubit.dart';
import 'package:clipboard/base/bloc/user_devices_cubit/user_devices_cubit.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/data/services/notification_service.dart';
import 'package:clipboard/base/domain/model/notification_message.dart';
import 'package:clipboard/base/domain/services/database_service.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/base/sync/sync_orchestrator.dart';
import 'package:clipboard/di/di.dart';
import 'package:clipboard/routes/routes.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthListener extends StatelessWidget {
  late final SyncOrchestrator syncOrchestrator;
  final Widget child;

  AuthListener({super.key, required this.child}) {
    syncOrchestrator = sl<SyncOrchestrator>();
  }

  Future<void> initEncryptionWorker(
    AppConfigCubit appConfigCubit,
    AuthenticatedAuthState authState,
  ) async {
    final encryptionWorker = EncryptionWorker.instance;
    await encryptionWorker.waitUntilReady();

    final enc1 = authState.user.enc1;
    final enc1Decrypt = await appConfigCubit.decryptEnc2(enc1);

    if (enc1Decrypt == null) return;

    final config = appConfigCubit.state.config;
    await encryptionWorker.start(enc1Decrypt);
    encryptionWorker.setEncryption(config.autoEncrypt);
    encryptionWorker.setDecryption(true);
  }

  Future<void> resetAll(BuildContext context) async {
    EncryptionWorker.instance.dispose();
    InAppNotificationService.i.dismissAll();
    InAppNotificationService.i.notify(
      NotificationMessage.builder(
        id: "logout_success",
        builder: (context) =>
            NotificationContent(body: context.locale.app__ack__logout_success),
      ),
    );

    await clearPersistedRootDir();
    await sl<DatabaseService>().clearAll();
    sl<OfflinePersistenceCubit>().stopListeners();
    sl<UserDevicesCubit>().clear();
    sl<AppConfigCubit>().reset();
    syncOrchestrator.stop();
  }

  Future<void> _handleAuthenticatedState(
    BuildContext context,
    AuthenticatedAuthState state,
  ) async {
    final AppConfigCubit appConfigCubit = sl();
    final reviewPromptCubit = context.read<ReviewPromptCubit>();

    if (!appConfigCubit.loaded.isCompleted) {
      await appConfigCubit.loaded.future;
    }

    final monetizationCubit = sl<MonetizationCubit>();
    unawaited(monetizationCubit.login(state.user.userId));

    if (state.isEncryptionKeySetup) {
      unawaited(initEncryptionWorker(appConfigCubit, state));
    }

    if (!state.isOnboardingCompleted) {
      reviewPromptCubit.setEnabled(false);
      appRouter.goNamed(RouteConstants.onboard);
      return;
    }

    reviewPromptCubit.setEnabled(true);

    unawaited(sl<OfflinePersistenceCubit>().startListeners());
    unawaited(sl<SyncStatusCubit>().syncAll(const SyncAllParams()));
    unawaited(sl<UserDevicesCubit>().registerCurrentDevice());
    appRouter.goNamed(RouteConstants.home);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) async {
        switch (state) {
          case AuthenticatedAuthState():
            await _handleAuthenticatedState(context, state);
          case UnauthenticatedAuthState(:final failure):
            context.read<ReviewPromptCubit>().setEnabled(false);
            if (failure != null) {
              InAppNotificationService.i.notify(
                NotificationMessage(
                  id: "logout_failure",
                  body: failure.message,
                ),
              );
              return;
            }
            unawaited(resetAll(context));
            await context.windowAction?.show();
            appRouter.goNamed(RouteConstants.login);
          case LocalAuthenticatedAuthState():
            // MARK: - Offline Authentication Success
            final appConfigCubit = sl<AppConfigCubit>();
            final isOnboarded = appConfigCubit.state.config.onBoardComplete;
            context.read<ReviewPromptCubit>().setEnabled(isOnboarded);
            unawaited(sl<OfflinePersistenceCubit>().startListeners());
            appRouter.goNamed(RouteConstants.home);
        }
      },
      child: child,
    );
  }
}
