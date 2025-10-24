import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clipboard/base/bloc/event_bus_cubit/event_bus_cubit.dart';
import 'package:clipboard/base/domain/repositories/clip_collection.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:clipboard/common/logging.dart';
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

  StreamSubscription? statusSubscription, changeSubscription;

  RealtimeCollectionSyncCubit(
    this.eventBus,
    this.listener,
    this.collectionRepo,
  ) : super(const RealtimeCollectionSyncState.initial()) {
    statusSubscription = listener.onStatusChange.listen(onStatusChange);
    changeSubscription = listener.onChange.listen(onSync);
  }

  bool get isSubscribed => _subscribed;

  void _clearSubs() {
    changeSubscription?.cancel();
    statusSubscription?.cancel();
  }

  void subscribe() {
    if (_subscribed) {
      listener.reconnect();
      return;
    }
    listener.start();
    _subscribed = true;
  }

  void unsubscribe() {
    if (!_subscribed) return;
    listener.stop();
    _subscribed = false;
  }

  void onStatusChange(CrossSyncStatusEvent event) {
    emit(const RealtimeCollectionSyncState.connecting());
    final (status, obj) = event;
    logger.w("Status Change");
    logger.w(status);
    logger.w(obj);

    switch (status) {
      case CrossSyncListenerStatus.connected:
        emit(const RealtimeCollectionSyncState.connected());
      default:
        emit(const RealtimeCollectionSyncState.disconnected());
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
