part of 'sync_status_cubit.dart';

class SyncProgress {
  final int synced;
  final int total;
  const SyncProgress({required this.synced, required this.total});

  int get visibleSynced {
    if (total <= 0) return synced;
    return synced.clamp(0, total);
  }

  double? get progressValue {
    if (total <= 0) return null;
    return (synced / total).clamp(0.0, 1.0);
  }

  bool get isComplete => total > 0 && synced >= total;
}

@freezed
class SyncStatusState with _$SyncStatusState {
  const factory SyncStatusState.unknown() = SyncStatusUnknown;
  const factory SyncStatusState.syncing({
    @Default(<String, SyncProgress>{}) Map<String, SyncProgress> progress,
  }) = SyncingStatus;
  const factory SyncStatusState.decrypting({
    @Default(0) int decrypted,
    @Default(0) int total,
  }) = SyncStatusDecrypting;
  const factory SyncStatusState.complete({@Default(false) bool hasUpdates}) =
      SyncStatusComplete;
  const factory SyncStatusState.failed(Failure failure) = SyncStatusFailed;
  const factory SyncStatusState.disabled() = SyncStatusDisabled;
}
