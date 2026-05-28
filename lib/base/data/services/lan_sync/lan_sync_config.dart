/// Shared mutable configuration for the LAN sync subsystem.
///
/// All LAN sync components hold a reference to the same [LanSyncConfig]
/// instance so configuration changes propagate without re-construction.
class LanSyncConfig {
  String deviceId = '';
  String userId = '';
  int serverPort = 0;

  // Override via: --dart-define=LAN_SEND_RICH_TEXT_TO_ANDROID=false
  bool sendRichTextToAndroid = const bool.fromEnvironment(
    'LAN_SEND_RICH_TEXT_TO_ANDROID',
    defaultValue: true,
  );
}
