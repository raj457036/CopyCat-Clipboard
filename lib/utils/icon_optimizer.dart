import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

/// Configuration options for icon optimization.
class IconOptimizationOptions {
  final int maxDimension;
  final int pngCompressionLevel;

  const IconOptimizationOptions({
    this.maxDimension = 128,
    this.pngCompressionLevel = 6,
  });
}

/// Utility for resizing and compressing application icons.
class IconOptimizer {
  const IconOptimizer._();

  /// Optimizes the provided icon [bytes] by resizing them to fit within [options.maxDimension]
  /// and encoding as an optimized PNG with full alpha channel preservation.
  ///
  /// Runs via [compute] to avoid blocking the main UI thread.
  static Future<Uint8List> optimize(
    Uint8List bytes, {
    IconOptimizationOptions options = const IconOptimizationOptions(),
  }) async {
    if (bytes.isEmpty) return bytes;
    try {
      return await compute(_optimizeSync, (bytes, options));
    } catch (_) {
      return bytes;
    }
  }

  /// Synchronous optimization entrypoint suitable for running in an isolate or worker.
  static Uint8List optimizeSync(
    Uint8List bytes, {
    IconOptimizationOptions options = const IconOptimizationOptions(),
  }) {
    return _optimizeSync((bytes, options));
  }

  static Uint8List _optimizeSync((Uint8List, IconOptimizationOptions) payload) {
    final (bytes, options) = payload;
    try {
      final image = img.decodeImage(bytes);
      if (image == null) return bytes;

      final needsResize =
          image.width > options.maxDimension ||
          image.height > options.maxDimension;

      final img.Image processed;
      if (needsResize) {
        processed = img.copyResize(
          image,
          width: image.width >= image.height ? options.maxDimension : null,
          height: image.height > image.width ? options.maxDimension : null,
          interpolation: img.Interpolation.average,
        );
      } else {
        processed = image;
      }

      final encoded = img.encodePng(
        processed,
        level: options.pngCompressionLevel,
      );

      if (needsResize || encoded.length < bytes.length) {
        return Uint8List.fromList(encoded);
      }
      return bytes;
    } catch (_) {
      return bytes;
    }
  }
}
