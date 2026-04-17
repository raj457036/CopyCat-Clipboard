import 'package:bloc/bloc.dart';

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

  void keyboard(String event) =>
      emit(EventBusState.keyboard(KeyboardShortcutEvent(name: event)));
  void indexPaste(int index) => emit(EventBusState.indexPaste(index));
}
