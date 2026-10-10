import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:file_thumbnailer/models/thumbnail_request.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ThumbnailDiskCache {
  static final ThumbnailDiskCache instance = ThumbnailDiskCache._();
  ThumbnailDiskCache._();

  String? _cacheDirPath;

  Future<String> getCacheDirPath() async {
    final cached = _cacheDirPath;
    if (cached != null) {
      return cached;
    }
    final appCacheDir = await getApplicationCacheDirectory();
    final dirPath = p.join(appCacheDir.path, 'thumbnails');
    final dir = Directory(dirPath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    _cacheDirPath = dirPath;
    return dirPath;
  }

  String generateKey(ThumbnailRequest request) {
    final rawKey = '${request.filePath}_${request.fileSize ?? 0}';
    return md5.convert(utf8.encode(rawKey)).toString();
  }

  File? getCachedSync(String key) {
    final dirPath = _cacheDirPath;
    if (dirPath == null) {
      return null;
    }
    final file = File(p.join(dirPath, '$key.jpg'));
    try {
      if (file.existsSync() && file.lengthSync() > 0) {
        return file;
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  Future<File?> getCached(String key) async {
    final syncHit = getCachedSync(key);
    if (syncHit != null) {
      return syncHit;
    }
    final dirPath = await getCacheDirPath();
    final file = File(p.join(dirPath, '$key.jpg'));
    try {
      if (await file.exists() && await file.length() > 0) {
        return file;
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  Future<File> saveBytesAtomically(String key, Uint8List bytes) async {
    final dirPath = await getCacheDirPath();
    final targetPath = p.join(dirPath, '$key.jpg');
    final tempPath = p.join(dirPath, '$key.tmp');
    final tempFile = File(tempPath);
    await tempFile.writeAsBytes(bytes, flush: true);
    return tempFile.rename(targetPath);
  }

  Future<void> clearCache() async {
    final dirPath = await getCacheDirPath();
    final dir = Directory(dirPath);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
      await dir.create(recursive: true);
    }
  }
}
