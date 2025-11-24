import 'dart:math' show max;

import 'package:animate_do/animate_do.dart';
import 'package:clipboard/base/bloc/collection_sync_manager_cubit/collection_sync_manager_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/repositories/clip_collection.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/snackbar.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RestoreCollectionStep extends StatefulWidget {
  final VoidCallback onContinue;
  final ClipCollectionRepository collectionRepository;
  const RestoreCollectionStep({
    super.key,
    required this.onContinue,
    required this.collectionRepository,
  });

  @override
  State<RestoreCollectionStep> createState() => _RestoreCollectionStepState();
}

class _RestoreCollectionStepState extends State<RestoreCollectionStep> {
  int totalCount = -1;
  bool fetchingCount = false;
  late final CollectionSyncManagerCubit syncCubit;

  @override
  void initState() {
    super.initState();
    syncCubit = context.read<CollectionSyncManagerCubit>();
    startSyncing();
  }

  Future<void> startSyncing() async {
    setState(() {
      fetchingCount = true;
    });
    try {
      if (totalCount > -1) {
        syncCollection();
        return;
      }
      final result = await widget.collectionRepository.getCount(local: false);
      result.fold(
        (l) => showFailureSnackbar(l),
        (r) {
          totalCount = r;
          syncCollection();
        },
      );
    } finally {
      setState(() {
        fetchingCount = false;
      });
    }
  }

  Future<void> syncCollection() async {
    await wait(1000);

    if (totalCount == 0) {
      widget.onContinue();
      return;
    }

    switch (syncCubit.state) {
      case CollectionSyncUnknown() ||
            CollectionSyncingUnknown() ||
            CollectionSyncFailed():
        syncCubit.syncCollections(restoration: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return ZoomIn(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.collections_bookmark_rounded,
              size: 32,
            ),
            height10,
            Text(
              context.locale.restore_collections__text__title,
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium,
            ),
            height8,
            if (fetchingCount)
              const CircularProgressIndicator()
            else if (totalCount < 0)
              FadeIn(
                child: Column(
                  children: [
                    Text(
                      context.locale.restore_collections__error__no_backup,
                      textAlign: TextAlign.center,
                    ),
                    height10,
                    ElevatedButton(
                      onPressed: startSyncing,
                      child: Text(context.locale.app__try_again),
                    ),
                  ],
                ),
              )
            else
              FadeIn(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      context.locale.restore_collections__text__total_count(
                        totalCount: totalCount,
                      ),
                      textAlign: TextAlign.center,
                      style: textTheme.titleMedium,
                    ),
                    height12,
                    const SizedBox(width: 100, height: 20, child: Divider()),
                    height8,
                    BlocConsumer<CollectionSyncManagerCubit,
                        CollectionSyncManagerState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        switch (state) {
                          case CollectionSyncDisabled():
                            return Text(
                              context.locale.restore_collections__sync_disable,
                              textAlign: TextAlign.center,
                            );
                          case CollectionSyncUnknown() ||
                                CollectionSyncingUnknown():
                            return Text(
                              context.locale.restore_collections__preparing,
                            );
                          case CollectionSyncComplete(:final syncCount):
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
                                  context.locale.restore_collections__restored(
                                    syncCount: max(syncCount, totalCount),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                height10,
                                ElevatedButton(
                                  onPressed: widget.onContinue,
                                  child: Text(
                                    context.mlocale.continueButtonLabel.title,
                                  ),
                                ),
                              ],
                            );
                          case CollectionSyncFailed(:final failure):
                            return Column(
                              children: [
                                Text(
                                  context.locale
                                      .onboarding__restoration__failed(
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
                          case CollectionSyncing(:final synced):
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
                                  context.locale.restore_collections__restoring(
                                    synced: synced,
                                    totalCount: max(totalCount, synced),
                                  ),
                                ),
                                height12,
                                Text(
                                  context
                                      .locale.onboarding__restoration_warning,
                                  textAlign: TextAlign.center,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: Colors.deepOrange,
                                    fontStyle: FontStyle.italic,
                                  ),
                                )
                              ],
                            );
                          case _:
                            // no-op
                            return const SizedBox.shrink();
                        }
                      },
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
