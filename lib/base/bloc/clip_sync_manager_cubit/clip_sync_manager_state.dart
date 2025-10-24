part of 'clip_sync_manager_cubit.dart';

@freezed
sealed class ClipSyncManagerState with _$ClipSyncManagerState {
  const factory ClipSyncManagerState.disabled() = ClipSyncDisabled;
  const factory ClipSyncManagerState.unknown() = ClipSyncUnknown;
  const factory ClipSyncManagerState.syncingUnknown() = ClipSyncingUnknown;
  const factory ClipSyncManagerState.syncing({
    required int synced,
    required DateTime fromTs,
    required DateTime toTs,
  }) = ClipSyncing;
  const factory ClipSyncManagerState.synced(
    int syncCount, {
    required DateTime fromTs,
    required DateTime toTs,
  }) = ClipSyncComplete;
  const factory ClipSyncManagerState.failed(Failure failure) = ClipSyncFailed;
}
