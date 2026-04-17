part of 'sync_status_cubit.dart';

@freezed
class SyncStatusState with _$SyncStatusState {
  const factory SyncStatusState.unknown() = SyncStatusUnknown;
  const factory SyncStatusState.syncing() = SyncingStatus;
  const factory SyncStatusState.complete() = SyncStatusComplete;
  const factory SyncStatusState.failed(Failure failure) = SyncStatusFailed;
}
