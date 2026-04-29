import 'package:clipboard/base/bloc/android_bg_clipboard_cubit/android_bg_clipboard_cubit.dart';
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/bloc/clip_collection_cubit/clip_collection_cubit.dart';
import 'package:clipboard/base/bloc/clipboard_cubit/clipboard_cubit.dart';
import 'package:clipboard/base/bloc/event_bus_cubit/event_bus_cubit.dart';
import 'package:clipboard/base/bloc/cloud_persistance_cubit/cloud_persistance_cubit.dart';
import 'package:clipboard/base/bloc/drive_setup_cubit/drive_setup_cubit.dart';
import 'package:clipboard/base/bloc/monetization_cubit/monetization_cubit.dart';
import 'package:clipboard/base/bloc/offline_persistance_cubit/offline_persistance_cubit.dart';
import 'package:clipboard/base/bloc/sync_status_cubit/sync_status_cubit.dart';
import 'package:clipboard/base/domain/services/sync_event_bus.dart';
import 'package:clipboard/base/sync/sync_orchestrator.dart';
import 'package:clipboard/base/bloc/window_action_cubit/window_action_cubit.dart';
import 'package:clipboard/base/constants/key.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/data/services/clipboard_service.dart';
import 'package:clipboard/base/data/services/encryption.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/di/di.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/snackbar.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/dialogs/inconsistent_timing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:clipboard/base/data/isar/isar_database_service.dart';
import 'package:universal_io/io.dart';

class EventBridge extends StatelessWidget {
  final EventBusCubit eventBus;
  final Widget child;

  const EventBridge({super.key, required this.eventBus, required this.child});

  void broadcastEvent(CrossSyncEventType eventType, ClipboardItem item) {
    sl<SyncEventBus>().emit<ClipboardItem>((eventType, item));
  }

  void broadcastBatchEvent(
    CrossSyncEventType eventType,
    List<ClipboardItem> items,
  ) {
    if (items.isEmpty) return;
    if (items.length == 1) {
      broadcastEvent(eventType, items.first);
      return;
    }
    final payload = items.map((item) => (eventType, item)).toList();
    sl<SyncEventBus>().emitBatch<ClipboardItem>(payload);
  }

  Future<void> setupEncryption(BuildContext context) async {
    final config = context.read<AppConfigCubit>().state.config;
    if (config.enc2Key == null) return;

    final encryptionWorker = EncryptionWorker.instance;
    if (!encryptionWorker.isRunning || !encryptionWorker.isStarting) {
      final authState = context.read<AuthCubit>().state;
      if (authState is AuthenticatedAuthState) {
        final enc1 = authState.user.enc1;
        final enc1Decrypt = config.decryptEnc2(enc1);
        if (enc1Decrypt == null) return;
        await encryptionWorker.start(enc1Decrypt);
      }
    }
  }

