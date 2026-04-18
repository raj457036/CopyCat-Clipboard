import 'package:bloc/bloc.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'selected_clips_cubit.freezed.dart';
part 'selected_clips_state.dart';

@injectable
class SelectedClipsCubit extends Cubit<SelectedClipsState> {
  SelectedClipsCubit() : super(const SelectedClipsState.noClipSelected());

  bool multiSelectMode = false;

  bool get hasSelection =>
      state is ClipSelected &&
      (state as ClipSelected).selectedClipIds.isNotEmpty;

  List<ClipboardItem> _dedupeKeepOrder(List<ClipboardItem> items) {
    final deduped = <ClipboardItem>[];
    for (final item in items) {
      if (!deduped.contains(item)) {
        deduped.add(item);
      }
    }
    return deduped;
  }

  List<ClipboardItem> _appendMissing(
    List<ClipboardItem> base,
    Iterable<ClipboardItem> candidates,
  ) {
    final result = List<ClipboardItem>.from(base);
    for (final clip in candidates) {
      if (!result.contains(clip)) {
        result.add(clip);
      }
    }
    return result;
  }

  void selectAll(List<ClipboardItem> allClips) {
    emit(
      SelectedClipsState.clipSelected(
        selectedClipIds: _dedupeKeepOrder(allClips),
      ),
    );
  }

  void select(ClipboardItem clip, {List<ClipboardItem>? selectableItems}) {
    switch (state) {
      case NoClipSelected():
        emit(SelectedClipsState.clipSelected(selectedClipIds: [clip]));
      case ClipSelected(:final selectedClipIds):
        {
          if (multiSelectMode &&
              selectableItems != null &&
              selectableItems.isNotEmpty) {
            final lastItem = selectedClipIds.last;
            final lastIndex = selectableItems.indexOf(lastItem);
            final currentIndex = selectableItems.indexOf(clip);
            if (lastIndex != -1 && currentIndex != -1) {
              final start = lastIndex < currentIndex ? lastIndex : currentIndex;
              final end = lastIndex > currentIndex ? lastIndex : currentIndex;
              final rangeSelected = selectableItems.sublist(start, end + 1);

              final newSelectedClipIds = _appendMissing(
                selectedClipIds,
                lastIndex < currentIndex
                    ? rangeSelected
                    : rangeSelected.reversed,
              );
              emit(
                SelectedClipsState.clipSelected(
                  selectedClipIds: newSelectedClipIds,
                ),
              );
              return;
            }
          }
          final newSelectedClipIds = _appendMissing(selectedClipIds, [clip]);
          emit(
            SelectedClipsState.clipSelected(
              selectedClipIds: newSelectedClipIds,
            ),
          );
        }
    }
  }

  void unselect(ClipboardItem clip) {
    switch (state) {
      case ClipSelected(:final selectedClipIds):
        if (selectedClipIds.contains(clip)) {
          final newSelectedClipIds = List<ClipboardItem>.from(selectedClipIds)
            ..removeWhere((item) => item == clip);
          if (newSelectedClipIds.isEmpty) {
            emit(const SelectedClipsState.noClipSelected());
            return;
          }
          emit(
            SelectedClipsState.clipSelected(
              selectedClipIds: newSelectedClipIds,
            ),
          );
        }
      case _:
    }
  }

  void clear() {
    emit(const SelectedClipsState.noClipSelected());
  }

  bool isSelected(ClipboardItem clip) {
    return switch (state) {
      NoClipSelected() => false,
      ClipSelected(:final selectedClipIds) => selectedClipIds.contains(clip),
    };
  }
}
