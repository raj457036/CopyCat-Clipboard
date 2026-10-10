import 'dart:io';

import 'package:file_thumbnailer/models/thumbnail_request.dart';

abstract class FormatThumbnailGenerator {
  bool canHandle(ThumbnailRequest request);

  Future<File?> generate(ThumbnailRequest request, String cacheKey);
}
