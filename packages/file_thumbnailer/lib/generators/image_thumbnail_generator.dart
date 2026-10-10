import 'dart:io';
import 'dart:typed_data';

import 'package:file_thumbnailer/cache/thumbnail_disk_cache.dart';
import 'package:file_thumbnailer/generators/format_thumbnail_generator.dart';
import 'package:file_thumbnailer/models/thumbnail_request.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;

class ImageThumbnailGenerator implements FormatThumbnailGenerator {
  const ImageThumbnailGenerator();

  static const int maxDirectSizeBytes = 300 * 1024; // 300 KB

  static const Set<String> _imageExtensions = <String>{
    '.jpg',
    '.jpeg',
    '.png',
    '.webp',
    '.gif',
    '.bmp',
    '.tiff',
    '.ico',
  };

  @override
  bool canHandle(ThumbnailRequest request) {
    final mime = request.mimeType?.toLowerCase();
    final ext = p.extension(request.filePath).toLowerCase();

    if (ext == '.svg' || (mime != null && mime.contains('svg'))) {
      return false;
    }

    return (mime != null && mime.startsWith('image/')) ||
        _imageExtensions.contains(ext);
  }

  @override
  Future<File?> generate(ThumbnailRequest request, String cacheKey) async {
    final file = File(request.filePath);
    if (!await file.exists()) {
      return null;
    }

    try {
      final length = await file.length();
      if (length <= maxDirectSizeBytes) {
        return file;
      }

      final bytes = await file.readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded == null) {
        return file;
      }

      final targetWidth = (request.widgetSize * 2).clamp(320.0, 960.0).toInt();
      if (decoded.width <= targetWidth) {
        return file;
      }

      final resized = img.copyResize(decoded, width: targetWidth);
      final encodedBytes = Uint8List.fromList(img.encodeJpg(resized, quality: 85));

      final cache = ThumbnailDiskCache.instance;
      return await cache.saveBytesAtomically(cacheKey, encodedBytes);
    } catch (_) {
      return file;
    }
  }
}
