import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:clipboard/base/bloc/clip_collection_cubit/clip_collection_cubit.dart';
import 'package:clipboard/base/bloc/event_bus_cubit/event_bus_cubit.dart';
import 'package:clipboard/base/constants/numbers/duration.dart';
import 'package:clipboard/base/constants/strings/asset_constants.dart';
import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/db/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/repositories/clip_collection.dart';
import 'package:clipboard/base/domain/repositories/clipboard.dart';
import 'package:clipboard/base/domain/repositories/sync_clipboard.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/utils/snackbar.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:easy_worker/easy_worker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart' show Platform;

part 'clip_sync_manager_cubit.freezed.dart';
part 'clip_sync_manager_state.dart';

void _syncingClips(
  (List<ClipboardItem>, Map<int, int>) record,
  Sender send,
) async {
  final Isar db = Isar.getInstance(dbName)!;

  final events = <ClipCrossSyncEvent>[];
  var (items, collectionMap) = record;

  db.writeTxnSync(() {
    for (var index = 0; index < items.length; index++) {
      var item = items[index];
      final found = db.clipboardItems
          .filter()
          .serverIdEqualTo(item.serverId)
          .findFirstSync();
      final collectionId = collectionMap[item.serverCollectionId];
      if (found == null) {
        item = item.copyWith(
          collectionId: collectionId,
          lastSynced: now(),
        );
        items[index] = item;
        events.add((CrossSyncEventType.create, item));
        continue;
      }
      item = item.copyWith(
        lastSynced: now(),
        localPath: found.localPath,
        collectionId: collectionId,
      )..applyId(found);
      items[index] = item;
      events.add((CrossSyncEventType.update, item));
    }

    final ids = db.clipboardItems.putAllSync(items);
    for (int i = 0; i < events.length; i++) {
      events[i].$2.id = ids[i];
    }
  });

  send(events);
}

final _clipSyncWorker =
    EasyCompute<List<ClipCrossSyncEvent>, (List<ClipboardItem>, Map<int, int>)>(
  ComputeEntrypoint(
    _syncingClips,
    initData: {
      "token": ServicesBinding.rootIsolateToken,
    },
    onInit: (payload) async {
      if (payload is Map) {
        final token = payload["token"];
        if (token != null) {
          BackgroundIsolateBinaryMessenger.ensureInitialized(token);
        }
        String? dbPath = Platform.environment[dbPathEnvKey];
        dbPath = dbPath ?? (await getApplicationDocumentsDirectory()).path;
        Isar.openSync(
          [ClipboardItemSchema],
          directory: dbPath,
          relaxedDurability: true,
          inspector: kDebugMode,
          name: dbName,
        );
      }
    },
  ),
  workerName: "ClipSyncWorker",
);

@injectable
class ClipSyncManagerCubit extends Cubit<ClipSyncManagerState> {
  final EventBusCubit eventBus;
  final String deviceId;
  final ClipCollectionCubit collectionCubit;
  final ClipboardRepository clipboardRepository;
  final ClipCollectionRepository clipCollectionRepository;
  final SyncRepository syncRepo;

  Timer? _pollingTimer;
  int? _syncHours, _manualDelay;
  bool _busy = false;
  DateTime? lastSynced;

  ClipSyncManagerCubit(
    this.eventBus,
    this.syncRepo,
    this.collectionCubit,
    @Named("local") this.clipboardRepository,
    this.clipCollectionRepository,
    @Named("device_id") this.deviceId,
  ) : super(const ClipSyncManagerState.unknown());

  int get syncHours => _syncHours ?? 0;

  /// Range: 5s -> 15s
  int get manualDelay => min(max(_manualDelay ?? 15, $5S), 15);

  void changeConfig({int? syncHours, int? manualDelay, bool? disabled}) {
    if (syncHours != null) _syncHours = syncHours;
    if (manualDelay != null) _manualDelay = manualDelay;
    if (disabled != null) {
      if (disabled) {
        emit(const ClipSyncManagerState.disabled());
      } else {
        emit(const ClipSyncManagerState.unknown());
      }
    }
  }

  void reset() => emit(const ClipSyncManagerState.unknown());

  void startPolling() {
    if (_pollingTimer != null) return;
    _pollingTimer = Timer.periodic(
      const Duration(seconds: $45S),
      (_) => !_busy ? syncClips() : null,
    );
  }

