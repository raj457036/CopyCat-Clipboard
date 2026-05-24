part of 'offline_persistance_cubit.dart';

@freezed
class OfflinePersistanceState with _$OfflinePersistanceState {
  const factory OfflinePersistanceState.initial() = OfflinePersistanceInitial;
  const factory OfflinePersistanceState.saved({
    @Default(0) int count,
    @Default(false) bool created,
    @Default(false) bool synced,
    List<String>? updatedFields,
  }) = OfflinePersistanceSaved;
  const factory OfflinePersistanceState.error(
    Failure failure, [
    ClipboardItem? item,
  ]) = OfflinePersistanceError;
}
