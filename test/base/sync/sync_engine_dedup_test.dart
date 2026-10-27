import 'dart:async';

import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/model/sync/sync_config.dart';
import 'package:clipboard/base/domain/model/sync/sync_cursor.dart';
import 'package:clipboard/base/domain/model/sync/sync_outbox_entry.dart';
import 'package:clipboard/base/domain/repositories/sync_cursor.dart';
import 'package:clipboard/base/domain/repositories/sync_outbox.dart';
import 'package:clipboard/base/domain/services/conflict_resolver.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:clipboard/base/domain/services/sync_adapter.dart';
import 'package:clipboard/base/domain/services/sync_event_bus.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/base/enums/platform_os.dart';
import 'package:clipboard/base/sync/sync_engine.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/paginated_results.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeCursorRepo implements SyncCursorRepository {
  @override
  Future<SyncCursor?> get(String entityType) async => null;
  @override
  Future<void> upsert(SyncCursor cursor) async {}
  @override
  Future<void> delete(String entityType) async {}
}

class _FakeOutboxRepo implements SyncOutboxRepository {
  List<SyncOutboxEntry> pending = [];
  final List<int> completedIds = [];

  @override
  Stream<void> get onNewEntry => const Stream.empty();
  @override
  Future<void> enqueue(SyncOutboxEntry entry) async => pending.add(entry);
  @override
  Future<List<SyncOutboxEntry>> getPending({int limit = 50}) async =>
      List.from(pending);
  @override
  Future<void> markCompleted(int id) async {
    completedIds.add(id);
    pending.removeWhere((e) => e.id == id);
  }

  @override
  Future<void> removeByEntity(String entityType, int localId) async {}
  @override
  Future<void> clearAll() async => pending.clear();
  @override
  bool isLocalIdQueued(String entityType, int localId) => false;
}

class _FakeConflictResolver implements ConflictResolver<ClipboardItem> {
  @override
  ClipboardItem resolve(ClipboardItem local, ClipboardItem remote) => remote;
}

class _FakeAdapter implements SyncAdapter<ClipboardItem> {
  final Map<int, ClipboardItem> localStore = {};
  final List<List<ClipboardItem>> remoteBatchDeleteCalls = [];
  final List<List<ClipboardItem>> localDeleteCalls = [];
  final List<int?> pushedIds = [];
  final Map<int, Failure> pushFailures = {};
  final Map<int, Object> pushErrors = {};
  Object? batchDeleteError;
  Completer<void>? pushGate;
  final Map<int, Object> persistErrors = {};

  @override
  String get entityType => 'clip';
  @override
  CrossSyncListener<ClipboardItem>? get realtimeListener => null;

  @override
  Future<ClipboardItem?> getLocalById(int localId) async => localStore[localId];

  @override
  FailureOr<bool> deleteBatchFromRemote(List<ClipboardItem> items) async {
    remoteBatchDeleteCalls.add(items);
    if (batchDeleteError case final error?) throw error;
    return const Right(true);
  }

  @override
  FailureOr<bool> deleteFromRemote(ClipboardItem item) async =>
      const Right(true);

  @override
  Future<ClipboardItem?> persistSyncResult(
    ClipboardItem item, {
    DateTime? syncedAt,
  }) async {
    if (persistErrors.remove(item.id) case final error?) throw error;
    return item;
  }

  @override
  Future<List<ClipboardItem>> deleteLocally(List<ClipboardItem> items) async {
    localDeleteCalls.add(items);
    for (final item in items) {
      if (item.id != null) localStore.remove(item.id);
    }
    return items;
  }

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
    required ConflictResolver<ClipboardItem> conflictResolver,
  }) async => [];

  @override
  FailureOr<ClipboardItem> pushToRemote(ClipboardItem item) async {
    pushedIds.add(item.id);
    await pushGate?.future;
    if (pushErrors[item.id] case final error?) throw error;
    if (pushFailures[item.id] case final failure?) return Left(failure);
    return Right(item);
  }

  @override
  Future<DateTime?> getLatestSyncTimestamp() async => null;

  @override
  Future<ClipboardItem?> markSyncInProgress(
    ClipboardItem item, {
    required bool inProgress,
    Failure? failure,
  }) async =>
      item.copyWith(uploading: inProgress, isQueued: false, failure: failure);
}

