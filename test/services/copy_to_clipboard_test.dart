import 'dart:io';

import 'package:clipboard/base/data/services/clipboard_service.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('copy_to_clipboard_test_');
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('CopyToClipboard', () {
    test('returns false when file does not exist', () async {
      final copy = CopyToClipboard();
      final nonExistent = File('${tempDir.path}/non_existent.pdf');

      final success = await copy.writeFileContent(nonExistent);

      expect(success, isFalse);
      expect(copy.items, isEmpty);
    });

    test('writes PDF as fileUri and plainText without raster image coercion', () async {
      final copy = CopyToClipboard();
      final pdfFile = File('${tempDir.path}/sample.pdf');
      await pdfFile.writeAsBytes(List.filled(100, 0x25)); // '%PDF' dummy bytes

      final success = await copy.writeFileContent(
        pdfFile,
        mimeType: 'application/pdf',
      );

      expect(success, isTrue);
      expect(copy.items, hasLength(1));

      final item = copy.items.first;
      expect(item.suggestedName, 'sample.pdf');
      // For a PDF, item should have fileUri and plainText (2 representations),
      // and NOT a raster image representation.
      expect(item.data, hasLength(2));
    });

    test('writes image with raster representation, fileUri, and plainText', () async {
      final copy = CopyToClipboard();
      final imgFile = File('${tempDir.path}/photo.png');
      await imgFile.writeAsBytes(List.filled(50, 0x89)); // PNG dummy header

      final success = await copy.writeFileContent(
        imgFile,
        mimeType: 'image/png',
      );

      expect(success, isTrue);
      expect(copy.items, hasLength(1));

      final item = copy.items.first;
      expect(item.suggestedName, 'photo.png');
      // For an image, item has image format, fileUri, and plainText (3 representations)
      expect(item.data, hasLength(3));
    });

    test('writes generic file using resolved MIME type and provided fileName', () async {
      final copy = CopyToClipboard();
      final docFile = File('${tempDir.path}/contract.docx');
      await docFile.writeAsString('dummy content');

      final success = await copy.writeFileContent(
        docFile,
        fileName: 'RenamedContract.docx',
      );

      expect(success, isTrue);
      expect(copy.items, hasLength(1));

      final item = copy.items.first;
      expect(item.suggestedName, 'RenamedContract.docx');
      expect(item.data, hasLength(2));
    });

    test('writeText adds plain text item', () async {
      final copy = CopyToClipboard();
      final success = await copy.writeText('Hello World');

      expect(success, isTrue);
      expect(copy.items, hasLength(1));
      expect(copy.items.first.suggestedName, 'Text');
    });

    test('writeUrl adds URI item', () {
      final copy = CopyToClipboard();
      final success = copy.writeUrl(Uri.parse('https://example.com'));

      expect(success, isTrue);
      expect(copy.items, hasLength(1));
      expect(copy.items.first.suggestedName, 'Uri');
    });
  });

  group('resolveFileUri', () {
    test('resolves local file path to file URI on current platform', () async {
      final file = File('${tempDir.path}/test.txt');
      await file.writeAsString('content');

      final uri = await resolveFileUri(file.path);

      expect(uri.scheme, anyOf('file', 'content'));
      if (uri.scheme == 'file') {
        expect(uri.toFilePath(), file.path);
      }
    });
  });
}
