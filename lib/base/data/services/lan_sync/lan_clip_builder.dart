import 'dart:io' as io;

import 'package:path/path.dart' as p;
import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/base/enums/platform_os.dart';
import 'package:clipboard/common/logging.dart';
import 'package:mime/mime.dart';

import 'lan_sync_config.dart';

/// Builds [ClipboardItem] instances from incoming LAN payloads.
class LanClipBuilder {
  final LanSyncConfig _config;

  const LanClipBuilder(this._config);

  static DateTime? _parseIsoDateTime(String? val) {
    if (val == null || val == 'null' || val.trim().isEmpty) return null;
    return DateTime.tryParse(val.trim());
  }

  static String _toIsoString(String? val) {
    final parsed = _parseIsoDateTime(val);
    return (parsed ?? DateTime.now().toUtc()).toUtc().toIso8601String();
  }

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

      final fallbackUserId = _config.userId.isNotEmpty
          ? _config.userId
          : kLocalUserId;
      final rawUserId = (payload['userId'] as String?)?.trim();
      payload['userId'] = (rawUserId != null && rawUserId.isNotEmpty)
          ? rawUserId
          : fallbackUserId;

      final createdRaw =
          (payload['created'] as String?) ?? (json['created'] as String?);
      payload['created'] = _toIsoString(createdRaw);

      final modifiedRaw = (payload['modified'] as String?) ??
          (json['modified'] as String?) ??
          (payload['created'] as String?);
      payload['modified'] = _toIsoString(modifiedRaw);

      final rawOs =
          (payload['os'] as String?) ?? (json['os'] as String?) ?? 'android';
      payload['os'] = (parseOS(rawOs) ?? PlatformOS.android).name;

      final rawType =
          (payload['type'] as String?) ?? (json['type'] as String?) ?? 'text';
      final parsedType = parseClipType(rawType) ?? ClipItemType.text;
      payload['type'] = parsedType.name;

      if (payload['origin_id'] == null && payload['originId'] == null) {
        payload['origin_id'] = originId;
      }
      if (payload['deviceId'] == null && fromDeviceId.isNotEmpty) {
        payload['deviceId'] = fromDeviceId;
      }

      var item = ClipboardItem.fromJson(payload);

      item = item.copyWith(
        deviceId: fromDeviceId.isNotEmpty ? fromDeviceId : item.deviceId,
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

      // Check outer envelope for deletedAt marker if item.deletedAt is absent.
      if (item.deletedAt == null && json['deletedAt'] != null) {
        final delDate = _parseIsoDateTime(json['deletedAt'] as String?);
        if (delDate != null) {
          item = item.copyWith(deletedAt: delDate);
        }
      }

      // Populate missing file metadata if localPath exists
      if (item.localPath != null && item.localPath!.isNotEmpty) {
        final file = io.File(item.localPath!);
        if (file.existsSync()) {
          if (item.fileSize == null) {
            item = item.copyWith(fileSize: file.lengthSync());
          }
          if (item.fileMimeType == null ||
              item.fileMimeType!.isEmpty ||
              item.fileMimeType == '*/*' ||
              item.fileMimeType == 'application/octet-stream') {
            final detectedMime = lookupMimeType(item.localPath!);
            if (detectedMime != null) {
              item = item.copyWith(fileMimeType: detectedMime);
            }
          }
          if (item.fileExtension == null ||
              item.fileExtension!.isEmpty ||
              item.fileExtension == 'bin') {
            final ext = p.extension(item.localPath!).replaceFirst('.', '').toLowerCase();
            final resolvedExt = ext.isNotEmpty && ext != 'bin'
                ? ext
                : (item.fileMimeType != null ? extensionFromMime(item.fileMimeType!) : null);
            if (resolvedExt != null && resolvedExt.isNotEmpty) {
              item = item.copyWith(fileExtension: resolvedExt == 'jpeg' ? 'jpg' : resolvedExt);
            }
          }
        }
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
