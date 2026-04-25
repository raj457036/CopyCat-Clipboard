import 'package:clipboard/base/enums/platform_os.dart';

class ActivityMetaPayload {
  final String? identifier;
  final String? appName;
  final String? appFilePath;
  final PlatformOS os;

  const ActivityMetaPayload({
    this.identifier,
    this.appName,
    this.appFilePath,
    required this.os,
  });
}
