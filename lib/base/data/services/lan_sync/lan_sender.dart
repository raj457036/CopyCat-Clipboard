import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:path/path.dart' as p;
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/base/enums/platform_os.dart';
import 'package:clipboard/common/logging.dart';

import 'lan_constants.dart';
import 'lan_hmac.dart';
import 'lan_peer_registry.dart';
import 'lan_sync_config.dart';

/// Sends clipboard items to discovered LAN peers.
///
/// Text / URL clips are encoded as JSON; media / file clips are streamed as
/// binary with metadata headers.
class LanSender {
  final LanSyncConfig _config;
  final LanPeerRegistry _registry;
  final LanHmac _hmac;

  const LanSender(this._config, this._registry, this._hmac);

  // MARK: - Broadcast

  Future<void> broadcastTextClip(ClipboardItem item) async {
    final content = item.type == ClipItemType.url
        ? (item.url ?? '')
        : (item.text ?? '');
    if (content.isEmpty) return;

    final ts = DateTime.now().millisecondsSinceEpoch;
    final originId = item.originId ?? ClipboardItem.generateOriginId();

    for (final peer in _registry.peers.values.toList()) {
      final peerOs = _registry.peerOsByDeviceId[peer.deviceId];
      final includeRichData =
          _config.sendRichTextToAndroid || peerOs != PlatformOS.android;
      final itemPayload = includeRichData
          ? item
          : item.copyWith(richData: null);

      final body = jsonEncode({
        'content': content,
        'label': item.title ?? '',
        'ts': ts,
        'created': item.created.millisecondsSinceEpoch,
        'modified': item.modified.millisecondsSinceEpoch,
        'os': item.os.name,
        'encrypted': item.encrypted,
        'item': itemPayload.toJson(),
        if (item.sourceId != null && item.sourceId!.isNotEmpty)
          'sourceId': item.sourceId,
        if (item.sourceApp != null && item.sourceApp!.isNotEmpty)
          'sourceApp': item.sourceApp,
        if (item.iv != null) 'iv': item.iv,
        if (item.encMode != null) 'encMode': item.encMode,
      });
      final bodyBytes = utf8.encode(body);
      final mac = _hmac.compute(bodyBytes);

      unawaited(
        sendToPeer(
          host: peer.host,
          port: peer.port,
          originId: originId,
          typeStr: item.type.name,
          bodyBytes: bodyBytes,
          hmac: mac,
        ),
      );
    }
  }

  Future<void> broadcastMutation(ClipboardItem item) async {
    final ts = DateTime.now().millisecondsSinceEpoch;
    final originId =
        item.originId ??
        (item.serverId != null
            ? 'srv-${item.serverId}'
            : ClipboardItem.generateOriginId());

    for (final peer in _registry.peers.values.toList()) {
      final peerOs = _registry.peerOsByDeviceId[peer.deviceId];
      final includeRichData =
          _config.sendRichTextToAndroid || peerOs != PlatformOS.android;
      final itemPayload = includeRichData
          ? item
          : item.copyWith(richData: null);

      final content = item.type == ClipItemType.url
          ? (item.url ?? '')
          : (item.text ?? '');

      final body = jsonEncode({
        'content': content,
        'label': item.title ?? item.fileName ?? '',
        'ts': ts,
        'created': item.created.millisecondsSinceEpoch,
        'modified': item.modified.millisecondsSinceEpoch,
        'os': item.os.name,
        'encrypted': item.encrypted,
        'item': itemPayload.toJson(),
        if (item.sourceId != null && item.sourceId!.isNotEmpty)
          'sourceId': item.sourceId,
        if (item.sourceApp != null && item.sourceApp!.isNotEmpty)
          'sourceApp': item.sourceApp,
        if (item.iv != null) 'iv': item.iv,
        if (item.encMode != null) 'encMode': item.encMode,
      });
      final bodyBytes = utf8.encode(body);
      final mac = _hmac.compute(bodyBytes);

      // Force text envelope for mutations so updates/deletes of media/file
      // clips don't require re-sending binary bytes.
      unawaited(
        sendToPeer(
          host: peer.host,
          port: peer.port,
          originId: originId,
          typeStr: ClipItemType.text.name,
          bodyBytes: bodyBytes,
          hmac: mac,
        ),
      );
    }
  }

