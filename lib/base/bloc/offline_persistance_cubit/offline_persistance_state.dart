part of 'offline_persistance_cubit.dart';

@freezed
class OfflinePersistanceState with _$OfflinePersistanceState {
  const factory OfflinePersistanceState.initial() = OfflinePersistanceInitial;
  const factory OfflinePersistanceState.creatingItems(
      List<ClipboardItem> items) = OfflinePersistanceCreating;
  const factory OfflinePersistanceState.updatingItems(
      List<ClipboardItem> items) = OfflinePersistanceUpdating;
  const factory OfflinePersistanceState.deletingItems(
      List<ClipboardItem> items) = OfflinePersistanceDeleting;
  const factory OfflinePersistanceState.deletedItems(
      List<ClipboardItem> items) = OfflinePersistanceDeleted;
  const factory OfflinePersistanceState.saved(
    List<ClipboardItem> items, {
    @Default(false) bool created,
    @Default(false) bool synced,
    List<String>? updatedFields,
  }) = OfflinePersistanceSaved;
  const factory OfflinePersistanceState.error(Failure failure,
      [ClipboardItem? item]) = OfflinePersistanceError;
}
