import 'dart:async';
import 'package:clipboard/common/failure.dart';
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

class SyncProgressParams {
  /// The entity type this progress update is for.
  final String entityType;

  /// Total number of items synced so far for the current sync session.
  final int syncedCount;

  /// Number of items fetched in the latest batch.
  final int fetchCount;

  /// Total number of items to be synced, if known.
  final int? totalCount;

  const SyncProgressParams({
    required this.entityType,
    required this.syncedCount,
    required this.fetchCount,
    this.totalCount,
  });
}

class SyncProgressEvent implements SyncEvent {
  final SyncProgressParams params;
  SyncProgressEvent(this.params);
}

class SyncEngineStatusUpdateEvent implements SyncEvent {
  final String entityType;
  final bool isBusy;
  SyncEngineStatusUpdateEvent(this.entityType, this.isBusy);
}

class SyncOutboxFailureEvent implements SyncEvent {
  final String entityType;
  final int outboxEntryId;
  final Failure failure;

  SyncOutboxFailureEvent({
    required this.entityType,
    required this.outboxEntryId,
    required this.failure,
  });
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

  void emitProgress(SyncProgressParams params) {
    _controller.add(SyncProgressEvent(params));
  }

  void emitEngineStatus(String entityType, bool isBusy) {
    _controller.add(SyncEngineStatusUpdateEvent(entityType, isBusy));
  }

  void emitOutboxFailure({
    required String entityType,
    required int outboxEntryId,
    required Failure failure,
  }) {
    _controller.add(
      SyncOutboxFailureEvent(
        entityType: entityType,
        outboxEntryId: outboxEntryId,
        failure: failure,
      ),
    );
  }

  void dispose() {
    _controller.close();
  }
}
