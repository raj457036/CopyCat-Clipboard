import 'package:clipboard/base/data/services/clipboard/read_strategy.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_clipboard/super_clipboard.dart';

void main() {
  group('SimpleClipboardReadStrategy', () {
    const strategy = SimpleClipboardReadStrategy();

    test('prefers fileUri over plainText for copied files', () {
      final selected = strategy.selectFromItemFormats([
        Formats.plainText,
        Formats.fileUri,
      ]);

      expect(selected, Formats.fileUri);
    });

    test('prefers file format over plainText when both exist', () {
      final selected = strategy.selectFromItemFormats([
        Formats.plainText,
        Formats.png,
      ]);

      expect(selected, Formats.png);
    });

    test('prefers uri over plainText when no file format exists', () {
      final selected = strategy.selectFromItemFormats([
        Formats.plainText,
        Formats.uri,
      ]);

      expect(selected, Formats.uri);
    });

    test('returns plainText when it is the only available format', () {
      final selected = strategy.selectFromItemFormats([Formats.plainText]);

      expect(selected, Formats.plainText);
    });

    test('returns null for empty item formats', () {
      final selected = strategy.selectFromItemFormats([]);

      expect(selected, isNull);
    });
  });
}
