part of 'realtime_collection_sync_cubit.dart';

@freezed
class RealtimeCollectionSyncState with _$RealtimeCollectionSyncState {
  const factory RealtimeCollectionSyncState.initial() =
      RealtimeCollectionSyncUnknown;
  const factory RealtimeCollectionSyncState.connecting() =
      RealtimeCollectionSyncConnecting;

  const factory RealtimeCollectionSyncState.connected() =
      RealtimeCollectionSyncConnected;
  const factory RealtimeCollectionSyncState.disconnected() =
      RealtimeCollectionSyncDisconnected;
}
