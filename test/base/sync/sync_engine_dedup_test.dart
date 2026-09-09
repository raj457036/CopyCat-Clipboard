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

  @override
  String get entityType => 'clip';
  @override
  CrossSyncListener<ClipboardItem>? get realtimeListener => null;

  @override
  Future<ClipboardItem?> getLocalById(int localId) async => localStore[localId];

  @override
  FailureOr<bool> deleteBatchFromRemote(List<ClipboardItem> items) async {
    remoteBatchDeleteCalls.add(items);
    return const Right(true);
  }

  @override
  FailureOr<bool> deleteFromRemote(ClipboardItem item) async =>
      const Right(true);

  @override
  Future<ClipboardItem?> persistSyncResult(ClipboardItem item, {DateTime? syncedAt}) async =>
      item;

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

  test(
    'processOutbox deduplicates remote delete items by serverId',
    () async {
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
    },
  );
}
