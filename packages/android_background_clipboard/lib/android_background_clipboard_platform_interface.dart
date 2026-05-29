import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'android_background_clipboard_method_channel.dart';

abstract class AndroidBackgroundClipboardPlatform extends PlatformInterface {
  /// Constructs a AndroidBackgroundClipboardPlatform.
  AndroidBackgroundClipboardPlatform() : super(token: _token);

  static final Object _token = Object();

  static AndroidBackgroundClipboardPlatform _instance =
      MethodChannelAndroidBackgroundClipboard();

  /// The default instance of [AndroidBackgroundClipboardPlatform] to use.
  ///
  /// Defaults to [MethodChannelAndroidBackgroundClipboard].
  static AndroidBackgroundClipboardPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AndroidBackgroundClipboardPlatform] when
  /// they register themselves.
  static set instance(AndroidBackgroundClipboardPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> initStorage() {
    throw UnimplementedError();
  }

  Future<T?> readShared<T>(String key, {bool secure = false}) {
    throw UnimplementedError();
  }

  Future<List<Map<Object?, Object?>>> readClipsBatch(
    int start,
    int end,
  ) {
    throw UnimplementedError();
  }

  Future<bool> writeShared<T>(String key, T value, {bool secure = false}) {
    throw UnimplementedError();
  }

  Future<void> deleteShared(List<String> keys) {
    throw UnimplementedError();
  }

  Future<bool> isAccessibilityPermissionGranted() async {
    throw UnimplementedError();
  }

  Future<void> openAccessibilityService() async {
    throw UnimplementedError();
  }

  Future<bool> isOverlayPermissionGranted() async {
    throw UnimplementedError();
  }

  Future<void> requestOverlayPermission() async {
    throw UnimplementedError();
  }

  Future<bool> isBatteryOptimizationEnabled() async {
    throw UnimplementedError();
  }

  Future<void> requestUnrestrictedBatteryAccess() async {
    throw UnimplementedError();
  }

  Future<bool> isNotificationPermissionGranted() async {
    throw UnimplementedError();
  }

  Future<void> requestNotificationPermission() async {
    throw UnimplementedError();
  }

  Future<bool> isServiceRunning() async {
    throw UnimplementedError();
  }

  Future<void> clearStorage() async {
    throw UnimplementedError();
  }

  Future<void> setDetectionMode(String mode) async {
    throw UnimplementedError();
  }

  Stream<Map<String, String>> detectionStatusStream() {
    throw UnimplementedError();
  }

  /// Streams NSD-discovered LAN peers from the Android background service.
  /// Each peer map contains `deviceId`, `host`, and `port` (as String).
  Stream<List<Map<String, dynamic>>> lanPeersStream() {
    throw UnimplementedError();
  }

  /// Emits the clip key (e.g. "Clip-8") each time the Android background service
  /// writes a LAN clip to shared storage. Flutter reads that single clip directly
  /// without a full batch scan.
  Stream<String> lanClipReceivedStream() {
    throw UnimplementedError();
  }

  /// Broadcasts a foreground-captured clip to LAN peers via the Android
  /// background service's [CopyCatLanSyncManager].
  ///
  /// [clip] must contain: originId, type (text|url|media|file), content,
  /// label, encrypted. Optional: iv, encMode, sourceId, sourceApp,
  /// localPath, fileMimeType, fileExtension, fileName (for media/file).
  Future<void> broadcastClip(Map<String, dynamic> clip) async {
    throw UnimplementedError();
  }
}
