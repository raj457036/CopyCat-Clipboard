import 'package:clipboard/base/enums/platform_os.dart';

class ApplicationMeta {
  final int? id;
  final String sourceId;
  final String? identifier;
  final String? appName;
  final String? appFilePath;
  final PlatformOS os;
  final String? iconLocalPath;
  final DateTime created;
  final DateTime modified;

  const ApplicationMeta({
    this.id,
    required this.sourceId,
    this.identifier,
    this.appName,
    this.appFilePath,
    required this.os,
    this.iconLocalPath,
    required this.created,
    required this.modified,
  });

  ApplicationMeta copyWith({
    int? id,
    String? sourceId,
    String? identifier,
    String? appName,
    String? appFilePath,
    PlatformOS? os,
    String? iconLocalPath,
    bool clearIconLocalPath = false,
    DateTime? created,
    DateTime? modified,
  }) {
    return ApplicationMeta(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      identifier: identifier ?? this.identifier,
      appName: appName ?? this.appName,
      appFilePath: appFilePath ?? this.appFilePath,
      os: os ?? this.os,
      iconLocalPath: clearIconLocalPath
          ? null
          : (iconLocalPath ?? this.iconLocalPath),
      created: created ?? this.created,
      modified: modified ?? this.modified,
    );
  }
}
