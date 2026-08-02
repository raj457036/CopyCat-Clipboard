import 'dart:async';

import 'package:clipboard/base/constants/strings.dart';
import 'package:clipboard/base/domain/model/clip_collection/clipcollection.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

mixin SBCrossSyncListenerStatusChangeMixin<T> {
  CrossSyncListenerStatus _lastStatus = CrossSyncListenerStatus.unknown;

  final _statusEvents = StreamController<CrossSyncStatusEvent>.broadcast();
  final _changesStream = StreamController<CrossSyncEvent<T>>.broadcast();

  Future<T?> castToType(Object? obj);

  void _onStatusChange(RealtimeSubscribeStatus status, Object? obj) {
    switch (status) {
      case RealtimeSubscribeStatus.subscribed:
        _lastStatus = CrossSyncListenerStatus.connected;
        _statusEvents.add((CrossSyncListenerStatus.connected, obj));
      case RealtimeSubscribeStatus.channelError:
        _lastStatus = CrossSyncListenerStatus.error;
        _statusEvents.add((CrossSyncListenerStatus.error, obj));
      case RealtimeSubscribeStatus.closed || RealtimeSubscribeStatus.timedOut:
        _lastStatus = CrossSyncListenerStatus.disconnected;
        _statusEvents.add((CrossSyncListenerStatus.disconnected, obj));
    }
  }

  Future<void> _onChange(PostgresChangePayload payload) async {
    try {
      switch (payload.eventType) {
        case PostgresChangeEvent.insert:
          final item = await castToType(payload.newRecord);
          if (item != null) {
            _changesStream.add((CrossSyncEventType.create, item));
          }
        case PostgresChangeEvent.update:
          final item = await castToType(payload.newRecord);
          if (item != null) {
            _changesStream.add((CrossSyncEventType.update, item));
          }
        case PostgresChangeEvent.delete:
          // For delete, oldRecord should contain the deleted item's ID at minimum.
          final item = await castToType(payload.oldRecord);
          if (item != null) {
            _changesStream.add((CrossSyncEventType.delete, item));
          }
        default:
      }
    } catch (e, stack) {
      logger.e("Error processing realtime change: $e", stackTrace: stack);
    }
  }
}

@LazySingleton(as: ClipCrossSyncListener)
class SBClipCrossSyncListener
    with SBCrossSyncListenerStatusChangeMixin<ClipboardItem>
    implements ClipCrossSyncListener {
  RealtimeChannel? _channel;

  final String channelID = "clips-rtc";

  final SupabaseClient client;
  final String deviceId;

  SBClipCrossSyncListener(this.client, @Named("device_id") this.deviceId) {
    _statusEvents.add((CrossSyncListenerStatus.unknown, null));
  }

  @override
  Future<void> start() async {
    if (isInitiated) return;
    _statusEvents.add((CrossSyncListenerStatus.connecting, null));
    _channel = client.channel(
      channelID,
      opts: const RealtimeChannelConfig(ack: false),
    );
    _channel
        ?.onPostgresChanges(
          schema: 'public',
          event: PostgresChangeEvent.all,
          table: clipItemTable,
          callback: _onChange,
        )
        .subscribe(_onStatusChange);
  }

  @override
  get onStatusChange => _statusEvents.stream;

  @override
  Future<void> reconnect() async {
    if (!isInitiated || _lastStatus == CrossSyncListenerStatus.connected) {
      return;
    }
    await stop();
    await wait(const Duration(seconds: 1).inMilliseconds);
    await start();
  }

  @override
  Future<void> stop() async {
    if (!isInitiated) return;
    final result = await _channel?.unsubscribe();
    if (result == "ok") {
      _channel = null;
      _statusEvents.add((CrossSyncListenerStatus.disconnected, null));
    }
  }

  @override
  bool get isInitiated => _channel != null;

  @override
  get onChangeEvent => _changesStream.stream;

  @override
  Future<ClipboardItem?> castToType(Object? obj) async {
    try {
      if (obj == null) return null;
      final item = ClipboardItem.fromJson(obj as Map<String, dynamic>);
      if (item.locked) return item;
      return await item.decrypt();
    } catch (e) {
      logger.e("Error casting/decrypting ClipboardItem: $e");
      return null;
    }
  }
}

@LazySingleton(as: CollectionCrossSyncListener)
class SBCollectionCrossSyncListener
    with SBCrossSyncListenerStatusChangeMixin<ClipCollection>
    implements CollectionCrossSyncListener {
  RealtimeChannel? _channel;

  final String channelID = "collection-rtc";

  final SupabaseClient client;
  final String deviceId;

  SBCollectionCrossSyncListener(
    this.client,
    @Named("device_id") this.deviceId,
  ) {
    _statusEvents.add((CrossSyncListenerStatus.unknown, null));
  }

  @override
  Future<void> start() async {
    if (isInitiated) return;
    _statusEvents.add((CrossSyncListenerStatus.connecting, null));
    _channel = client.channel(
      channelID,
      opts: const RealtimeChannelConfig(ack: false),
    );

    _channel
        ?.onPostgresChanges(
          schema: 'public',
          event: PostgresChangeEvent.all,
          table: clipCollectionTable,
          callback: _onChange,
        )
        .subscribe(_onStatusChange);
  }

  @override
  get onChangeEvent => _changesStream.stream;

  @override
  Future<ClipCollection?> castToType(Object? obj) async {
    try {
      if (obj == null) return null;
      return ClipCollection.fromJson(obj as Map<String, dynamic>);
    } catch (e) {
      logger.e("Error casting ClipCollection: $e");
      return null;
    }
  }

  @override
  get onStatusChange => _statusEvents.stream;

  @override
  Future<void> reconnect() async {
    // Reconnect only if not connected
    if (!isInitiated || _lastStatus == CrossSyncListenerStatus.connected) {
      return;
    }
    await stop();
    await wait(const Duration(seconds: 1).inMilliseconds);
    await start();
  }

  @override
  Future<void> stop() async {
    if (!isInitiated) return;
    if (await _channel?.unsubscribe() == "ok") {
      _channel = null;
      _statusEvents.add((CrossSyncListenerStatus.disconnected, null));
    }
  }

  @override
  bool get isInitiated => _channel != null;
}
