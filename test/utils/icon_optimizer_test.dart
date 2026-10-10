import 'dart:typed_data';

import 'package:clipboard/utils/icon_optimizer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

void main() {
  group('IconOptimizer', () {
    test('resizes large image (512x512) down to maxDimension (128x128)', () async {
      // Create a 512x512 synthetic test image
      final originalImage = img.Image(width: 512, height: 512);
      for (int y = 0; y < 512; y++) {
        for (int x = 0; x < 512; x++) {
          originalImage.setPixelRgba(x, y, x % 256, y % 256, (x + y) % 256, 255);
        }
      }
      final originalBytes = Uint8List.fromList(img.encodePng(originalImage));

      final optimizedBytes = await IconOptimizer.optimize(
        originalBytes,
        options: const IconOptimizationOptions(maxDimension: 128),
      );

      final decoded = img.decodeImage(optimizedBytes);
      expect(decoded, isNotNull);
      expect(decoded!.width, 128);
      expect(decoded.height, 128);
      expect(optimizedBytes.length, lessThan(originalBytes.length));
    });

    test('retains aspect ratio when resizing non-square image', () async {
      final nonSquareImage = img.Image(width: 400, height: 200);
      final originalBytes = Uint8List.fromList(img.encodePng(nonSquareImage));

      final optimizedBytes = await IconOptimizer.optimize(
        originalBytes,
        options: const IconOptimizationOptions(maxDimension: 128),
      );

      final decoded = img.decodeImage(optimizedBytes);
      expect(decoded, isNotNull);
      expect(decoded!.width, 128);
      expect(decoded.height, 64);
    });

    test('preserves small images already within bounds', () async {
      final smallImage = img.Image(width: 64, height: 64);
      final originalBytes = Uint8List.fromList(img.encodePng(smallImage));

      final optimizedBytes = await IconOptimizer.optimize(
        originalBytes,
        options: const IconOptimizationOptions(maxDimension: 128),
      );

      final decoded = img.decodeImage(optimizedBytes);
      expect(decoded, isNotNull);
      expect(decoded!.width, 64);
      expect(decoded.height, 64);
    });

    test('handles empty bytes gracefully', () async {
      final empty = Uint8List(0);
      final result = await IconOptimizer.optimize(empty);
      expect(result.isEmpty, isTrue);
    });

    test('handles corrupted bytes gracefully without throwing', () async {
      final corrupted = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8]);
      final result = await IconOptimizer.optimize(corrupted);
      expect(result, equals(corrupted));
    });
  });
}
