import 'dart:async';

import 'package:clipboard/base/db/clip_collection/clipcollection.dart';
import 'package:clipboard/base/db/clipboard_item/clipboard_item.dart';

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
  Stream<CrossSyncEvent<T>> get onChange;
  Stream<CrossSyncStatusEvent> get onStatusChange;

  bool get isInitiated;
}

typedef ClipCrossSyncEvent = CrossSyncEvent<ClipboardItem>;

abstract class ClipCrossSyncListener extends CrossSyncListener<ClipboardItem> {}

typedef CollectionCrossSyncEvent = CrossSyncEvent<ClipCollection>;

abstract class CollectionCrossSyncListener
    extends CrossSyncListener<ClipCollection> {}
