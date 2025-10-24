part of 'clip_collection_cubit.dart';

@freezed
sealed class ClipCollectionState with _$ClipCollectionState {
  const factory ClipCollectionState.loaded({
    required List<ClipCollection> collections,
    @Default(true) bool hasMore,
    @Default(false) bool isLoading,
    @Default(50) int limit,
    @Default(0) int offset,
    @Default(true) bool loading,
    @Default(false) bool syncing,
    Failure? failure,
  }) = ClipCollectionLoaded;
}
