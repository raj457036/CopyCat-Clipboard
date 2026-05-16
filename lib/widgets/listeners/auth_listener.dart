import 'dart:async';

import 'package:clipboard/base/background/encryption_worker.dart';
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/bloc/monetization_cubit/monetization_cubit.dart';
import 'package:clipboard/base/bloc/user_devices_cubit/user_devices_cubit.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/data/services/notification_service.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
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
    AppConfig appConfig,
    AuthenticatedAuthState authState,
  ) async {
    if (appConfig.enc2Key == null) return;

    final encryptionWorker = EncryptionWorker.instance;
    await encryptionWorker.waitUntilReady();

    final enc1 = authState.user.enc1;
    final enc1Decrypt = appConfig.decryptEnc2(enc1);
    if (enc1Decrypt == null) return;
    await encryptionWorker.start(enc1Decrypt);
    encryptionWorker.setEncryption(appConfig.autoEncrypt);
    encryptionWorker.setDecryption(true);
  }

  Future<void> resetAll(BuildContext context) async {
    EncryptionWorker.instance.dispose();
    final dbService = sl<DatabaseService>();
    clearPersistedRootDir();
    await dbService.clearAll();

    InAppNotificationService.i.notify(
      NotificationMessage.builder(
        id: "logout_success",
        builder: (context) =>
            NotificationContent(body: context.locale.app__ack__logout_success),
      ),
    );
  }

  Future<void> _handleAuthenticatedState(AuthenticatedAuthState state) async {
    final AppConfigCubit appConfigCubit = sl();
    final UserDevicesCubit userDevicesCubit = sl();
    final config = appConfigCubit.state.config;

    final monetizationCubit = sl<MonetizationCubit>();
    await monetizationCubit.login(state.user.userId);

    if (state.isEncryptionKeySetup) {
      await initEncryptionWorker(config, state);
    }

    if (!state.isOnboardingCompleted) {
      appRouter.goNamed(RouteConstants.onboard);
      return;
    }

    unawaited(userDevicesCubit.registerCurrentDevice());
    appRouter.goNamed(RouteConstants.home);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) async {
        switch (state) {
          case AuthenticatedAuthState():
            {
              await _handleAuthenticatedState(state);
            }
          case UnauthenticatedAuthState(:final failure):
            // MARK: - Post Logout Cleanup
            if (failure == null) resetAll(context);
            sl<UserDevicesCubit>().clear();
            context.read<AppConfigCubit>().reset();
            await context.windowAction?.show();
            appRouter.goNamed(RouteConstants.login);
            EncryptionWorker.instance.dispose();
            syncOrchestrator.stop();
          case UnknownAuthState() || AuthenticatingAuthState():
            InAppNotificationService.i.dismissAll();
            sl<UserDevicesCubit>().clear();
            await context.windowAction?.show();
            appRouter.goNamed(RouteConstants.login);
            syncOrchestrator.stop();
          case LocalAuthenticatedAuthState():
            // MARK: - Offline Authentication Success
            appRouter.goNamed(RouteConstants.home);
        }
      },
      child: child,
    );
  }
}
