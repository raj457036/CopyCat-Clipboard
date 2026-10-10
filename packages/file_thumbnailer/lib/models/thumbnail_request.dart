import 'package:flutter/foundation.dart';

@immutable
class ThumbnailRequest {
  final String filePath;
  final String? mimeType;
  final int? fileSize;
  final double widgetSize;
  final String? modifier;

  const ThumbnailRequest({
    required this.filePath,
    required this.widgetSize,
    this.mimeType,
    this.fileSize,
    this.modifier,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThumbnailRequest &&
          runtimeType == other.runtimeType &&
          filePath == other.filePath &&
          mimeType == other.mimeType &&
          fileSize == other.fileSize &&
          widgetSize == other.widgetSize &&
          modifier == other.modifier;

  @override
  int get hashCode =>
      Object.hash(filePath, mimeType, fileSize, widgetSize, modifier);
}
