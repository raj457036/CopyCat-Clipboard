import 'dart:async';
import 'package:clipboard/base/domain/model/syncable.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:injectable/injectable.dart';

abstract class SyncEvent {}

class TypedSyncEvent<T extends Syncable> implements SyncEvent {
  final CrossSyncEvent<T> event;
  TypedSyncEvent(this.event);
}

class TypedSyncBatchEvent<T extends Syncable> implements SyncEvent {
  final List<CrossSyncEvent<T>> events;
  TypedSyncBatchEvent(this.events);
}

/// A lossless stream-based event bus for sync events.
///
/// This replaces the sync-related parts of EventBusCubit which could drop
/// events due to Bloc's state transition mechanics on rapid emissions.
@singleton
class SyncEventBus {
  final _controller = StreamController<SyncEvent>.broadcast();

  Stream<SyncEvent> get stream => _controller.stream;

  /// Listen for events of a specific entity type.
  Stream<SyncEvent> where<T extends Syncable>() {
    return _controller.stream.where(
      (e) => e is TypedSyncEvent<T> || e is TypedSyncBatchEvent<T>,
    );
  }

  void emit<T extends Syncable>(CrossSyncEvent<T> event) {
    _controller.add(TypedSyncEvent<T>(event));
  }

  void emitBatch<T extends Syncable>(List<CrossSyncEvent<T>> events) {
    _controller.add(TypedSyncBatchEvent<T>(events));
  }

  void dispose() {
    _controller.close();
  }
}
