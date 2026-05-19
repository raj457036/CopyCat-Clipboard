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
    // Number of collections the user's current plan allows to be active/editable.
    // Collections at index >= activeLimit are read-only.
    @Default(defaultCollectionCount) int activeLimit,
    Failure? failure,
  }) = ClipCollectionLoaded;
}

/// Single source of truth for the plan-gated read-only check.
/// UI should call this instead of comparing indices against [activeLimit] directly.
extension ClipCollectionLoadedX on ClipCollectionLoaded {
  bool isReadOnly(ClipCollection collection) {
    if (collection.id == null) return false;
    final idx = collections.indexWhere((c) => c.id == collection.id);
    return idx >= 0 && idx >= activeLimit;
  }
}