  void stopPolling() {
    if (_pollingTimer == null) return;
    _pollingTimer?.cancel();
  }

  (bool, int) canManuallySync() {
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

  Future<bool> syncClips({
    bool manual = false,
    DateTime? syncStartTs,
    int lastSyncedCount = 0,
    bool restoration = false,
  }) async {
    if (manual) {
      final (canSync, secondLeft) = canManuallySync();
      if (!canSync) {
        showFailureSnackbar(frequentSyncing(secondLeft));
        return false;
      }
      closeSnackbar();
    }

    _busy = true;
    emit(const ClipSyncManagerState.syncingUnknown());
    try {
      if (_syncHours == null) return false;

      DateTime? syncEndTs;

      if (!restoration) {
        final latestSyncedItem =
            await clipboardRepository.getLatestFromOthers(synced: true);
        latestSyncedItem.fold((l) {}, (item) {
          syncEndTs = item?.lastSynced;
        });
      }

      if (syncEndTs != null) await syncDeleted(syncEndTs!);

      if (state is ClipSyncFailed) return false;
      await syncChanges(syncEndTs, syncStartTs, lastSyncedCount);

      if (state is ClipSyncFailed) return false;

      return state is ClipSyncComplete;
    } finally {
      _busy = false;
    }
  }

  Future<void> syncDeleted(DateTime syncEndTs) async {
    // Fetch changes from server
    bool hasMore = true;
    int offset = 0;

    emit(const ClipSyncManagerState.syncingUnknown());
    while (hasMore) {
      final result = await syncRepo.getDeletedClipboardItems(
        limit: 1000,
        lastSynced: getLastSyncedTime(syncEndTs),
        offset: offset,
        excludeDeviceId: deviceId,
      );

      await result.fold((l) async {
        emit(ClipSyncManagerState.failed(l));
      }, (r) async {
        hasMore = r.hasMore;
        offset += r.results.length;

        final items = r.results;
        if (items.isEmpty) return;

        final deletedItems = await clipboardRepository.deleteMany(items);
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
    DateTime? syncEndTs, [
    DateTime? syncStartTs,
    int lastSyncedCount = 0,
  ]) async {
    await _clipSyncWorker.waitUntilReady();
    // Fetch changes from server
    bool hasMore = true;
    int offset = 0;
    bool havingCollection = syncEndTs == null; // first time syncing after login

    DateTime fromTs = syncStartTs ?? now();
    bool failed = false;
    int syncedCount = lastSyncedCount;

    final collectionMapping = collectionCubit.serverMapping;

    final lastSynced = getLastSyncedTime(syncEndTs);

    while (hasMore && !failed) {
      emit(ClipSyncManagerState.syncing(
        synced: syncedCount,
        fromTs: fromTs,
        toTs: lastSynced,
      ));
      final result = await syncRepo.getLatestClipboardItems(
        limit: 500,
        from: havingCollection ? null : syncStartTs,
        lastSynced: havingCollection ? null : lastSynced,
        offset: offset,
        excludeDeviceId: syncEndTs != null ? deviceId : null,
        havingCollection: havingCollection,
      );

      await result.fold((l) async {
        emit(ClipSyncManagerState.failed(l));
        failed = true;
      }, (r) async {
        if (!r.hasMore && havingCollection) {
          hasMore = true;
          offset = 0;
          havingCollection = false;
        } else {
          hasMore = r.hasMore;
          offset += r.results.length;
        }
        // Apply changes to local db
        final items = r.results;

        if (items.isEmpty) return;

        final syncEvents = await _clipSyncWorker.compute(
          (items, collectionMapping),
        );
        syncedCount += syncEvents.length;
        broadcastBatchEvent(syncEvents);
        fromTs = syncEvents.lastOrNull?.$2.modified ?? fromTs;
      });
      await wait(350);
    }

    if (failed) return;
    emit(ClipSyncManagerState.synced(
      syncedCount,
      fromTs: fromTs,
      toTs: lastSynced,
    ));
  }

  void broadcastBatchEvent(List<ClipCrossSyncEvent> events) {
    eventBus.batchClipSync(events);
  }

  DateTime getLastSyncedTime([DateTime? relativeTo]) {
    if (relativeTo != null) {
      final diff = now().difference(relativeTo);
      if (diff.inHours < syncHours) {
        return relativeTo;
      }
    }

    final pastDate = now().subtract(Duration(hours: syncHours));
    return pastDate;
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}
