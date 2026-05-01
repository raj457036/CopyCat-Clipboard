import 'package:clipboard/base/enums/platform_os.dart';

/// Lightweight entry returned by the remote app_activity_directory lookup.
class AppDirectoryEntry {
  final String sourceId;
  final PlatformOS os;
  final String? iconRemoteUrl;

  const AppDirectoryEntry({
    required this.sourceId,
    required this.os,
    this.iconRemoteUrl,
  });
}
