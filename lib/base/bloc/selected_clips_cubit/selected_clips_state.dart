part of 'selected_clips_cubit.dart';

@freezed
sealed class SelectedClipsState with _$SelectedClipsState {
  const factory SelectedClipsState.noClipSelected() = NoClipSelected;
  const factory SelectedClipsState.clipSelected({
    required Set<ClipboardItem> selectedClipIds,
  }) = ClipSelected;
}
