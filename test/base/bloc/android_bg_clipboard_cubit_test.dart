import 'dart:async';

import 'package:android_background_clipboard/android_background_clipboard.dart';
import 'package:clipboard/base/bloc/android_bg_clipboard_cubit/android_bg_clipboard_cubit.dart';
import 'package:clipboard/base/domain/repositories/clipboard.dart';
import 'package:clipboard/base/domain/services/sync_event_bus.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/model/syncable.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:clipboard/base/enums/platform_os.dart';
import 'package:clipboard/common/failure.dart';
import 'package:dartz/dartz.dart';

class _FakePlugin extends Fake implements AndroidBackgroundClipboard {
  final _controller = StreamController<String>.broadcast();

  @override
  Stream<String> lanClipReceivedStream() => _controller.stream;

  void dispose() {
    _controller.close();
  }
}

class _FakeSyncEventBus extends Fake implements SyncEventBus {
  final emitted = <(CrossSyncEventType, dynamic)>[];

  @override
  void emit<T extends Syncable>(CrossSyncEvent<T> event) {
    emitted.add(event);
  }
}

class _FakeClipRepo extends Fake implements ClipboardRepository {
  Future<Either<Failure, (ClipboardItem, bool)>> Function(ClipboardItem)?
      onUpdateOrCreate;
  Future<Either<Failure, bool>> Function(ClipboardItem)? onDelete;

  @override
  Future<Either<Failure, (ClipboardItem, bool)>> updateOrCreate(
    ClipboardItem item,
  ) async {
    if (onUpdateOrCreate != null) return onUpdateOrCreate!(item);
    return Right((item, false));
  }

  @override
  Future<Either<Failure, bool>> delete(ClipboardItem item, {bool soft = true}) async {
    if (onDelete != null) return onDelete!(item);
    return const Right(false);
  }
}

void main() {
  late _FakePlugin plugin;
  late _FakeSyncEventBus eventBus;
  late _FakeClipRepo clipRepo;
  late AndroidBgClipboardCubit cubit;

  setUp(() {
    plugin = _FakePlugin();
    eventBus = _FakeSyncEventBus();
    clipRepo = _FakeClipRepo();
    cubit = AndroidBgClipboardCubit(
      plugin,
      eventBus,
      clipRepo,
      'test_device',
    );
  });

  tearDown(() async {
    await cubit.close();
    plugin.dispose();
  });

  group('AndroidBgClipboardCubit.parseClip', () {
    test('parses distinct title and description independently', () {
      final clip = {
        'id': 'Clip-1',
        'type': 'Text',
        'text': 'Hello world',
        'title': 'Specific Title',
        'description': 'Detailed Description',
        'label': 'Legacy Label',
        'timestamp': 1000000,
      };

      final item = cubit.parseClip(clip);

      expect(item.title, equals('Specific Title'));
      expect(item.description, equals('Detailed Description'));
      expect(item.text, equals('Hello world'));
      expect(item.type, equals(ClipItemType.text));
    });

    test('does not copy title into description when description is null or empty', () {
      final clip = {
        'id': 'Clip-2',
        'type': 'Text',
        'text': 'Some text',
        'title': 'Only Title',
        'description': null,
        'label': 'Only Title',
        'timestamp': 1000000,
      };

      final item = cubit.parseClip(clip);

      expect(item.title, equals('Only Title'));
      expect(item.description, isNull);
    });

    test('preserves description when title is not set', () {
      final clip = {
        'id': 'Clip-3',
        'type': 'Text',
        'text': 'Some text',
        'title': null,
        'description': 'Custom Description',
        'label': null,
        'timestamp': 1000000,
      };

      final item = cubit.parseClip(clip);

      expect(item.title, isNull);
      expect(item.description, equals('Custom Description'));
    });

    test('legacy fallback: populates title from label but leaves description null', () {
      final clip = {
        'id': 'Clip-4',
        'type': 'Text',
        'text': 'Legacy text',
        'label': 'Old Label',
        'timestamp': 1000000,
      };

      final item = cubit.parseClip(clip);

      expect(item.title, equals('Old Label'));
      expect(item.description, isNull);
    });

    test('ignores string "null" for title and description', () {
      final clip = {
        'id': 'Clip-5',
        'type': 'Text',
        'text': 'Legacy text',
        'title': 'null',
        'description': 'null',
        'label': 'null',
        'timestamp': 1000000,
      };

      final item = cubit.parseClip(clip);

      expect(item.title, isNull);
      expect(item.description, isNull);
    });
  });

  group('AndroidBgClipboardCubit.writeToLocal', () {
    test('skips emitting delete event when deleted item was not present locally', () async {
      final now = DateTime(2026, 1, 1);
      final deletedItem = ClipboardItem(
        originId: 'origin-absent',
        created: now,
        modified: now,
        deletedAt: now,
        type: ClipItemType.text,
        userId: 'u1',
        os: PlatformOS.android,
        text: 'hello',
      );

      // Return false (not found locally)
      clipRepo.onDelete = (item) async => const Right(false);

      final success = await cubit.writeToLocal(deletedItem);

      expect(success, isTrue);
      expect(eventBus.emitted.isEmpty, isTrue);
    });

    test('emits delete event when deleted item was present locally', () async {
      final now = DateTime(2026, 1, 1);
      final deletedItem = ClipboardItem(
        originId: 'origin-present',
        created: now,
        modified: now,
        deletedAt: now,
        type: ClipItemType.text,
        userId: 'u1',
        os: PlatformOS.android,
        text: 'hello',
      );

      // Return true (found and deleted)
      clipRepo.onDelete = (item) async => const Right(true);

      final success = await cubit.writeToLocal(deletedItem);

      expect(success, isTrue);
      expect(eventBus.emitted.length, equals(1));
      expect(eventBus.emitted.first.$1, equals(CrossSyncEventType.delete));
      expect(eventBus.emitted.first.$2.originId, equals('origin-present'));
    });
  });
}
