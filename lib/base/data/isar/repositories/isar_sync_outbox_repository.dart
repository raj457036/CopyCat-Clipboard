import 'package:clipboard/base/data/isar/adapters/isar_sync_outbox_entry.dart';
import 'package:clipboard/base/domain/model/sync/sync_outbox_entry.dart';
import 'package:clipboard/base/domain/repositories/sync_outbox.dart';
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';
import 'package:clipboard/base/constants/strings/strings.dart';

@LazySingleton(as: SyncOutboxRepository)
class IsarSyncOutboxRepository implements SyncOutboxRepository {
  Isar get _db => Isar.getInstance(dbName)!;
  IsarCollection<IsarSyncOutboxEntry> get _collection =>
      _db.collection<IsarSyncOutboxEntry>();

  @override
  Future<void> enqueue(SyncOutboxEntry entry) async {
    await _db.writeTxn(() async {
      await _collection.put(IsarSyncOutboxEntry.fromDomain(entry));
    });
  }

  @override
  Future<List<SyncOutboxEntry>> getPending({int limit = 50}) async {
    final now = DateTime.now();
    final results = await _collection
        .filter()
        .nextRetryAtIsNull()
        .or()
        .nextRetryAtLessThan(now)
        .sortByCreatedAt()
        .limit(limit)
        .findAll();
    return results.map((e) => e.toDomain()).toList();
  }

  @override
  Future<void> markCompleted(int id) async {
    await _db.writeTxn(() async {
      await _collection.delete(id);
    });
  }

  @override
  Future<void> markFailed(int id, String error) async {
    await _db.writeTxn(() async {
      final entry = await _collection.get(id);
      if (entry != null) {
        entry.lastError = error;
        // Setting nextRetryAt far into future or null depends on exact logic
        // We'll set it null but perhaps use a different field, or just leave it for manual retry.
        // For now, let's bump nextRetryAt to way in the future or keep as failed.
        // If max retries hit, maybe we don't fetch it again (getPending checks nextRetryAt).
        // A better approach is to keep it to notify user, but we will not process it.
        entry.nextRetryAt = DateTime.now().add(const Duration(days: 3650));
        await _collection.put(entry);
      }
    });
  }

  @override
  Future<void> incrementRetry(int id, {required DateTime nextRetryAt}) async {
    await _db.writeTxn(() async {
      final entry = await _collection.get(id);
      if (entry != null) {
        entry.retryCount += 1;
        entry.nextRetryAt = nextRetryAt;
        await _collection.put(entry);
      }
    });
  }

  @override
  Future<void> removeByEntity(String entityType, int localId) async {
    await _db.writeTxn(() async {
      await _collection
          .filter()
          .entityTypeEqualTo(entityType)
          .and()
          .localIdEqualTo(localId)
          .deleteAll();
    });
  }

  @override
  Future<void> clearAll() async {
    await _db.writeTxn(() async {
      await _collection.clear();
    });
  }
}
