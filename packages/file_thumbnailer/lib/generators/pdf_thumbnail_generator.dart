import 'dart:io';

import 'package:file_thumbnailer/cache/thumbnail_disk_cache.dart';
import 'package:file_thumbnailer/generators/format_thumbnail_generator.dart';
import 'package:file_thumbnailer/models/thumbnail_request.dart';
import 'package:path/path.dart' as p;
import 'package:pdfx/pdfx.dart';

class PdfThumbnailGenerator implements FormatThumbnailGenerator {
  const PdfThumbnailGenerator();

  @override
  bool canHandle(ThumbnailRequest request) {
    final mime = request.mimeType?.toLowerCase();
    final ext = p.extension(request.filePath).toLowerCase();
    return mime == 'application/pdf' || ext == '.pdf';
  }

  @override
  Future<File?> generate(ThumbnailRequest request, String cacheKey) async {
    final sourceFile = File(request.filePath);
    if (!await sourceFile.exists()) {
      return null;
    }

    PdfDocument? document;
    PdfPage? page;
    try {
      document = await PdfDocument.openFile(request.filePath);
      page = await document.getPage(1);
      final renderWidth = (request.widgetSize * 2).clamp(200.0, 1200.0);
      final aspectRatio = page.height / page.width;
      final renderHeight = renderWidth * aspectRatio;

      final pageImage = await page.render(
        width: renderWidth,
        height: renderHeight,
        format: PdfPageImageFormat.jpeg,
        quality: 85,
      );

      if (pageImage == null) {
        return null;
      }

      final cache = ThumbnailDiskCache.instance;
      return await cache.saveBytesAtomically(cacheKey, pageImage.bytes);
    } catch (_) {
      return null;
    } finally {
      await page?.close();
      await document?.close();
    }
  }
}
