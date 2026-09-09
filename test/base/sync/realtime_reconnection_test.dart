import 'dart:async';

import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/model/notification_message.dart';
import 'package:clipboard/base/domain/model/sync/sync_config.dart';
import 'package:clipboard/base/domain/model/sync/sync_cursor.dart';
import 'package:clipboard/base/domain/model/sync/sync_outbox_entry.dart';
import 'package:clipboard/base/domain/repositories/sync_cursor.dart';
import 'package:clipboard/base/domain/repositories/sync_outbox.dart';
import 'package:clipboard/base/domain/services/conflict_resolver.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:clipboard/base/domain/services/sync_adapter.dart';
import 'package:clipboard/base/domain/services/sync_event_bus.dart';
import 'package:clipboard/base/sync/sync_engine.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/paginated_results.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRealtimeListener implements CrossSyncListener<ClipboardItem> {
  int startCalls = 0;
  int stopCalls = 0;
  int reconnectCalls = 0;
  CrossSyncListenerStatus _currentStatus = CrossSyncListenerStatus.unknown;

  final StreamController<CrossSyncStatusEvent> _statusController =
      StreamController<CrossSyncStatusEvent>.broadcast();
  final StreamController<CrossSyncEvent<ClipboardItem>> _changesController =
      StreamController<CrossSyncEvent<ClipboardItem>>.broadcast();

  @override
  CrossSyncListenerStatus get currentStatus => _currentStatus;

  @override
  Stream<CrossSyncStatusEvent> get onStatusChange => _statusController.stream;

  @override
  Stream<CrossSyncEvent<ClipboardItem>> get onChangeEvent =>
      _changesController.stream;

  @override
  bool get isInitiated => startCalls > stopCalls;

  @override
  Future<void> start() async {
    startCalls++;
    _currentStatus = CrossSyncListenerStatus.connected;
    _statusController.add((CrossSyncListenerStatus.connected, null));
  }

  @override
  Future<void> stop() async {
    stopCalls++;
    _currentStatus = CrossSyncListenerStatus.disconnected;
    _statusController.add((CrossSyncListenerStatus.disconnected, null));
  }

  @override
  Future<void> reconnect() async {
    reconnectCalls++;
  }

  void simulateDisconnect() {
    _currentStatus = CrossSyncListenerStatus.disconnected;
    _statusController.add((CrossSyncListenerStatus.disconnected, null));
  }

  void simulateConnected() {
    _currentStatus = CrossSyncListenerStatus.connected;
    _statusController.add((CrossSyncListenerStatus.connected, null));
  }

  void dispose() {
    _statusController.close();
    _changesController.close();
  }
}

class _FakeCursorRepo implements SyncCursorRepository {
  @override
  Future<SyncCursor?> get(String entityType) async => null;
  @override
  Future<void> upsert(SyncCursor cursor) async {}
  @override
  Future<void> delete(String entityType) async {}
}

class _FakeOutboxRepo implements SyncOutboxRepository {
  @override
  Stream<void> get onNewEntry => const Stream.empty();
  @override
  Future<void> enqueue(SyncOutboxEntry entry) async {}
  @override
  Future<List<SyncOutboxEntry>> getPending({int limit = 50}) async => [];
  @override
  Future<void> markCompleted(int id) async {}
  @override
  Future<void> removeByEntity(String entityType, int localId) async {}
  @override
  Future<void> clearAll() async {}
  @override
  bool isLocalIdQueued(String entityType, int localId) => false;
}

class _FakeConflictResolver implements ConflictResolver<ClipboardItem> {
  @override
  ClipboardItem resolve(ClipboardItem local, ClipboardItem remote) => remote;
}

class _FakeAdapterWithRealtime implements SyncAdapter<ClipboardItem> {
  final _FakeRealtimeListener listener;

  _FakeAdapterWithRealtime(this.listener);

  @override
  String get entityType => 'clip';
  @override
  CrossSyncListener<ClipboardItem>? get realtimeListener => listener;

