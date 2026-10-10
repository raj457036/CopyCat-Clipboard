import 'dart:convert' show utf8;

import 'package:clipboard/base/data/services/clipboard/clip_hash_registry.dart';
import 'package:clipboard/base/data/services/clipboard/clip_models.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/base/enums/platform_os.dart';
import 'package:crypto/crypto.dart' show sha256;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ClipHashRegistry', () {
    final registry = ClipHashRegistry.instance;

    setUp(() {
      registry.clear();
    });

    test('detects duplicate hashes correctly', () {
      expect(registry.isDuplicate('hash1'), isFalse);
      registry.register('hash1');
      expect(registry.isDuplicate('hash1'), isTrue);
      expect(registry.isDuplicate('hash2'), isFalse);
    });

    test('suppressFeedback defaults to false', () {
      registry.register('hash1');
      expect(registry.consumeFeedbackSuppression('hash1'), isFalse);
    });

    test('consumeFeedbackSuppression consumes suppression flag once', () {
      registry.register('hash1', suppressFeedback: true);

      expect(registry.consumeFeedbackSuppression('hash1'), isTrue);
      expect(registry.consumeFeedbackSuppression('hash1'), isFalse);
    });

    test('consumeFeedbackSuppression does not match different hash', () {
      registry.register('hash1', suppressFeedback: true);

      expect(registry.consumeFeedbackSuppression('other_hash'), isFalse);
      expect(registry.consumeFeedbackSuppression('hash1'), isTrue);
    });

    test('clear resets hash and suppression', () {
      registry.register('hash1', suppressFeedback: true);
      registry.clear();

      expect(registry.isDuplicate('hash1'), isFalse);
      expect(registry.consumeFeedbackSuppression('hash1'), isFalse);
    });
  });

  group('ClipItem duplicate contentHash fallback', () {
    test('ClipItem.duplicate with contentDigest returns contentHash', () {
      final item = ClipItem.duplicate(contentDigest: 'digest_123');
      expect(item.isDuplicate, isTrue);
      expect(item.contentDigest, equals('digest_123'));
      expect(item.contentHash, equals('digest_123'));
    });
  });

  group('ClipboardItem contentHash', () {
    test('computes sha256 hash for text and url clips', () {
      final textItem = ClipboardItem.fromText('sample text');
      expect(textItem.contentHash, isNotNull);
      expect(
        textItem.contentHash,
        equals(sha256.convert(utf8.encode('sample text')).toString()),
      );

      final urlItem = ClipboardItem.fromURL(Uri.parse('https://example.com'));
      expect(urlItem.contentHash, isNotNull);
      expect(
        urlItem.contentHash,
        equals(sha256.convert(utf8.encode('https://example.com')).toString()),
      );
    });

    test('returns localPath for file and media clips synchronously', () {
      const path = '/tmp/sample_image.png';
      final mediaItem = ClipboardItem.fromMedia(path, fileName: 'sample_image.png');
      expect(mediaItem.contentHash, equals(path));
    });

    test('returns null for file clips when localPath is null', () {
      final item = ClipboardItem(
        type: ClipItemType.file,
        created: DateTime.now(),
        modified: DateTime.now(),
        os: PlatformOS.macos,
        fileName: 'file.txt',
      );
      expect(item.contentHash, isNull);
    });
  });
}
