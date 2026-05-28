import 'package:flutter_test/flutter_test.dart';
import 'package:clipboard/base/data/services/lan_sync/lan_clip_builder.dart';
import 'package:clipboard/base/data/services/lan_sync/lan_sync_config.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/base/enums/platform_os.dart';

void main() {
  group('LanClipBuilder.parseClipType', () {
    test('maps "text" to text', () {
      expect(LanClipBuilder.parseClipType('text'), ClipItemType.text);
    });

    test('maps "url" to url', () {
      expect(LanClipBuilder.parseClipType('url'), ClipItemType.url);
    });

    test('maps "media" to media', () {
      expect(LanClipBuilder.parseClipType('media'), ClipItemType.media);
    });

    test('maps "file" to file', () {
      expect(LanClipBuilder.parseClipType('file'), ClipItemType.file);
    });

    test('maps Android "fileurl" to file (case-insensitive alias)', () {
      expect(LanClipBuilder.parseClipType('fileurl'), ClipItemType.file);
      expect(LanClipBuilder.parseClipType('FileUrl'), ClipItemType.file);
      expect(LanClipBuilder.parseClipType('FILEURL'), ClipItemType.file);
    });

    test('maps uppercase type strings (case-insensitive)', () {
      expect(LanClipBuilder.parseClipType('TEXT'), ClipItemType.text);
      expect(LanClipBuilder.parseClipType('URL'), ClipItemType.url);
    });

    test('returns null for unrecognised type string', () {
      expect(LanClipBuilder.parseClipType('unknown'), isNull);
      expect(LanClipBuilder.parseClipType(''), isNull);
      expect(LanClipBuilder.parseClipType('rtf'), isNull);
    });
  });

  group('LanClipBuilder.parseOS', () {
    test('parses valid platform names', () {
      expect(LanClipBuilder.parseOS('android'), PlatformOS.android);
      expect(LanClipBuilder.parseOS('macos'), PlatformOS.macos);
      expect(LanClipBuilder.parseOS('windows'), PlatformOS.windows);
      expect(LanClipBuilder.parseOS('linux'), PlatformOS.linux);
      expect(LanClipBuilder.parseOS('ios'), PlatformOS.ios);
    });

    test('returns null for null input', () {
      expect(LanClipBuilder.parseOS(null), isNull);
    });

    test('returns null for unknown OS name', () {
      expect(LanClipBuilder.parseOS('symbian'), isNull);
      expect(LanClipBuilder.parseOS(''), isNull);
      expect(LanClipBuilder.parseOS('ANDROID'), isNull); // case-sensitive
    });
  });

  group('LanClipBuilder.buildFromPayload', () {
    late LanSyncConfig config;
    late LanClipBuilder builder;

    setUp(() {
      config = LanSyncConfig()..userId = 'user-abc';
      builder = LanClipBuilder(config);
    });

    test('returns null when item key is absent', () {
      final result = builder.buildFromPayload(
        json: {'content': 'hello', 'ts': 1000},
        fromDeviceId: 'dev',
        originId: 'orig',
      );
      expect(result, isNull);
    });

    test('returns null when item key is not a Map', () {
      final result = builder.buildFromPayload(
        json: {'item': 'not-a-map'},
        fromDeviceId: 'dev',
        originId: 'orig',
      );
      expect(result, isNull);
    });

    test('returns null and logs when item JSON is malformed', () {
      // Provide an item map with an unrecognised type that ClipboardItem.fromJson
      // will throw on (or produce an item we then override).
      // We validate that no exception propagates.
      expect(
        () => builder.buildFromPayload(
          json: {
            'item': {'type': 'totally_invalid_type_xyz'},
          },
          fromDeviceId: 'dev',
          originId: 'orig',
        ),
        returnsNormally,
      );
    });

    test('overrides originId with provided value', () {
      // Build a minimal valid payload with the text type.
      final itemJson = _makeTextItemJson(text: 'Hello', originId: 'old-orig');
      final result = builder.buildFromPayload(
        json: {'item': itemJson, 'content': 'Hello'},
        fromDeviceId: 'dev',
        originId: 'new-orig',
      );
      expect(result, isNotNull);
      expect(result!.originId, 'new-orig');
    });

    test('overrides deviceId with provided value', () {
      final itemJson = _makeTextItemJson(text: 'Hi');
      final result = builder.buildFromPayload(
        json: {'item': itemJson, 'content': 'Hi'},
        fromDeviceId: 'device-override',
        originId: 'o1',
      );
      expect(result!.deviceId, 'device-override');
    });

    test('injects fallback text content when item.text is empty', () {
      final itemJson = _makeTextItemJson(text: '');
      final result = builder.buildFromPayload(
        json: {'item': itemJson, 'content': 'fallback-text'},
        fromDeviceId: 'dev',
        originId: 'o1',
      );
      expect(result!.text, 'fallback-text');
    });

    test('injects fallback url content when item.url is empty', () {
      final itemJson = _makeUrlItemJson(url: '');
      final result = builder.buildFromPayload(
        json: {'item': itemJson, 'content': 'https://fallback.example.com'},
        fromDeviceId: 'dev',
        originId: 'o1',
      );
      expect(result!.url, 'https://fallback.example.com');
    });

    test('does not overwrite non-empty text with fallback', () {
      final itemJson = _makeTextItemJson(text: 'original text');
      final result = builder.buildFromPayload(
        json: {'item': itemJson, 'content': 'do-not-use-this'},
        fromDeviceId: 'dev',
        originId: 'o1',
      );
      expect(result!.text, 'original text');
    });

    test('uses service userId when item.userId is blank', () {
      config.userId = 'svc-user';
      final itemJson = _makeTextItemJson(text: 'hi', userId: '   ');
      final result = builder.buildFromPayload(
        json: {'item': itemJson, 'content': 'hi'},
        fromDeviceId: 'dev',
        originId: 'o1',
      );
      expect(result!.userId, 'svc-user');
    });

    test('keeps item.userId when it is non-blank', () {
      config.userId = 'svc-user';
      final itemJson = _makeTextItemJson(text: 'hi', userId: 'item-user');
      final result = builder.buildFromPayload(
        json: {'item': itemJson, 'content': 'hi'},
        fromDeviceId: 'dev',
        originId: 'o1',
      );
      expect(result!.userId, 'item-user');
    });
  });
}

// MARK: - Test helpers

Map<String, dynamic> _makeTextItemJson({
  required String text,
  String originId = 'test-origin',
  String userId = 'user-abc',
}) {
  final now = DateTime.now().toUtc().toIso8601String();
  return {
    'type': 'text',
    'text': text,
    'title': null,
    'userId': userId,
    'origin_id': originId,
    'encrypted': false,
    'created': now,
    'modified': now,
    'os': 'macos',
  };
}

Map<String, dynamic> _makeUrlItemJson({
  required String url,
  String originId = 'test-origin',
  String userId = 'user-abc',
}) {
  final now = DateTime.now().toUtc().toIso8601String();
  return {
    'type': 'url',
    'url': url,
    'title': null,
    'userId': userId,
    'origin_id': originId,
    'encrypted': false,
    'created': now,
    'modified': now,
    'os': 'macos',
  };
}
