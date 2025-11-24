import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clipboard/base/bloc/event_bus_cubit/event_bus_cubit.dart';
import 'package:clipboard/base/domain/repositories/clip_collection.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:clipboard/common/logging.dart';
import 'package:flutter/material.dart' show Durations;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'realtime_collection_sync_cubit.freezed.dart';
part 'realtime_collection_sync_state.dart';

@injectable
class RealtimeCollectionSyncCubit extends Cubit<RealtimeCollectionSyncState> {
  final EventBusCubit eventBus;
  final CollectionCrossSyncListener listener;
  final ClipCollectionRepository collectionRepo;
  bool _subscribed = false;

  StreamSubscription? statusSubscription;
  DateTime? _disconnectedAt;

  RealtimeCollectionSyncCubit(
    this.eventBus,
    this.listener,
    this.collectionRepo,
  ) : super(const RealtimeCollectionSyncState.initial()) {
    statusSubscription = listener.onStatusChange.listen(onStatusChange);
  }

  bool get isSubscribed => _subscribed;

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
    emit(const RealtimeCollectionSyncState.connecting());
    final (status, obj) = event;
    logger.w("Status Change");
    logger.w(status);
    logger.w(obj);

    switch (status) {
      case CrossSyncListenerStatus.connecting:
        _disconnectedAt = null;
      case CrossSyncListenerStatus.connected:
        emit(const RealtimeCollectionSyncState.connected());
        _disconnectedAt = null;
      default:
        emit(const RealtimeCollectionSyncState.disconnected());
        _disconnectedAt ??= DateTime.now();
        Future.delayed(const Duration(seconds: 10), scheduleReconnect);
    }
  }

  Future<void> onSync(CollectionCrossSyncEvent event) async {
    var (type, item) = event;
    logger.w("Sync Change");
    logger.w(type);
    logger.w(item);

    final result = await collectionRepo.updateOrCreate(item);
    result.fold((failure) {}, (item) {
      eventBus.collectionSync((type, item));
    });
  }

  @override
  Future<void> close() {
    unsubscribe();
    _clearSubs();
    return super.close();
  }
}
