import 'package:bloc/bloc.dart';
import 'package:clipboard/base/db/clip_collection/clipcollection.dart';
import 'package:clipboard/base/db/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'keyboard_shortcuts.dart';

part 'event_bus_cubit.freezed.dart';
part 'event_bus_state.dart';

@singleton
class EventBusCubit extends Cubit<EventBusState> {
  EventBusCubit() : super(const EventBusState.empty());

  void reset() {
    if (state is! _Empty) {
      emit(const EventBusState.empty());
    }
  }

  void clipSync(ClipCrossSyncEvent event) =>
      emit(EventBusState.clipSync(event));

  void batchClipSync(List<ClipCrossSyncEvent> events) =>
      emit(EventBusState.batchClipSync(events));

  void collectionSync(CollectionCrossSyncEvent event) =>
      emit(EventBusState.collectionSync(event));

  void batchCollectionSync(List<CollectionCrossSyncEvent> events) =>
      emit(EventBusState.batchCollectionSync(events));

  void keyboard(String event) => emit(
        EventBusState.keyboard(
          KeyboardShortcutEvent(name: event),
        ),
      );
  void indexPaste(int index) => emit(EventBusState.indexPaste(index));
}
