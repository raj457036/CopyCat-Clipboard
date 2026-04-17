import 'dart:async';
import 'dart:collection';

import 'package:clipboard/base/domain/model/clip_collection/clipcollection.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';

enum CrossSyncEventType { create, update, delete }

typedef CrossSyncEvent<T> = (CrossSyncEventType, T);

enum CrossSyncListenerStatus {
  unknown,
  connecting,
  connected,
  error,
  disconnected,
}

typedef CrossSyncStatusEvent = (CrossSyncListenerStatus, Object? object);

abstract class CrossSyncListener<T> {
  /// Start the service
  Future<void> start();

  /// Stop the service
  Future<void> stop();

  /// Reconnect to the service
  Future<void> reconnect();
  Stream<CrossSyncStatusEvent> get onStatusChange;
  Queue<CrossSyncEvent<T>> get changesQueue;

  bool get isInitiated;
}

typedef ClipCrossSyncEvent = CrossSyncEvent<ClipboardItem>;

abstract class ClipCrossSyncListener extends CrossSyncListener<ClipboardItem> {}

typedef CollectionCrossSyncEvent = CrossSyncEvent<ClipCollection>;

abstract class CollectionCrossSyncListener
    extends CrossSyncListener<ClipCollection> {}
