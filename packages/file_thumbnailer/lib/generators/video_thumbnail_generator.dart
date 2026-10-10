import 'dart:io';

import 'package:fc_native_video_thumbnail/fc_native_video_thumbnail.dart';
import 'package:file_thumbnailer/cache/thumbnail_disk_cache.dart';
import 'package:file_thumbnailer/generators/format_thumbnail_generator.dart';
import 'package:file_thumbnailer/models/thumbnail_request.dart';
import 'package:path/path.dart' as p;

class VideoThumbnailGenerator implements FormatThumbnailGenerator {
  final FcNativeVideoThumbnail _plugin;

  VideoThumbnailGenerator({
    FcNativeVideoThumbnail? plugin,
  }) : _plugin = plugin ?? FcNativeVideoThumbnail();

  static const Set<String> _videoExtensions = <String>{
    '.mp4',
    '.mov',
    '.mkv',
    '.avi',
    '.webm',
    '.flv',
    '.wmv',
    '.m4v',
    '.ts',
    '.3gp',
  };

  @override
  bool canHandle(ThumbnailRequest request) {
    final mime = request.mimeType?.toLowerCase();
    final ext = p.extension(request.filePath).toLowerCase();
    return (mime != null && mime.startsWith('video/')) ||
        _videoExtensions.contains(ext);
  }

  @override
  Future<File?> generate(ThumbnailRequest request, String cacheKey) async {
    final sourceFile = File(request.filePath);
    if (!await sourceFile.exists()) {
      return null;
    }

    final cache = ThumbnailDiskCache.instance;
    final cacheDir = await cache.getCacheDirPath();
    final destPath = p.join(cacheDir, '$cacheKey.jpg');
    final tempPath = p.join(cacheDir, '$cacheKey.tmp.jpg');

    try {
      final targetSize = (request.widgetSize * 2).clamp(320.0, 960.0).toInt();

      final success = await _plugin.saveThumbnailToFile(
        srcFile: request.filePath,
        destFile: tempPath,
        width: targetSize,
        height: targetSize,
        format: 'jpeg',
        quality: 85,
      );

      if (success != true) {
        return null;
      }

      final tempFile = File(tempPath);
      if (!await tempFile.exists() || await tempFile.length() == 0) {
        return null;
      }

      return await tempFile.rename(destPath);
    } catch (_) {
      return null;
    }
  }
}
