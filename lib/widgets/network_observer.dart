import 'dart:async';

import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/bloc/sync_status_cubit/sync_status_cubit.dart';
import 'package:clipboard/base/bloc/drive_setup_cubit/drive_setup_cubit.dart';
import 'package:clipboard/base/bloc/monetization_cubit/monetization_cubit.dart';
import 'package:clipboard/base/bloc/user_devices_cubit/user_devices_cubit.dart';
import 'package:clipboard/base/data/services/notification_service.dart'
    show InAppNotificationService;
import 'package:clipboard/base/domain/model/notification_message.dart'
    show NotificationMessage;
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/base/sync/sync_orchestrator.dart';
import 'package:clipboard/common/globals.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/di/di.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/dialogs/inconsistent_timing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkObserver extends StatefulWidget {
  final Widget child;
  const NetworkObserver({super.key, required this.child});

  @override
  State<NetworkObserver> createState() => _NetworkObserverState();
}

class _NetworkObserverState extends State<NetworkObserver> {
  StreamSubscription? subscription;
  Timer? _statusDebounceTimer;
  bool? _lastStableStatus;
  bool wasDisconnected = false;
  late AuthCubit authCubit;
  late MonetizationCubit monetizationCubit;
  late DriveSetupCubit driveSetupCubit;
  late AppConfigCubit appConfigCubit;
  late SyncStatusCubit syncStatusCubit;
  late UserDevicesCubit userDevicesCubit;
  late SyncOrchestrator syncOrchestrator;

  Stream<bool>? networkObserver;

  bool transformNetworkStatus(InternetStatus event) {
    return event == InternetStatus.connected;
  }

  @override
  void dispose() {
    _statusDebounceTimer?.cancel();
    subscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    authCubit = BlocProvider.of<AuthCubit>(context);
    syncOrchestrator = sl<SyncOrchestrator>();
    if (authCubit.isLocalAuth) return;
    networkObserver = InternetConnection().onStatusChange.map(
      transformNetworkStatus,
    );
    subscription = networkObserver?.listen(onConnectionChanged);
    monetizationCubit = BlocProvider.of<MonetizationCubit>(context);
    driveSetupCubit = BlocProvider.of<DriveSetupCubit>(context);
    appConfigCubit = BlocProvider.of<AppConfigCubit>(context);
    syncStatusCubit = BlocProvider.of<SyncStatusCubit>(context);
    userDevicesCubit = BlocProvider.of<UserDevicesCubit>(context);

    syncClocks();
  }

  Future<void> syncClocks() async {
    final synced = await appConfigCubit.syncClocks();
    if (synced != false) return;

    const InconsistentTiming().open();
  }

  Future<void> refetchStates() async {
    logger.i('Refetching states after internet reconnection...');
    await wait(1000);
    final userId = authCubit.userId;
    if (userId == null) return;

    await monetizationCubit.login(userId);
    await driveSetupCubit.fetch();
    await appConfigCubit.syncClocks();
    await syncStatusCubit.syncAll(const SyncAllParams());
    await syncOrchestrator.reconnectRealtime();
  }

  void onConnectionChanged(bool isConnected) {
    _statusDebounceTimer?.cancel();
    _statusDebounceTimer = Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      _handleStableConnectionChange(isConnected);
    });
  }

  void _handleStableConnectionChange(bool isConnected) {
    if (_lastStableStatus == isConnected) return;
    _lastStableStatus = isConnected;

    logger.i('Network connection settled: $isConnected');
    if (authCubit.isLocalAuth) return;
    internetConnected.set(isConnected);
    if (isConnected) {
      InAppNotificationService.i.dismiss("internet_disconnected");
      if (wasDisconnected) {
        wasDisconnected = false;
        unawaited(refetchStates());
        InAppNotificationService.i.notify(
          NotificationMessage(
            id: "internet_connected",
            body: context.locale.app__ack__internet_connected,
            clearPrevious: true,
          ),
        );
      }
    } else {
      wasDisconnected = true;
      InAppNotificationService.i.dismiss("internet_connected");
      InAppNotificationService.i.notify(
        NotificationMessage(
          id: "internet_disconnected",
          body: context.locale.app__ack__internet_disconnected,
          clearPrevious: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