  @override
  Future<ClipboardItem?> getLocalById(int localId) async => null;
  @override
  FailureOr<bool> deleteBatchFromRemote(List<ClipboardItem> items) async =>
      const Right(true);
  @override
  FailureOr<bool> deleteFromRemote(ClipboardItem item) async =>
      const Right(true);
  @override
  Future<ClipboardItem?> persistSyncResult(
    ClipboardItem item, {
    DateTime? syncedAt,
  }) async => item;
  @override
  Future<List<ClipboardItem>> deleteLocally(List<ClipboardItem> items) async =>
      items;
  @override
  Future<Either<Failure, PaginatedResult<ClipboardItem>>> fetchRemoteChanges({
    required int limit,
    DateTime? lastModified,
    String? excludeDeviceId,
  }) async => Right(PaginatedResult(results: [], hasMore: false));
  @override
  Future<Either<Failure, PaginatedResult<ClipboardItem>>> fetchRemoteDeleted({
    required int limit,
    DateTime? lastModified,
    String? excludeDeviceId,
    DateTime? lastSynced,
  }) async => Right(PaginatedResult(results: [], hasMore: false));
  @override
  Future<List<CrossSyncEvent<ClipboardItem>>> applyBatch(
    List<ClipboardItem> items, {
    ConflictResolver<ClipboardItem>? conflictResolver,
  }) async => [];

  @override
  FailureOr<ClipboardItem> pushToRemote(ClipboardItem item) async =>
      Right(item);

  @override
  Future<DateTime?> getLatestSyncTimestamp() async => null;

  @override
  Future<ClipboardItem?> markSyncInProgress(
    ClipboardItem item, {
    required bool inProgress,
    Failure? failure,
  }) async => item;
}

void main() {
  group('Realtime Reconnection & Backoff Tests', () {
    late _FakeRealtimeListener listener;
    late SyncEngine<ClipboardItem> engine;

    setUp(() {
      listener = _FakeRealtimeListener();
      final adapter = _FakeAdapterWithRealtime(listener);
      engine = SyncEngine<ClipboardItem>(
        adapter: adapter,
        cursorRepo: _FakeCursorRepo(),
        outboxRepo: _FakeOutboxRepo(),
        eventBus: SyncEventBus(),
        config: const SyncConfig(reconnectDelaySeconds: 1),
        conflictResolver: _FakeConflictResolver(),
        deviceId: 'test-device',
        namespace: 'clip-test',
      );
    });

    tearDown(() {
      engine.stopRealtime();
      listener.dispose();
    });

    test(
      'reconnectRealtime calls adapter realtimeListener.reconnect directly',
      () async {
        engine.startRealtime();
        expect(listener.startCalls, 1);

        await engine.reconnectRealtime();
        expect(listener.reconnectCalls, 1);
      },
    );

    test('reconnect timer triggers and retries on disconnect', () async {
      engine.startRealtime();
      expect(listener.reconnectCalls, 0);

      // Simulate network disconnect
      listener.simulateDisconnect();

      // Wait for the 1 second reconnect delay timer to trigger
      await Future<void>.delayed(const Duration(milliseconds: 1200));

      expect(listener.reconnectCalls, greaterThanOrEqualTo(1));
    });
  });

  group('NotificationMessage clearPrevious Tests', () {
    test('NotificationMessage default clearPrevious is false', () {
      final msg = NotificationMessage(id: 'test', body: 'body');
      expect(msg.clearPrevious, isFalse);
    });

    test('NotificationMessage supports clearPrevious: true', () {
      final msg = NotificationMessage(
        id: 'internet_connected',
        body: 'Connected',
        clearPrevious: true,
      );
      expect(msg.clearPrevious, isTrue);
    });

    test('NotificationMessage.builder passes clearPrevious', () {
      final msg = NotificationMessage.builder(
        id: 'internet_disconnected',
        builder: (_) => NotificationContent(body: 'Disconnected'),
        clearPrevious: true,
      );
      expect(msg.clearPrevious, isTrue);
    });
  });
}
