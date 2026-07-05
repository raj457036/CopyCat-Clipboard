part of 'event_bus_cubit.dart';

@freezed
abstract class EventBusState with _$EventBusState {
  // empty event bus
  const factory EventBusState.empty() = _Empty;

  // non-sync events

  const factory EventBusState.keyboard(KeyboardShortcutEvent event) =
      EventBusKeyboardEvent;
  const factory EventBusState.indexPaste(int index) = EventBusIndexPasteEvent;
}
