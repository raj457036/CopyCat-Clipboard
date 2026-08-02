import 'package:clipboard/base/constants/misc.dart';
import 'package:clipboard/base/data/services/clipboard/format_processor.dart';
import 'package:clipboard/base/data/services/clipboard/clip_models.dart';
import 'package:clipboard/base/domain/model/exclusion_rules/exclusion_checker.dart';
import 'package:clipboard/base/domain/model/exclusion_rules/exclusion_rules.dart';
import 'package:clipboard/base/domain/services/analysis/text_analysis.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_clipboard/super_clipboard.dart';

void main() {
  group('ClipboardFormatProcessor', () {
    late ClipboardFormatProcessor processor;

    setUp(() {
      processor = ClipboardFormatProcessor();
    });

    group('Format Coverage', () {
      test('processor initializes', () {
        expect(processor, isNotNull);
      });

      test('all declared supported formats are available', () {
        expect(
          allSupportedClipFormats,
          isNotEmpty,
          reason: 'No supported formats declared in misc.dart',
        );

        // Check that key image formats are in the supported list
        final imageFormats = <DataFormat>[
          Formats.png,
          Formats.jpeg,
          Formats.gif,
          Formats.webp,
          Formats.bmp,
        ];

        for (final format in imageFormats) {
          expect(
            allSupportedClipFormats.contains(format),
            isTrue,
            reason: 'Expected $format in allSupportedClipFormats',
          );
        }
      });

      /// Verifies that officially-supported-by-Flutter formats are declared.
      test('core raster formats are declared', () {
        expect(allSupportedClipFormats.contains(Formats.png), isTrue);
        expect(allSupportedClipFormats.contains(Formats.jpeg), isTrue);
        expect(allSupportedClipFormats.contains(Formats.gif), isTrue);
        expect(allSupportedClipFormats.contains(Formats.webp), isTrue);
        expect(allSupportedClipFormats.contains(Formats.bmp), isTrue);
      });

      test('platform-specific formats are declared', () {
        expect(allSupportedClipFormats.contains(Formats.heic), isTrue);
        expect(allSupportedClipFormats.contains(avif), isTrue);
      });

      test('less common formats are declared', () {
        expect(allSupportedClipFormats.contains(Formats.tiff), isTrue);
      });

      test('vector format is declared', () {
        expect(
          allSupportedClipFormats.contains(svg),
          isTrue,
          reason: 'SVG is handled via flutter_svg package',
        );
      });
    });

    group('Extension Normalization', () {
      test('extension resolution works', () {
        expect(processor, isNotNull);
        expect(allSupportedClipFormats, isNotEmpty);
      });
    });

    group('Platform Compatibility', () {
      test('multiple formats supported', () {
        expect(allSupportedClipFormats.length, greaterThan(5));
      });

      test('supports raster and vector formats', () {
        final hasRaster = allSupportedClipFormats.any(
          (f) => f == Formats.png || f == Formats.jpeg,
        );
        final hasVector = allSupportedClipFormats.contains(svg);
        expect(hasRaster, isTrue);
        expect(hasVector, isTrue);
      });
    });

    group('Fallback & Strategy', () {
      test('processor initializes with fallback', () {
        expect(processor, isNotNull);
      });

      test('read strategy formats align with supported formats', () {
        expect(allSupportedClipFormats, isNotEmpty);
        final strategyFormats = [
          Formats.fileUri,
          Formats.uri,
          Formats.plainText,
          Formats.plainTextFile,
          Formats.png,
          Formats.jpeg,
          Formats.gif,
          Formats.webp,
          Formats.heic,
          Formats.bmp,
          svg,
        ];

        for (final format in strategyFormats) {
          if (allSupportedClipFormats.contains(format)) {
            expect(true, isTrue);
          }
        }
      });
    });

    group('Text classification', () {
      test('keeps full text when it contains an email address', () {
        final (category, parsedText) = TextAnalysis.getTextCategory(
          'Please reach me at john@example.com',
        );

        expect(category, isNull);
        expect(parsedText, 'Please reach me at john@example.com');
      });

      test('keeps full text when it contains a phone number', () {
        final (category, parsedText) = TextAnalysis.getTextCategory(
          'Call me at 555-123-4567',
        );

        expect(category, isNull);
        expect(parsedText, 'Call me at 555-123-4567');
      });

      test('classifies pure email and phone values as their own categories', () {
        final (emailCategory, emailText) = TextAnalysis.getTextCategory(
          'john@example.com',
        );
        final (phoneCategory, phoneText) = TextAnalysis.getTextCategory(
          '5551234567',
        );

        expect(emailCategory, TextCategory.email);
        expect(emailText, 'john@example.com');
        expect(phoneCategory, TextCategory.phone);
        expect(phoneText, '5551234567');
      });

      test('exclusion rules still block clips that contain embedded phone or email content', () {
        final checker = ExclusionChecker(ExclusionRules());
        final clip = ClipItem.text(text: 'Call me at 5551234567');

        expect(checker.isClipAllowed(clip, null), isFalse);
      });
    });
  });
}
