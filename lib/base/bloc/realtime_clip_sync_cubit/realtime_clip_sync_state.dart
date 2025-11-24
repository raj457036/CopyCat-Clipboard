part of 'realtime_clip_sync_cubit.dart';

@freezed
class RealtimeClipSyncState with _$RealtimeClipSyncState {
  const factory RealtimeClipSyncState.initial() = RealtimeClipSyncUnknown;
  const factory RealtimeClipSyncState.connecting() = RealtimeClipSyncConnecting;

  const factory RealtimeClipSyncState.connected() = RealtimeClipSyncConnected;
  const factory RealtimeClipSyncState.disconnected() =
      RealtimeClipSyncDisconnected;
}
