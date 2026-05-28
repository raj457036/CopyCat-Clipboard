import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/base/enums/platform_os.dart';
import 'package:clipboard/common/logging.dart';

import 'lan_sync_config.dart';

/// Builds [ClipboardItem] instances from incoming LAN payloads.
class LanClipBuilder {
  final LanSyncConfig _config;

  const LanClipBuilder(this._config);

  /// Build a [ClipboardItem] from the nested `item` key in [json].
  /// Returns null when the key is absent or the payload is malformed.
  ClipboardItem? buildFromPayload({
    required Map<String, dynamic> json,
    required String fromDeviceId,
    required String originId,
  }) {
    final rawItem = json['item'];
    if (rawItem is! Map) return null;

    try {
      final payload = Map<String, dynamic>.from(rawItem);
      var item = ClipboardItem.fromJson(payload);

      final fallbackUserId = _config.userId.isNotEmpty
          ? _config.userId
          : kLocalUserId;
      item = item.copyWith(
        deviceId: fromDeviceId.isNotEmpty ? fromDeviceId : null,
        userId: item.userId.trim().isNotEmpty ? item.userId : fallbackUserId,
        originId: originId,
      );

      // Inject fallback content when the full payload omits text/url.
      final fallbackContent = json['content'] as String? ?? '';
      if (item.type == ClipItemType.text &&
          (item.text == null || item.text!.isEmpty)) {
        item = item.copyWith(text: fallbackContent);
      }
      if (item.type == ClipItemType.url &&
          (item.url == null || item.url!.isEmpty)) {
        item = item.copyWith(url: fallbackContent);
      }

      return item;
    } catch (e) {
      logger.w(() => 'LAN: Failed to parse clip payload, dropping: $e');
      return null;
    }
  }

  /// Map raw type strings (from HTTP headers or JSON) to [ClipItemType].
  ///
  /// Returns null for unrecognized values so callers can reject the request.
  static ClipItemType? parseClipType(String raw) {
    final normalized = raw.toLowerCase();
    // Android uses 'fileurl' (ClipType.FileUrl); map to file for routing.
    if (normalized == 'fileurl') return ClipItemType.file;
    try {
      return ClipItemType.values.byName(normalized);
    } catch (_) {
      return null;
    }
  }

  /// Parse a platform OS string to [PlatformOS], returning null on failure.
  static PlatformOS? parseOS(String? raw) {
    if (raw == null) return null;
    try {
      return PlatformOS.values.byName(raw);
    } catch (_) {
      return null;
    }
  }
}
