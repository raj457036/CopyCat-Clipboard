import 'dart:convert';

import 'package:crypto/crypto.dart';

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

  /// User-scoped mDNS service type: `_cc-<sha256(userId)[0..8]>._tcp`.
  /// Falls back to `_copycat._tcp` when [userId] is not yet set.
  String get serviceType {
    if (userId.isEmpty) return '_copycat._tcp';
    final fp = sha256.convert(utf8.encode(userId)).toString().substring(0, 8);
    return '_cc-$fp._tcp';
  }
}
