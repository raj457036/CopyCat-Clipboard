import 'android_background_clipboard_platform_interface.dart';

class AndroidBackgroundClipboard {
  const AndroidBackgroundClipboard();

  Future<void> initStorage() {
    return AndroidBackgroundClipboardPlatform.instance.initStorage();
  }

  Future<T?> readShared<T>(String key, {bool secure = false}) {
    return AndroidBackgroundClipboardPlatform.instance
        .readShared<T>(key, secure: secure);
  }

  Future<List<Map<Object?, Object?>>> readClipsBatch(
    int start,
    int end,
  ) {
    return AndroidBackgroundClipboardPlatform.instance.readClipsBatch(
      start,
      end,
    );
  }

  Future<bool> writeShared<T>(String key, T value, {bool secure = false}) {
    return AndroidBackgroundClipboardPlatform.instance
        .writeShared(key, value, secure: secure);
  }

  Future<void> deleteShared(List<String> keys) {
    return AndroidBackgroundClipboardPlatform.instance.deleteShared(keys);
  }

  Future<bool> isAccessibilityPermissionGranted() {
    return AndroidBackgroundClipboardPlatform.instance
        .isAccessibilityPermissionGranted();
  }

  Future<void> openAccessibilityService() {
    return AndroidBackgroundClipboardPlatform.instance
        .openAccessibilityService();
  }

  Future<bool> isOverlayPermissionGranted() async {
    return AndroidBackgroundClipboardPlatform.instance
        .isOverlayPermissionGranted();
  }

  Future<void> requestOverlayPermission() async {
    return AndroidBackgroundClipboardPlatform.instance
        .requestOverlayPermission();
  }

  Future<bool> isBatteryOptimizationEnabled() async {
    return AndroidBackgroundClipboardPlatform.instance
        .isBatteryOptimizationEnabled();
  }

  Future<void> requestUnrestrictedBatteryAccess() async {
    return AndroidBackgroundClipboardPlatform.instance
        .requestUnrestrictedBatteryAccess();
  }

  Future<void> openBatteryOptimizationSetting() async {
    return AndroidBackgroundClipboardPlatform.instance
        .openBatteryOptimizationSetting();
  }

  Future<bool> isNotificationPermissionGranted() async {
    return AndroidBackgroundClipboardPlatform.instance
        .isNotificationPermissionGranted();
  }

  Future<void> requestNotificationPermission() async {
    return AndroidBackgroundClipboardPlatform.instance
        .requestNotificationPermission();
  }

  Future<void> openNotificationSetting() async {
    return AndroidBackgroundClipboardPlatform.instance
        .openNotificationSetting();
  }

  Future<bool> isServiceRunning() async {
    return AndroidBackgroundClipboardPlatform.instance.isServiceRunning();
  }

  Future<void> clearStorage() async {
    return AndroidBackgroundClipboardPlatform.instance.clearStorage();
  }

  Future<void> setDetectionMode(String mode) {
    return AndroidBackgroundClipboardPlatform.instance.setDetectionMode(mode);
  }

  Future<String?> getCachedPackageIconPath(String packageName) {
    return AndroidBackgroundClipboardPlatform.instance
        .getCachedPackageIconPath(packageName);
  }

  Stream<Map<String, String>> detectionStatusStream() {
    return AndroidBackgroundClipboardPlatform.instance.detectionStatusStream();
  }

  /// Streams NSD-discovered LAN peers from the Android background service.
  /// Each peer map contains `deviceId`, `host`, and `port` (as String).
  Stream<List<Map<String, dynamic>>> lanPeersStream() {
    return AndroidBackgroundClipboardPlatform.instance.lanPeersStream();
  }

  /// Emits the clip key (e.g. "Clip-8") each time the Android background service
  /// writes a LAN clip to shared storage. Flutter reads that single clip directly
  /// without a full batch scan.
  Stream<String> lanClipReceivedStream() {
    return AndroidBackgroundClipboardPlatform.instance.lanClipReceivedStream();
  }

  /// Broadcasts a foreground-captured clip to LAN peers via the Android
  /// background service's LAN manager.
  Future<void> broadcastClip(Map<String, dynamic> clip) {
    return AndroidBackgroundClipboardPlatform.instance.broadcastClip(clip);
  }
}
