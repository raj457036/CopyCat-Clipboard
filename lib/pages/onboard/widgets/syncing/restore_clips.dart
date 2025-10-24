import 'dart:math' show max;

import 'package:animate_do/animate_do.dart';
import 'package:clipboard/base/bloc/clip_sync_manager_cubit/clip_sync_manager_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/db/sync_status/syncstatus.dart';
import 'package:clipboard/base/domain/repositories/clipboard.dart';
import 'package:clipboard/base/domain/repositories/restoration_status.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/snackbar.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RestoreClipsStep extends StatefulWidget {
  final VoidCallback onContinue;
  final ClipboardRepository clipboardRepository;
  final RestorationStatusRepository restorationStatusRepository;

  const RestoreClipsStep({
    super.key,
    required this.onContinue,
    required this.clipboardRepository,
    required this.restorationStatusRepository,
  });

  @override
  State<RestoreClipsStep> createState() => _RestoreClipsStepState();
}

class _RestoreClipsStepState extends State<RestoreClipsStep> {
  int totalCount = -1;
  bool fetchingCount = false;
  late final ClipSyncManagerCubit syncCubit;
  late SyncStatus? syncStatus;

  @override
  void initState() {
    super.initState();
    syncCubit = context.read<ClipSyncManagerCubit>();
    startSyncing();
  }

  Future<void> startSyncing() async {
    setState(() {
      fetchingCount = true;
    });
    try {
      if (totalCount > -1) {
        syncClips();
        return;
      }
      final lastSync = syncCubit.getLastSyncedTime();
      final result = await widget.clipboardRepository.getClipCounts(lastSync);
      result.fold(
        (l) => showFailureSnackbar(l),
        (r) {
          totalCount = r;
          syncClips();
        },
      );
      final syncStatusResult =
          await widget.restorationStatusRepository.getStatus();
      syncStatusResult.fold((l) => showFailureSnackbar(l), (r) {
        syncStatus = r;
      });
    } finally {
      setState(() {
        fetchingCount = false;
      });
    }
  }

  Future<void> syncClips() async {
    await wait(1000);

    switch (syncCubit.state) {
      case ClipSyncUnknown() || ClipSyncingUnknown() || ClipSyncFailed():
        syncCubit.syncClips(
          syncStartTs: syncStatus?.lastSyncStartPoint,
          lastSyncedCount: syncStatus?.lastKnownSyncCount ?? 0,
          restoration: true,
        );
      case _:
    }
  }

  void updateTotalCount(int syncCount) {
    if (syncCount > totalCount) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          totalCount = syncCount;
        });
      });
    }
  }

  Future<void> updateSyncStatus(
    int synced,
    DateTime fromTs,
    DateTime toTs,
  ) async {
    await widget.restorationStatusRepository.setStatus(
      SyncStatus(
        lastSyncStartPoint: fromTs,
        lastSyncPoint: toTs,
        lastKnownSyncCount: synced,
        lastKnownTotalCount: totalCount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return ZoomIn(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.restore_rounded,
              size: 32,
            ),
            height10,
            Text(
              context.locale.restore_clips__text__title,
              style: textTheme.headlineMedium,
            ),
            height8,
            if (fetchingCount)
              const CircularProgressIndicator()
            else if (totalCount < 0)
              Column(
                children: [
                  Text(context.locale.restore_clips__error__no_backup),
                  height10,
                  ElevatedButton(
                    onPressed: startSyncing,
                    child: Text(
                      context.locale.app__try_again,
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  Text(
                    context.locale.restore_clips__text__total_count(
                      totalCount: totalCount,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  height12,
                  const SizedBox(width: 100, height: 20, child: Divider()),
                  height8,
                  BlocConsumer<ClipSyncManagerCubit, ClipSyncManagerState>(
                    listener: (context, state) {
                      switch (state) {
                        case ClipSyncComplete(
                            :final syncCount,
                            :final fromTs,
                            :final toTs,
                          ):
                          updateSyncStatus(
                            max(syncCount, totalCount),
                            fromTs,
                            toTs,
                          );
                          updateTotalCount(syncCount);
                        case ClipSyncing(
                            :final synced,
                            :final fromTs,
                            :final toTs,
                          ):
                          updateSyncStatus(synced, fromTs, toTs);
                        case _:
                      }
                    },
                    builder: (context, state) {
                      switch (state) {
                        case ClipSyncDisabled():
                          return Text(
                            context.locale.restore_clips__sync_disable,
                            textAlign: TextAlign.center,
                          );
                        case ClipSyncUnknown() || ClipSyncingUnknown():
                          return Text(
                            context.locale.restore_clips__preparing,
                          );
                        case ClipSyncComplete(:final syncCount):
                          return Column(
                            children: [
                              const SizedBox(
                                width: 250,
                                child: LinearProgressIndicator(
                                  borderRadius: radius12,
                                  value: 1,
                                ),
                              ),
                              height10,
                              Text(
                                context.locale.restore_clips__restored(
                                  syncCount: max(syncCount, totalCount),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              height10,
                              FilledButton.tonalIcon(
                                onPressed: widget.onContinue,
                                label: Text(
                                    context.locale.onboarding__text__go_home),
                                icon: const Icon(Icons.check_rounded),
                              ),
                            ],
                          );
                        case ClipSyncFailed(:final failure):
                          return Column(
                            children: [
                              Text(
                                context.locale.onboarding__restoration__failed(
                                  message: failure.toString(),
                                ),
                              ),
                              height10,
                              ElevatedButton(
                                onPressed: startSyncing,
                                child: Text(context.locale.app__try_again),
                              ),
                            ],
                          );
                        case ClipSyncing(:final synced):
                          return Column(
                            children: [
                              if (totalCount > 0 || synced > 0)
                                SizedBox(
                                  width: 250,
                                  child: LinearProgressIndicator(
                                    borderRadius: radius12,
                                    value: synced / max(totalCount, synced),
                                  ),
                                ),
                              height10,
                              Text(
                                context.locale.restore_clips__restoring(
                                  synced: synced,
                                  totalCount: max(totalCount, synced),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              height12,
                              Text(
                                context.locale.onboarding__restoration_warning,
                                textAlign: TextAlign.center,
                                style: textTheme.bodySmall?.copyWith(
                                  color: Colors.deepOrange,
                                  fontStyle: FontStyle.italic,
                                ),
                              )
                            ],
                          );
                      }
                    },
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