  Future<void> resetAll(BuildContext context) async {
    EncryptionWorker.instance.dispose();
    final IsarDatabaseService dbService = sl();
    context.read<OfflinePersistenceCubit>().stopListeners();
    context.read<DriveSetupCubit>().reset();
    context.read<DriveSetupCubit>().reset();
    sl<SyncOrchestrator>().stop();
    if (Platform.isAndroid) context.read<AndroidBgClipboardCubit?>()?.reset();
    context.read<MonetizationCubit>().logout();
    context.read<ClipCollectionCubit>().reset();
    if (isDesktopPlatform) {
      context.read<WindowActionCubit>()
        ..setWindowdView()
        ..show();
    }
    clearPersistedRootDir();
    await dbService.clearAll();

    if (context.mounted && rootNavKey.currentContext != null) {
      showTextSnackbar(
        rootNavKey.currentContext!.locale.app__ack__logout_success,
        closePrevious: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        if (isDesktopPlatform)
          BlocListener<AppConfigCubit, AppConfigState>(
            listenWhen: (previous, current) =>
                previous.config.view != current.config.view,
            listener: (context, state) {
              final view = state.config.view;
              if (view != AppView.windowed) {
                rootNavKey.currentContext?.goNamed(RouteConstants.home);
              }
              final size = view == AppView.windowed
                  ? initialWindowSize
                  : state.config.windowSize;
              context.read<WindowActionCubit>().setup(view, size);
            },
          ),
        if (Platform.isAndroid)
          BlocListener<AppConfigCubit, AppConfigState>(
            listenWhen: (previous, current) =>
                previous.config.exclusionRules != current.config.exclusionRules,
            listener: (context, state) {
              final rules = state.config.exclusionRules;
              final androidCubit = context.read<AndroidBgClipboardCubit>();
              androidCubit.updateExclusionRule(rules);
            },
          ),
        BlocListener<AppConfigCubit, AppConfigState>(
          listenWhen: (previous, current) =>
              previous.config.sortBy != current.config.sortBy ||
              previous.config.sortOrder != current.config.sortOrder,
          listener: (context, state) {
            final clipboardCubit = context.read<ClipboardCubit>();
            clipboardCubit.fetch(fromTop: true);
          },
        ),
        BlocListener<AppConfigCubit, AppConfigState>(
          listenWhen: (previous, current) {
            final prev = previous.config;
            final curr = current.config;
            return prev.enableSync != curr.enableSync ||
                prev.syncSpeed != curr.syncSpeed ||
                prev.onBoardComplete != curr.onBoardComplete ||
                prev.richDataCapture != curr.richDataCapture;
          },
          listener: (context, state) async {
            final config = state.config;
            sl<ClipboardService>().setRichDataEnabled(config.richDataCapture);

            if (!config.onBoardComplete) {
              logger.i(
                "Preventing syncing before onboarding process completes.",
              );
              if (isDesktopPlatform) {
                context.read<WindowActionCubit>()
                  ..setWindowdView()
                  ..show();
              }
              return;
            }

            if (config.enableSync) {
              sl<SyncOrchestrator>().start(syncSpeed: config.syncSpeed);
              context.read<SyncStatusCubit>().syncAll(const SyncAllParams());

              switch (config.syncSpeed) {
                case SyncSpeed.realtime:
                  sl<SyncOrchestrator>().startRealtime();
                case SyncSpeed.balanced:
                // polling only handled by start()
              }
            } else {
              sl<SyncOrchestrator>().stop();
            }
          },
        ),
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) async {
            switch (state) {
              case AuthenticatedAuthState(:final user):
                {
                  final mc = context.read<MonetizationCubit>();
                  final configCubit = context.read<AppConfigCubit>();
                  final cc = context.read<ClipCollectionCubit>();
                  await mc.login(user.userId);
                  await configCubit.load();
                  await cc.fetch();
                  if (context.mounted) {
                    setupEncryption(context);
                    final config = configCubit.state.config;
                    if (config.onBoardComplete) {
                      context.read<DriveSetupCubit>().fetch();
                      context.read<OfflinePersistenceCubit>().startListeners();
                      sl<SyncOrchestrator>().start(syncSpeed: config.syncSpeed);
                      context.read<SyncStatusCubit>().syncAll(
                        const SyncAllParams(),
                      );
                      rootNavKey.currentContext?.goNamed(RouteConstants.home);
                    } else {
                      rootNavKey.currentContext?.goNamed(
                        RouteConstants.onboard,
                      );
                    }
                  }
                }
              case UnauthenticatedAuthState(:final failure):
                if (failure == null) resetAll(context);
                context.read<AppConfigCubit>().reset();
                if (isDesktopPlatform) {
                  context.read<WindowActionCubit>()
                    ..setWindowdView()
                    ..show();
                }
                rootNavKey.currentContext?.goNamed(RouteConstants.login);
              case UnknownAuthState() || AuthenticatingAuthState():
                logger.i(
                  "Auth State Unknown or Authenticating or Unauthenticated",
                );
                rootNavKey.currentContext?.goNamed(RouteConstants.login);
                closeSnackbar();
                await context.windowAction?.show();
              case LocalAuthenticatedAuthState():
                {
                  rootNavKey.currentContext?.goNamed(RouteConstants.home);
                  await Future.wait([
                    context.read<AppConfigCubit>().load(),
                    context.read<ClipCollectionCubit>().fetch(),
                    context.read<OfflinePersistenceCubit>().startListeners(),
                  ]);
                }
            }
          },
        ),
        BlocListener<AppConfigCubit, AppConfigState>(
          listenWhen: (previous, current) =>
              (previous.config.enc2 != current.config.enc2) ||
              (previous.config.autoEncrypt != current.config.autoEncrypt) ||
              (previous.config.useEncryptionNonce !=
                  current.config.useEncryptionNonce) ||
              (previous.config.clockUnSynced != current.config.clockUnSynced),
          listener: (context, state) async {
            switch (state) {
              case AppConfigLoaded(:final config):
                {
                  if (config.clockUnSynced) {
                    const InconsistentTiming().open();
                  }

                  EncryptionWorker.instance.setEncryption(config.autoEncrypt);
                  EncryptionWorker.instance.setUseNonce(
                    config.useEncryptionNonce,
                  );
                  setupEncryption(context);
                }
              case _:
            }
          },
        ),
        BlocListener<OfflinePersistenceCubit, OfflinePersistanceState>(
          listener: (context, state) async {
            final locales = rootNavKey.currentContext?.locale;
            switch (state) {
              case OfflinePersistanceSaved(:final items, synced: true):
                showDebugSnackbar("Offline Saved ( Synced ) ${items.length}");
                broadcastBatchEvent(CrossSyncEventType.update, items);
              case OfflinePersistanceSaved(
                :final items,
                :final created,
                synced: false,
              ):
                {
                  final eventType = created
                      ? CrossSyncEventType.create
                      : CrossSyncEventType.update;
                  broadcastBatchEvent(eventType, items);
                  // Push is now handled by the SyncEngine outbox.
                }
              case OfflinePersistanceError(:final failure):
                showFailureSnackbar(failure);
              case OfflinePersistanceDeleted(:final items):
                if (locales != null) {
                  showTextSnackbar(
                    locales.app__ack__deleted,
                    closePrevious: true,
                  );
                }
                broadcastBatchEvent(CrossSyncEventType.delete, items);
              case _:
            }
          },
        ),
        BlocListener<CloudPersistanceCubit, CloudPersistanceState>(
          listener: (context, state) async {
            final locales = rootNavKey.currentContext?.locale;
            final offlineCubit = context.read<OfflinePersistenceCubit>();
            switch (state) {
              case CloudPersistanceSaved(:final item):
                // Write back the serverId/lastSynced to local DB
                // (used by manual sync button and download flows)
                showDebugSnackbar("Cloud Saved ${item.serverId}");
                offlineCubit.persist([item], synced: true);
              case CloudPersistanceDeleted(:final items):
                offlineCubit.delete(items);
              case CloudPersistanceDeleting():
                if (locales != null) {
                  showTextSnackbar(
                    locales.app__ack__deleting,
                    isLoading: true,
                    closePrevious: true,
                  );
                }
              case CloudPersistanceError(:final failure, :final item):
                showFailureSnackbar(failure);
                if (item != null) {
                  broadcastEvent(CrossSyncEventType.update, item);
                }
              case CloudPersistanceCreating(:final item) ||
                  CloudPersistanceUpdating(:final item):
                showDebugSnackbar("Creating/Updating ${item.serverId}");
              case CloudPersistanceUploadingFile(:final item) ||
                  CloudPersistanceDownloadingFile(:final item):
                showDebugSnackbar(
                  "Downloading ${item.downloadProgress} | Uploading ${item.uploadProgress}",
                );
                broadcastEvent(CrossSyncEventType.update, item);
              case _:
            }
          },
        ),
      ],
      child: child,
    );
  }
}
