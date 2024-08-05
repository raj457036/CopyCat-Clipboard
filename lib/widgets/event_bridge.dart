// ignore_for_file: use_build_context_synchronously

import 'package:clipboard/routes/utils.dart';
import 'package:clipboard/widgets/dialogs/inconsistent_timing.dart';
import 'package:copycat_base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:copycat_base/bloc/auth_cubit/auth_cubit.dart';
import 'package:copycat_base/bloc/clip_collection_cubit/clip_collection_cubit.dart';
import 'package:copycat_base/bloc/cloud_persistance_cubit/cloud_persistance_cubit.dart';
import 'package:copycat_base/bloc/offline_persistance_cubit/offline_persistance_cubit.dart';
import 'package:copycat_base/bloc/sync_manager_cubit/sync_manager_cubit.dart';
import 'package:copycat_base/data/services/encryption.dart';
import 'package:copycat_base/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventBridge extends StatelessWidget {
  final Widget child;

  const EventBridge({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppConfigCubit, AppConfigState>(
          listenWhen: (previous, current) =>
              (previous.config.autoSyncInterval !=
                  current.config.autoSyncInterval) ||
              (previous.config.enc2 != current.config.enc2) ||
              (previous.config.autoEncrypt != current.config.autoEncrypt) ||
              (previous.config.clockUnSynced != current.config.clockUnSynced),
          listener: (context, state) async {
            switch (state) {
              case AppConfigLoaded(:final config):
                {
                  if (config.clockUnSynced) {
                    const InconsistentTiming().open();
                  }
                  if (config.enableSync) {
                    context.read<SyncManagerCubit>().setupAutoSync(
                          Duration(seconds: config.autoSyncInterval),
                        );
                  } else {
                    context.read<SyncManagerCubit>().stopAutoSync();
                  }

                  EncrypterWorker.instance.setEncryption(config.autoEncrypt);

                  if (!EncrypterWorker.instance.isRunning) {
                    if (config.enc2Key == null) return;
                    final authState = context.read<AuthCubit>().state;

                    if (authState is AuthenticatedAuthState) {
                      final enc1 = authState.user.enc1;
                      if (enc1 == null) return;
                      final encMngr = EncryptionManager(config.enc2Key!);
                      final enc1Decrypt = encMngr.decrypt(enc1);
                      await EncrypterWorker.instance.start(enc1Decrypt);
                    }
                  }

                  if (context.mounted) {
                    await context
                        .read<OfflinePersistanceCubit>()
                        .decryptAllClipboardItems();
                  }
                }
                break;
              case _:
            }
          },
        ),
        BlocListener<SyncManagerCubit, SyncManagerState>(
          listener: (context, state) {
            switch (state) {
              case PartlySyncedSyncState(collections: true):
                context.read<ClipCollectionCubit>().fetch(fromTop: true);
                break;
            }
          },
        ),
        BlocListener<OfflinePersistanceCubit, OfflinePersistanceState>(
          listener: (context, state) async {
            switch (state) {
              case OfflinePersistanceSaved(:final item, synced: false):
                context.read<CloudPersistanceCubit>().persist(item);
                break;
              case OfflinePersistanceError(:final failure):
                showFailureSnackbar(failure);
                break;
              case _:
            }
          },
        ),
        BlocListener<CloudPersistanceCubit, CloudPersistanceState>(
          listener: (context, state) async {
            switch (state) {
              case CloudPersistanceSaved(:final item):
                context
                    .read<OfflinePersistanceCubit>()
                    .persist(item, synced: true);
                break;
              case CloudPersistanceDeleted(:final item):
                context.read<OfflinePersistanceCubit>().delete(item);
                break;
              case CloudPersistanceError(
                  :final retryCount,
                  :final failedAction,
                  :final item
                ):
                {
                  if (retryCount.isNegative) return;
                  if (retryCount > 3) return;

                  await waitHere(retryCount + 1);

                  switch (failedAction) {
                    case FailedAction.create ||
                          FailedAction.update ||
                          FailedAction.upload:
                      context.read<CloudPersistanceCubit>().persist(
                            item,
                            retryCount: retryCount + 1,
                          );
                      break;
                    case FailedAction.download:
                      context.read<CloudPersistanceCubit>().download(
                            item,
                            retryCount: retryCount + 1,
                          );
                      break;
                    case FailedAction.delete:
                      context.read<CloudPersistanceCubit>().delete(
                            item,
                            retryCount: retryCount + 1,
                          );
                      break;
                    default:
                  }
                }
                break;
              case _:
            }
          },
        ),
      ],
      child: child,
    );
  }
}
