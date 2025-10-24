part of 'event_bus_cubit.dart';

@freezed
class EventBusState with _$EventBusState {
  // empty event bus
  const factory EventBusState.empty() = _Empty;

  // realtime events
  const factory EventBusState.clipSync(ClipCrossSyncEvent event) =
      EventBusClipCrossSyncEvent;
  const factory EventBusState.batchClipSync(List<ClipCrossSyncEvent> events) =
      EventBusBatchClipCrossSyncEvent;
  const factory EventBusState.collectionSync(CollectionCrossSyncEvent event) =
      EventBusCollectionCrossSyncEvent;
  const factory EventBusState.batchCollectionSync(
          List<CollectionCrossSyncEvent> events) =
      EventBusBatchCollectionCrossSyncEvent;

  const factory EventBusState.keyboard(KeyboardShortcutEvent event) =
      EventBusKeyboardEvent;
  const factory EventBusState.indexPaste(int index) = EventBusIndexPasteEvent;
}
