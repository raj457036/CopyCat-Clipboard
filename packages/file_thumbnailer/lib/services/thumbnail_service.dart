import 'dart:io';

import 'package:file_thumbnailer/cache/thumbnail_disk_cache.dart';
import 'package:file_thumbnailer/generators/format_thumbnail_generator.dart';
import 'package:file_thumbnailer/generators/image_thumbnail_generator.dart';
import 'package:file_thumbnailer/generators/pdf_thumbnail_generator.dart';
import 'package:file_thumbnailer/generators/video_thumbnail_generator.dart';
import 'package:file_thumbnailer/models/thumbnail_request.dart';

class ThumbnailService {
  static final ThumbnailService instance = ThumbnailService._();

  final ThumbnailDiskCache _diskCache;
  final List<FormatThumbnailGenerator> _generators;
  final Map<String, Future<File?>> _inFlight;

  ThumbnailService._({
    ThumbnailDiskCache? diskCache,
  })  : _diskCache = diskCache ?? ThumbnailDiskCache.instance,
        _generators = <FormatThumbnailGenerator>[
          const PdfThumbnailGenerator(),
          VideoThumbnailGenerator(),
          const ImageThumbnailGenerator(),
        ],
        _inFlight = <String, Future<File?>>{};

  Future<void> initialize() async {
    await _diskCache.getCacheDirPath();
  }

  void registerGenerator(FormatThumbnailGenerator generator) {
    _generators.insert(0, generator);
  }

  bool canGenerateImageThumbnail(ThumbnailRequest request) {
    return _generators.any((generator) => generator.canHandle(request));
  }

  File? getCachedThumbnailSync(ThumbnailRequest request) {
    final key = _diskCache.generateKey(request);
    final cached = _diskCache.getCachedSync(key);
    if (cached != null) {
      return cached;
    }

    if (const ImageThumbnailGenerator().canHandle(request)) {
      final source = File(request.filePath);
      try {
        if (source.existsSync() &&
            source.lengthSync() <= ImageThumbnailGenerator.maxDirectSizeBytes) {
          return source;
        }
      } catch (_) {
        return null;
      }
    }

    return null;
  }

  Future<File?> getOrGenerateThumbnail(ThumbnailRequest request) async {
    final syncHit = getCachedThumbnailSync(request);
    if (syncHit != null) {
      return syncHit;
    }

    final key = _diskCache.generateKey(request);

    final existingFuture = _inFlight[key];
    if (existingFuture != null) {
      return existingFuture;
    }

    final diskHit = await _diskCache.getCached(key);
    if (diskHit != null) {
      return diskHit;
    }

    FormatThumbnailGenerator? targetGenerator;
    for (final generator in _generators) {
      if (generator.canHandle(request)) {
        targetGenerator = generator;
        break;
      }
    }

    if (targetGenerator == null) {
      return null;
    }

    final future = targetGenerator.generate(request, key);
    _inFlight[key] = future;

    try {
      return await future;
    } finally {
      _inFlight.remove(key);
    }
  }

  Future<void> clearCache() => _diskCache.clearCache();
}