ClipboardItem _createItem({required int id, int? serverId}) {
  return ClipboardItem(
    id: id,
    serverId: serverId,
    created: systemTime(),
    modified: systemTime(),
    type: ClipItemType.text,
    userId: 'user-1',
    os: PlatformOS.macos,
  );
}

void main() {
  late _FakeAdapter adapter;
  late _FakeOutboxRepo outboxRepo;
  late _FakeCursorRepo cursorRepo;
  late SyncEventBus eventBus;
  late SyncEngine<ClipboardItem> engine;

  setUp(() {
    adapter = _FakeAdapter();
    outboxRepo = _FakeOutboxRepo();
    cursorRepo = _FakeCursorRepo();
    eventBus = SyncEventBus();

    engine = SyncEngine<ClipboardItem>(
      adapter: adapter,
      cursorRepo: cursorRepo,
      outboxRepo: outboxRepo,
      eventBus: eventBus,
      config: const SyncConfig(),
      conflictResolver: _FakeConflictResolver(),
      deviceId: 'test-device',
      namespace: 'test',
    );
  });

  tearDown(() {
    eventBus.dispose();
  });

  test(
    'processOutbox deduplicates multiple outbox entries with the same localId',
    () async {
      final item = _createItem(id: 10, serverId: 55);
      adapter.localStore[10] = item;

      // Two separate outbox delete entries referencing localId: 10
      outboxRepo.pending = [
        SyncOutboxEntry(
          id: 1,
          entityType: 'clip',
          localId: 10,
          action: SyncOutboxAction.delete,
          createdAt: systemTime(),
        ),
        SyncOutboxEntry(
          id: 2,
          entityType: 'clip',
          localId: 10,
          action: SyncOutboxAction.delete,
          createdAt: systemTime(),
        ),
      ];

      await engine.processOutbox();

      // Remote delete should only be called with 1 item, not duplicate
      expect(adapter.remoteBatchDeleteCalls.length, 1);
      expect(adapter.remoteBatchDeleteCalls.first.length, 1);
      expect(adapter.remoteBatchDeleteCalls.first.first.id, 10);
      expect(adapter.remoteBatchDeleteCalls.first.first.serverId, 55);

      // Both outbox entries should be marked completed
      expect(outboxRepo.completedIds, containsAll([1, 2]));
    },
  );

  test('processOutbox deduplicates remote delete items by serverId', () async {
    // Two distinct local items sharing the same serverId: 77
    final itemA = _createItem(id: 101, serverId: 77);
    final itemB = _createItem(id: 102, serverId: 77);
    adapter.localStore[101] = itemA;
    adapter.localStore[102] = itemB;

    outboxRepo.pending = [
      SyncOutboxEntry(
        id: 1,
        entityType: 'clip',
        localId: 101,
        action: SyncOutboxAction.delete,
        createdAt: systemTime(),
      ),
      SyncOutboxEntry(
        id: 2,
        entityType: 'clip',
        localId: 102,
        action: SyncOutboxAction.delete,
        createdAt: systemTime(),
      ),
    ];

    await engine.processOutbox();

    // Remote delete should receive only ONE item with serverId 77
    expect(adapter.remoteBatchDeleteCalls.length, 1);
    expect(adapter.remoteBatchDeleteCalls.first.length, 1);
    expect(adapter.remoteBatchDeleteCalls.first.first.serverId, 77);

    // Both local items should be deleted locally
    expect(adapter.localDeleteCalls.length, 1);
    expect(adapter.localDeleteCalls.first.length, 2);

    // Both outbox entries should be marked completed
    expect(outboxRepo.completedIds, containsAll([1, 2]));
  });

  for (final throwsError in [false, true]) {
    test(
      'a ${throwsError ? 'thrown timeout' : 'returned failure'} allows manual retry and does not block the next clip',
      () async {
        final failure = TimeoutException('Upload timed out. Please retry.');
        adapter.localStore[1] = _createItem(id: 1).copyWith(isQueued: true);
        adapter.localStore[2] = _createItem(id: 2).copyWith(isQueued: true);
        if (throwsError) {
          adapter.pushErrors[1] = failure;
        } else {
          adapter.pushFailures[1] = Failure.fromException(failure);
        }
        outboxRepo.pending = [
          for (final id in [1, 2])
            SyncOutboxEntry(
              id: id,
              entityType: 'clip',
              localId: id,
              action: SyncOutboxAction.create,
              createdAt: systemTime(),
            ),
        ];
        final events = <SyncEvent>[];
        final subscription = eventBus.stream.listen(events.add);

        await engine.processOutbox();
        await Future<void>.delayed(Duration.zero);

        expect(adapter.pushedIds, [1, 2]);
        expect(outboxRepo.pending, isEmpty);
        expect(outboxRepo.completedIds, [1, 2]);
        final failed = events
            .whereType<TypedSyncEvent<ClipboardItem>>()
            .map((event) => event.event.$2)
            .singleWhere((item) => item.failure != null);
        expect(failed.id, 1);
        expect(failed.failure!.message, contains('Upload timed out'));
        expect(failed.isQueued, isFalse);
        expect(failed.isSyncing, isFalse);
        expect(events.whereType<SyncOutboxFailureEvent>(), hasLength(1));
        expect(
          events.whereType<SyncEngineStatusUpdateEvent>().last.isBusy,
          isFalse,
        );

        adapter.pushErrors.clear();
        adapter.pushFailures.clear();
        await outboxRepo.enqueue(
          SyncOutboxEntry(
            id: 3,
            entityType: 'clip',
            localId: 1,
            action: SyncOutboxAction.update,
            createdAt: systemTime(),
          ),
        );
        await engine.processOutbox();
        expect(adapter.pushedIds, [1, 2, 1]);
        expect(outboxRepo.pending, isEmpty);
        await subscription.cancel();
      },
    );
  }

  test('a thrown batch delete falls back and continues the queue', () async {
    adapter.batchDeleteError = TimeoutException('Delete timed out');
    adapter.localStore[1] = _createItem(id: 1, serverId: 10);
    adapter.localStore[2] = _createItem(id: 2);
    outboxRepo.pending = [
      for (final id in [1, 2])
        SyncOutboxEntry(
          id: id,
          entityType: 'clip',
          localId: id,
          action: id == 1 ? SyncOutboxAction.delete : SyncOutboxAction.create,
          createdAt: systemTime(),
        ),
    ];

    await engine.processOutbox();

    expect(outboxRepo.pending, isEmpty);
    expect(adapter.localStore.containsKey(1), isFalse);
    expect(adapter.pushedIds, [2]);
  });

  test(
    'active processing survives UI queries and clears after completion',
    () async {
      adapter.localStore[1] = _createItem(id: 1);
      adapter.pushGate = Completer<void>();
      outboxRepo.pending = [
        SyncOutboxEntry(
          id: 1,
          entityType: 'clip',
          localId: 1,
          action: SyncOutboxAction.create,
          createdAt: systemTime(),
        ),
      ];
      final events = <SyncEvent>[];
      final subscription = eventBus.stream.listen(events.add);
      final processing = engine.processOutbox();
      await Future<void>.delayed(Duration.zero);
      expect(eventBus.isProcessing('clip', 1), isTrue);
      final active = events
          .whereType<TypedSyncEvent<ClipboardItem>>()
          .last
          .event
          .$2;
      expect(active.uploading, isTrue);
      expect(active.isQueued, isFalse);
      adapter.pushGate!.complete();
      await processing;
      expect(eventBus.isProcessing('clip', 1), isFalse);
      await subscription.cancel();
    },
  );

  test('persistence exceptions notify and do not stop later clips', () async {
    adapter.localStore[1] = _createItem(id: 1);
    adapter.localStore[2] = _createItem(id: 2);
    adapter.persistErrors[1] = StateError('Persistence failed');
    outboxRepo.pending = [
      for (final id in [1, 2])
        SyncOutboxEntry(
          id: id,
          entityType: 'clip',
          localId: id,
          action: SyncOutboxAction.create,
          createdAt: systemTime(),
        ),
    ];
    final events = <SyncEvent>[];
    final subscription = eventBus.stream.listen(events.add);
    await engine.processOutbox();
    await Future<void>.delayed(Duration.zero);
    expect(adapter.pushedIds, [1, 2]);
    expect(events.whereType<SyncOutboxFailureEvent>(), hasLength(1));
    expect(eventBus.isProcessing('clip', 1), isFalse);
    await subscription.cancel();
  });
}