  Future<void> broadcastBinaryClip(ClipboardItem item) async {
    final path = item.localPath;
    if (path == null) return;

    final file = io.File(path);
    if (!await file.exists()) return;

    final fileLength = await file.length();
    if (fileLength > kLanMaxFileSizeBytes) {
      logger.w(
        () => 'LAN: Skipping file broadcast — too large ($fileLength bytes)',
      );
      return;
    }

    final originId = item.originId ?? ClipboardItem.generateOriginId();
    final ts = DateTime.now().millisecondsSinceEpoch;
    final mimeType = item.fileMimeType ?? 'application/octet-stream';
    final ext = item.fileExtension ?? p.extension(path).replaceFirst('.', '');
    final name = item.fileName ?? p.basename(path);
    final mac = await _hmac.computeForFile(file);

    for (final peer in _registry.peers.values.toList()) {
      unawaited(
        sendBinaryToPeer(
          host: peer.host,
          port: peer.port,
          file: file,
          fileLength: fileLength,
          originId: originId,
          typeStr: item.type.name,
          hmac: mac,
          ts: ts,
          mimeType: mimeType,
          fileExt: ext,
          fileName: name,
          sourceId: item.sourceId,
          sourceApp: item.sourceApp,
          created: item.created.millisecondsSinceEpoch,
          modified: item.modified.millisecondsSinceEpoch,
          osStr: item.os.name,
        ),
      );
    }
  }

  // MARK: - Low-level send

  Future<void> sendToPeer({
    required String host,
    required int port,
    required String originId,
    required String typeStr,
    required List<int> bodyBytes,
    required String hmac,
  }) async {
    await _executeWithRetry(
      peerDescription: '$host:$port',
      action: () async {
        final client = io.HttpClient();
        try {
          client.connectionTimeout = const Duration(seconds: 3);
          final req = await client.postUrl(Uri.parse('http://$host:$port/clip'));
          req.headers
            ..set('X-CC-DID', _config.deviceId)
            ..set('X-CC-OID', originId)
            ..set('X-CC-TYPE', typeStr)
            ..set('X-CC-HMAC', hmac)
            ..set('X-CC-PORT', _config.serverPort.toString())
            ..set('X-CC-OS', currentPlatformOS().name)
            ..contentType = io.ContentType.json
            ..contentLength = bodyBytes.length;
          req.add(bodyBytes);
          final resp = await req.close();
          await resp.drain<void>();
        } finally {
          client.close(force: true);
        }
      },
    );
  }

  Future<void> sendBinaryToPeer({
    required String host,
    required int port,
    required io.File file,
    required int fileLength,
    required String originId,
    required String typeStr,
    required String hmac,
    required int ts,
    required String mimeType,
    required String fileExt,
    required String fileName,
    required String? sourceId,
    required String? sourceApp,
    required int created,
    required int modified,
    required String osStr,
  }) async {
    await _executeWithRetry(
      peerDescription: '$host:$port',
      action: () async {
        final client = io.HttpClient();
        try {
          client.connectionTimeout = const Duration(seconds: 10);
          final req = await client.postUrl(Uri.parse('http://$host:$port/clip'));
          req.headers
            ..set('X-CC-DID', _config.deviceId)
            ..set('X-CC-OID', originId)
            ..set('X-CC-TYPE', typeStr)
            ..set('X-CC-HMAC', hmac)
            ..set('X-CC-PORT', _config.serverPort.toString())
            ..set('X-CC-TS', ts.toString())
            ..set('X-CC-EXT', fileExt)
            ..set('X-CC-NAME', fileName)
            ..set('X-CC-MIME', mimeType)
            ..set('X-CC-CREATED', created.toString())
            ..set('X-CC-MODIFIED', modified.toString())
            ..set('X-CC-OS', osStr)
            ..set('X-CC-SOURCE-ID', sourceId ?? '')
            ..set('X-CC-SOURCE-APP', sourceApp ?? '')
            ..set('Content-Type', mimeType)
            ..contentLength = fileLength;
          await req.addStream(file.openRead());
          final resp = await req.close();
          await resp.drain<void>();
        } finally {
          client.close(force: true);
        }
      },
    );
  }

  Future<void> _executeWithRetry({
    required String peerDescription,
    required Future<void> Function() action,
    int maxRetries = 2,
  }) async {
    for (var attempt = 1; attempt <= maxRetries + 1; attempt++) {
      try {
        await action();
        return;
      } catch (e) {
        if (attempt <= maxRetries) {
          final delayMs = attempt == 1 ? 350 : 1000;
          logger.d(
            'LAN: Delivery to $peerDescription failed ($attempt/$maxRetries), retrying in ${delayMs}ms: $e',
          );
          await Future<void>.delayed(Duration(milliseconds: delayMs));
        } else {
          logger.d(
            'LAN: Could not deliver to $peerDescription after $maxRetries retries: $e',
          );
        }
      }
    }
  }
}
