import 'package:clipboard/base/data/repositories/clip_collection.dart';
import 'package:clipboard/base/domain/model/clip_collection/clipcollection.dart';
import 'package:clipboard/base/domain/model/sync/sync_outbox_entry.dart';
import 'package:clipboard/base/domain/repositories/sync_outbox.dart';
import 'package:clipboard/base/domain/sources/clip_collection.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeLocalSource extends Fake implements ClipCollectionSource {
  ClipCollection? lastUpdated;

  @override
  Future<ClipCollection> update(ClipCollection collection) async {
    lastUpdated = collection;
    return collection;
  }
}

class _FakeRemoteSource extends Fake implements ClipCollectionSource {
  ClipCollection? lastUpdated;

  @override
  Future<ClipCollection> update(ClipCollection collection) async {
    lastUpdated = collection;
    return collection;
  }
}

class _FakeOutboxRepo extends Fake implements SyncOutboxRepository {
  SyncOutboxEntry? enqueuedEntry;

  @override
  Future<void> enqueue(SyncOutboxEntry entry) async {
    enqueuedEntry = entry;
  }
}

void main() {
  group('ClipCollectionRepositoryImpl.update', () {
    late _FakeLocalSource localSource;
    late _FakeRemoteSource remoteSource;
    late _FakeOutboxRepo outboxRepo;
    late ClipCollectionRepositoryImpl repository;

    setUp(() {
      localSource = _FakeLocalSource();
      remoteSource = _FakeRemoteSource();
      outboxRepo = _FakeOutboxRepo();
      repository = ClipCollectionRepositoryImpl(
        remoteSource,
        localSource,
        outboxRepo,
      );
    });

    test('bumps modified timestamp when updating collection', () async {
      final initialTime = DateTime(2026, 1, 1, 10, 0, 0);
      final collection = ClipCollection(
        id: 1,
        serverId: 101,
        title: 'Work',
        emoji: '💼',
        color: 0x1E88E5,
        created: initialTime,
        modified: initialTime,
      );

      final result = await repository.update(collection);

      expect(result.isRight(), isTrue);
      final updated = result.getOrElse(() => throw StateError('Failed'));
      expect(updated.modified.isAfter(initialTime), isTrue);
      expect(localSource.lastUpdated?.modified.isAfter(initialTime), isTrue);
      expect(remoteSource.lastUpdated?.modified.isAfter(initialTime), isTrue);
      expect(updated.color, 0x1E88E5);
    });
  });

  group('ClipCollection JSON Serialization', () {
    test('serializes and deserializes color correctly', () {
      final now = DateTime.now();
      final collection = ClipCollection(
        title: 'Personal',
        emoji: '🏠',
        color: 0x43A047,
        created: now,
        modified: now,
      );

      final json = collection.toJson();
      expect(json['color'], 0x43A047);

      final restored = ClipCollection.fromJson(json);
      expect(restored.color, 0x43A047);
      expect(restored.collectionColor?.toARGB32(), 0xFF43A047);
    });
  });
}
