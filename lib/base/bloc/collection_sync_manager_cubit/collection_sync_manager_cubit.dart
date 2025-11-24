import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:clipboard/base/bloc/clip_collection_cubit/clip_collection_cubit.dart';
import 'package:clipboard/base/bloc/event_bus_cubit/event_bus_cubit.dart';
import 'package:clipboard/base/constants/numbers/duration.dart';
import 'package:clipboard/base/domain/repositories/clip_collection.dart';
import 'package:clipboard/base/domain/repositories/sync_clipboard.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/utils/snackbar.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'collection_sync_manager_cubit.freezed.dart';
part 'collection_sync_manager_state.dart';

@injectable
class CollectionSyncManagerCubit extends Cubit<CollectionSyncManagerState> {
  final EventBusCubit eventBus;
  final String deviceId;
  final ClipCollectionCubit collectionCubit;
  final ClipCollectionRepository collectionRepo;
  final SyncRepository syncRepo;

  Timer? _pollingTimer;
  int? _syncHours, _manualDelay;
  bool _busy = false;
  DateTime? lastSynced;

  CollectionSyncManagerCubit(
    this.eventBus,
    this.syncRepo,
    this.collectionCubit,
    this.collectionRepo,
    @Named("device_id") this.deviceId,
  ) : super(const CollectionSyncManagerState.unknown());

  int get syncHours => _syncHours ?? 0;

  /// Range: 5s -> 15s
  int get manualDelay => min(max(_manualDelay ?? 15, $5S), 15);

  void changeConfig({int? syncHours, int? manualDelay, bool? disabled}) {
    if (syncHours != null) _syncHours = syncHours;
    if (manualDelay != null) _manualDelay = manualDelay;
    if (disabled != null) {
      if (disabled) {
        emit(const CollectionSyncManagerState.disabled());
      } else {
        emit(const CollectionSyncManagerState.unknown());
      }
    }
  }

  void reset() {
    stopPolling();
    emit(const CollectionSyncManagerState.unknown());
  }

  void startPolling() {
    if (state is CollectionSyncDisabled || state is CollectionSyncUnknown) {
      stopPolling();
      return;
    }
    if (_pollingTimer != null) return;
    _pollingTimer = Timer.periodic(
      const Duration(seconds: $45S),
      (_) => !_busy ? syncCollections() : null,
    );
  }

  void stopPolling() {
    if (_pollingTimer == null) return;
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  (bool, int) canManullySync() {
    if (lastSynced != null) {
      final elapsed = now().difference(lastSynced!).inSeconds;
      if (elapsed >= manualDelay) {
        lastSynced = now();
        return (true, 0);
      }
      return (false, manualDelay - elapsed);
    }
    lastSynced = now();
    return (true, 0);
  }

  Future<bool> syncCollections({
    bool manual = false,
    bool restoration = false,
  }) async {
    if (manual) {
      final (canSync, secondLeft) = canManullySync();
      if (!canSync) {
        showFailureSnackbar(frequentSyncing(secondLeft));
        return false;
      }
      closeSnackbar();
    }

    _busy = true;
    emit(const CollectionSyncManagerState.syncingUnknown());
    try {
      if (_syncHours == null) return false;

      DateTime? syncEndTs;

      if (!restoration) {
        final latestSyncedItem =
            await collectionRepo.getLatestFromOthers(synced: true);
        latestSyncedItem.fold((l) {}, (item) {
          syncEndTs = item?.lastSynced;
        });
      }

      if (syncEndTs != null) await syncDeleted(syncEndTs!);

      if (state is CollectionSyncFailed) return false;
      await syncChanges(
        syncEndTs,
        manual: manual,
        restoration: restoration,
      );

      if (state is CollectionSyncFailed) return false;

      return state is CollectionSyncComplete;
    } finally {
      _busy = false;
    }
  }

  Future<void> syncDeleted(DateTime fromTs) async {
    // Fetch changes from server
    bool hasMore = true;
    int offset = 0;

    emit(const CollectionSyncManagerState.syncingUnknown());
    while (hasMore) {
      final result = await syncRepo.getDeletedClipCollections(
        limit: 1000,
        lastSynced: _lastSyncedTime(fromTs),
        offset: offset,
        excludeDeviceId: deviceId,
      );

      await result.fold((l) async {
        emit(CollectionSyncManagerState.failed(l));
      }, (r) async {
        hasMore = r.hasMore;
        offset += r.results.length;

        final items = r.results;
        if (items.isEmpty) return;

        final deletedItems = await collectionRepo.deleteMany(items);
        deletedItems.fold((l) {
          logger.e(l);
        }, (deletedItems) {
          final syncEvents = deletedItems
              .map((item) => (CrossSyncEventType.delete, item))
              .toList();
          broadcastBatchEvent(syncEvents);
        });
      });

      if (result.isLeft()) break;
    }
  }

  Future<void> syncChanges(
    DateTime? syncEndTs, {
    required bool manual,
    required bool restoration,
  }) async {
    // Fetch changes from server
    bool hasMore = true;
    int offset = 0;

    bool failed = false;
    int syncedCount = 0;

    final collectionMapping = collectionCubit.serverMapping;

    while (hasMore && !failed) {
      emit(CollectionSyncManagerState.syncing(synced: syncedCount));
      final result = await syncRepo.getLatestClipCollections(
        limit: 250,
        lastSynced: _lastSyncedTime(syncEndTs),
        offset: offset,
        excludeDeviceId: syncEndTs != null ? deviceId : null,
      );

      await result.fold((l) async {
        emit(CollectionSyncManagerState.failed(l));
        failed = true;
      }, (r) async {
        hasMore = r.hasMore;
        offset += r.results.length;
        final items = r.results;

        if (items.isEmpty) return;

        final syncEvents = <CollectionCrossSyncEvent>[];
        for (var item in items) {
          final serverId = item.serverId;
          final localId = collectionMapping[serverId];
          if (localId != null) {
            syncEvents.add((CrossSyncEventType.update, item));
            item.id = localId;
          } else {
            syncEvents.add((CrossSyncEventType.create, item));
          }
        }

        final collections = await collectionRepo.updateMany(items);

        collections.fold((l) {
          emit(CollectionSyncManagerState.failed(l));
          failed = true;
        }, (collections) {
          syncedCount = collections.length;
          for (var i = 0; i < collections.length; i++) {
            syncEvents[i].$2.id = collections[i].id;
          }
          broadcastBatchEvent(syncEvents);
        });
      });
      await wait(250);
    }

    if (failed) return;
    emit(CollectionSyncManagerState.synced(
      syncedCount,
      manual: manual,
      restoration: restoration,
    ));
  }

  void broadcastBatchEvent(List<CollectionCrossSyncEvent> events) {
    eventBus.batchCollectionSync(events);
  }

  DateTime? _lastSyncedTime(DateTime? relativeTo) {
    if (relativeTo == null) return null;

    final diff = now().difference(relativeTo);
    if (diff.inHours < syncHours) {
      return relativeTo;
    }
    return null;
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}
