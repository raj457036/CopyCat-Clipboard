import 'dart:async';
import 'dart:collection';

import 'package:clipboard/base/constants/strings.dart';
import 'package:clipboard/base/db/clip_collection/clipcollection.dart';
import 'package:clipboard/base/db/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

mixin SBCrossSyncListenerStatusChangeMixin<T> {
  CrossSyncListenerStatus _lastStatus = CrossSyncListenerStatus.unknown;

  final _statusEvents = StreamController<CrossSyncStatusEvent>();
  final _changesQueue = Queue<CrossSyncEvent<T>>();

  T castToType(Object? obj);

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

  void _onChange(PostgresChangePayload payload) {
    switch (payload.eventType) {
      case PostgresChangeEvent.insert:
        _changesQueue.add(
          (
            CrossSyncEventType.create,
            castToType(payload.newRecord),
          ),
        );
      case PostgresChangeEvent.update:
        _changesQueue.add(
          (
            CrossSyncEventType.update,
            castToType(payload.newRecord),
          ),
        );
      case PostgresChangeEvent.delete:
        _changesQueue.add(
          (
            CrossSyncEventType.delete,
            castToType(payload.newRecord),
          ),
        );
      default:
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
      // opts: const RealtimeChannelConfig(ack: true),
    );
    _channel
        ?.onPostgresChanges(
          schema: 'public',
          event: PostgresChangeEvent.all,
          table: clipItemTable,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.neq,
            column: "deviceId",
            value: deviceId,
          ),
          callback: _onChange,
        )
        .subscribe(_onStatusChange);
  }

  @override
  get onStatusChange => _statusEvents.stream;

  @override
  Future<void> reconnect() async {
    // Reconnect only if not connected
    if (_lastStatus != CrossSyncListenerStatus.disconnected) {
      return;
    }
    await stop();
    await Future.delayed(const Duration(seconds: 1));
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
  get changesQueue => _changesQueue;

  @override
  castToType(Object? obj) {
    return ClipboardItem.fromJson(obj as Map<String, dynamic>);
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
      this.client, @Named("device_id") this.deviceId) {
    _statusEvents.add((CrossSyncListenerStatus.unknown, null));
  }

  @override
  Future<void> start() async {
    if (isInitiated) return;
    _statusEvents.add((CrossSyncListenerStatus.connecting, null));
    _channel = client.channel(
      channelID,
      // opts: const RealtimeChannelConfig(ack: true),
    );

    _channel
        ?.onPostgresChanges(
          schema: 'public',
          event: PostgresChangeEvent.all,
          table: clipCollectionTable,
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.neq,
            column: "deviceId",
            value: deviceId,
          ),
          callback: _onChange,
        )
        .subscribe(_onStatusChange);
  }

  @override
  get changesQueue => _changesQueue;

  @override
  castToType(Object? obj) {
    return ClipCollection.fromJson(obj as Map<String, dynamic>);
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
    await Future.delayed(const Duration(seconds: 1));
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
