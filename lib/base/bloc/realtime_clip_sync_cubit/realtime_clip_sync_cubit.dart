import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clipboard/base/bloc/event_bus_cubit/event_bus_cubit.dart';
import 'package:clipboard/base/domain/repositories/clip_collection.dart';
import 'package:clipboard/base/domain/repositories/clipboard.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'realtime_clip_sync_cubit.freezed.dart';
part 'realtime_clip_sync_state.dart';

@injectable
class RealtimeClipSyncCubit extends Cubit<RealtimeClipSyncState> {
  final EventBusCubit eventBus;
  final ClipCrossSyncListener listener;
  final ClipboardRepository clipRepo;
  final ClipCollectionRepository collectionRepo;
  bool _subscribed = false;

  StreamSubscription? statusSubscription;
  DateTime? _disconnectedAt;

  RealtimeClipSyncCubit(
    this.listener,
    this.eventBus,
    @Named("local") this.clipRepo,
    this.collectionRepo,
  ) : super(const RealtimeClipSyncState.initial()) {
    statusSubscription = listener.onStatusChange.listen(onStatusChange);
  }

  Future<void> _processPeriodic() async {
    if (!_subscribed) return;
    while (listener.changesQueue.isNotEmpty) {
      final event = listener.changesQueue.removeFirst();
      await onSync(event);
    }
    Future.delayed(Durations.medium2, _processPeriodic);
  }

  void _clearSubs() {
    statusSubscription?.cancel();
  }

  void subscribe() {
    if (_subscribed) {
      listener.reconnect();
      return;
    }
    listener.start();
    _subscribed = true;
    _processPeriodic();
  }

  void unsubscribe() {
    if (!_subscribed) return;
    listener.stop();
    _subscribed = false;
  }

  Future<void> scheduleReconnect() async {
    if (!_subscribed || _disconnectedAt == null) return;
    _disconnectedAt = null;
    await listener.reconnect();
  }

  void onStatusChange(CrossSyncStatusEvent event) {
    final (status, obj) = event;
    logger.w("Status Change");
    logger.w(status);
    logger.w(obj);
    switch (status) {
      case CrossSyncListenerStatus.connecting:
        emit(const RealtimeClipSyncState.connecting());
        _disconnectedAt = null;
      case CrossSyncListenerStatus.connected:
        emit(const RealtimeClipSyncState.connected());
        _disconnectedAt = null;
      default:
        emit(const RealtimeClipSyncState.disconnected());
        _disconnectedAt ??= DateTime.now();
        Future.delayed(const Duration(seconds: 10), scheduleReconnect);
    }
  }

  Future<void> onSync(ClipCrossSyncEvent event) async {
    var (type, item) = event;
    logger.w("Sync Change");
    logger.w(type);
    logger.w(item);

    if (item.serverCollectionId != null) {
      final collection =
          await collectionRepo.get(serverId: item.serverCollectionId);

      collection.fold((failure) {}, (collection) {
        if (collection != null) {
          item = item.copyWith(collectionId: collection.id);
        }
      });
    }

    final result = await clipRepo.updateOrCreate(item);
    result.fold(showFailureSnackbar, (updated) async {
      eventBus.clipSync((type, updated));
    });
  }

  @override
  Future<void> close() {
    unsubscribe();
    _clearSubs();
    return super.close();
  }
}
