import 'package:flutter/foundation.dart';

enum CloudStorageType {
  googleDrive,
  webdav;

  static const String webdavPrefix = 'webdav:';
}

@immutable
class CloudFileId {
  final CloudStorageType type;
  final String pathOrId;

  const CloudFileId({
    required this.type,
    required this.pathOrId,
  });

  factory CloudFileId.parse(String driveFileId) {
    if (driveFileId.startsWith(CloudStorageType.webdavPrefix)) {
      return CloudFileId(
        type: CloudStorageType.webdav,
        pathOrId: driveFileId.substring(CloudStorageType.webdavPrefix.length),
      );
    }
    return CloudFileId(
      type: CloudStorageType.googleDrive,
      pathOrId: driveFileId,
    );
  }

  factory CloudFileId.webdav(String relativePath) {
    return CloudFileId(
      type: CloudStorageType.webdav,
      pathOrId: relativePath,
    );
  }

  factory CloudFileId.googleDrive(String fileId) {
    return CloudFileId(
      type: CloudStorageType.googleDrive,
      pathOrId: fileId,
    );
  }

  String format() {
    switch (type) {
      case CloudStorageType.googleDrive:
        return pathOrId;
      case CloudStorageType.webdav:
        return '${CloudStorageType.webdavPrefix}$pathOrId';
    }
  }

  bool get isWebDav => type == CloudStorageType.webdav;
  bool get isGoogleDrive => type == CloudStorageType.googleDrive;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CloudFileId &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          pathOrId == other.pathOrId;

  @override
  int get hashCode => type.hashCode ^ pathOrId.hashCode;

  @override
  String toString() => format();
}
