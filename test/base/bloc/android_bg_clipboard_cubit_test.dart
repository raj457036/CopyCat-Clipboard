import 'dart:async';

import 'package:android_background_clipboard/android_background_clipboard.dart';
import 'package:clipboard/base/bloc/android_bg_clipboard_cubit/android_bg_clipboard_cubit.dart';
import 'package:clipboard/base/domain/repositories/clipboard.dart';
import 'package:clipboard/base/domain/services/sync_event_bus.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakePlugin extends Fake implements AndroidBackgroundClipboard {
  final _controller = StreamController<String>.broadcast();

  @override
  Stream<String> lanClipReceivedStream() => _controller.stream;

  void dispose() {
    _controller.close();
  }
}

class _FakeSyncEventBus extends Fake implements SyncEventBus {}

class _FakeClipRepo extends Fake implements ClipboardRepository {}

void main() {
  late _FakePlugin plugin;
  late AndroidBgClipboardCubit cubit;

  setUp(() {
    plugin = _FakePlugin();
    cubit = AndroidBgClipboardCubit(
      plugin,
      _FakeSyncEventBus(),
      _FakeClipRepo(),
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
}
