import 'package:freezed_annotation/freezed_annotation.dart';
import "package:universal_io/io.dart";

enum PlatformOS {
  @JsonValue("android")
  android,
  @JsonValue("ios")
  ios,
  @JsonValue("macos")
  macos,
  @JsonValue("windows")
  windows,
  @JsonValue("linux")
  linux,
}

extension PlatformOSDisplay on PlatformOS {
  String get displayName => switch (this) {
    PlatformOS.android => 'Android',
    PlatformOS.ios => 'iOS',
    PlatformOS.macos => 'macOS',
    PlatformOS.windows => 'Windows',
    PlatformOS.linux => 'Linux',
  };
}

PlatformOS currentPlatformOS() {
  if (Platform.isAndroid) {
    return PlatformOS.android;
  }
  if (Platform.isIOS) {
    return PlatformOS.ios;
  }
  if (Platform.isMacOS) {
    return PlatformOS.macos;
  }
  if (Platform.isWindows) {
    return PlatformOS.windows;
  }
  if (Platform.isLinux) {
    return PlatformOS.linux;
  }
  throw UnsupportedError("Unsupported platform");
}
