import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/services/clip_batch_sync_service.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/base/enums/platform_os.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:crypto/crypto.dart';
import 'package:injectable/injectable.dart';
import 'package:universal_io/io.dart' show Platform;

/// UDP port used for peer-discovery broadcasts.
const _kDiscoveryPort = 54321;

/// How often we re-broadcast our presence.
const _kAnnounceInterval = Duration(seconds: 30);

/// Maximum age of a clip's timestamp before we reject it as a replay.
const _kReplayWindowMs = 10000;

/// Desktop (macOS / Windows / Linux) LAN instant-sync service.
///
/// Architecture:
/// - HTTP server on a random port receives clips from peers.
/// - UDP broadcast on 255.255.255.255:[_kDiscoveryPort] announces our port.
/// - UDP listener on [_kDiscoveryPort] discovers peers and tracks their ports.
/// - HMAC-SHA256(body, userId) authenticates every incoming request.
@lazySingleton
class LanSyncService {
  final ClipBatchSyncService _batchSync;

  LanSyncService(this._batchSync);

  // ── config (set by AppConfigCubit / DI before start()) ───────────────────
  String deviceId = '';
  String userId = '';
  bool lanSyncEnabled = false;

  /// When true, received clips are written to the system clipboard.
  bool lanAutoWrite = false;

  // ── runtime state ─────────────────────────────────────────────────────────
  io.HttpServer? _httpServer;
  io.RawDatagramSocket? _udpSocket;
  Timer? _announceTimer;
  int _serverPort = 0;
  final Map<String, _Peer> _peers = {};
  bool _started = false;

  /// Callback invoked when a clip should be written to the system clipboard.
  /// Injected by the clipboard cubit / pipeline hook.
  void Function(ClipboardItem item)? onAutoWrite;

  // ── lifecycle ─────────────────────────────────────────────────────────────

  Future<void> start() async {
    if (_started || !lanSyncEnabled) return;
    _started = true;
    await _startHttpServer();
    await _startUdp();
    _startAnnounceTimer();
    logger.i('LanSyncService started on port $_serverPort');
  }

  Future<void> stop() async {
    if (!_started) return;
    _started = false;
    _announceTimer?.cancel();
    _announceTimer = null;
    await _httpServer?.close(force: true);
    _httpServer = null;
    _udpSocket?.close();
    _udpSocket = null;
    _peers.clear();
    logger.i('LanSyncService stopped');
  }

  Future<void> reconfigure({bool? enabled, bool? autoWrite}) async {
    if (enabled != null) lanSyncEnabled = enabled;
    if (autoWrite != null) lanAutoWrite = autoWrite;
    if (lanSyncEnabled && !_started) {
      await start();
    } else if (!lanSyncEnabled && _started) {
      await stop();
    }
  }

  // ── HTTP server ───────────────────────────────────────────────────────────

  Future<void> _startHttpServer() async {
    _httpServer = await io.HttpServer.bind(io.InternetAddress.anyIPv4, 0);
    _serverPort = _httpServer!.port;
    _httpServer!.listen(
      _handleRequest,
      onError: (e) {
        logger.w('LAN HTTP server error: $e');
      },
    );
  }

  Future<void> _handleRequest(io.HttpRequest request) async {
    if (request.method != 'POST' || request.uri.path != '/clip') {
      request.response
        ..statusCode = io.HttpStatus.notFound
        ..close();
      return;
    }

    final fromDeviceId = request.headers.value('x-cc-did') ?? '';
    if (fromDeviceId.isEmpty || fromDeviceId == deviceId) {
      request.response
        ..statusCode = io.HttpStatus.badRequest
        ..close();
      return;
    }

    final originId = request.headers.value('x-cc-oid') ?? '';
    final typeStr = request.headers.value('x-cc-type') ?? '';
    final hmacHeader = request.headers.value('x-cc-hmac') ?? '';

    if (originId.isEmpty || typeStr.isEmpty || hmacHeader.isEmpty) {
      request.response
        ..statusCode = io.HttpStatus.badRequest
        ..close();
      return;
    }

    final bodyBytes = await request.fold<List<int>>(
      [],
      (buf, chunk) => buf..addAll(chunk),
    );

    if (!_verifyHmac(bodyBytes, hmacHeader)) {
      logger.w('LAN: HMAC verification failed from $fromDeviceId');
      request.response
        ..statusCode = io.HttpStatus.unauthorized
        ..close();
      return;
    }

    final clipType = _parseClipType(typeStr);
    if (clipType == null) {
      request.response
        ..statusCode = io.HttpStatus.badRequest
        ..close();
      return;
    }

    request.response
      ..statusCode = io.HttpStatus.ok
      ..close();

    // Handle clip asynchronously after responding
    _processIncomingClip(
      bodyBytes: bodyBytes,
      fromDeviceId: fromDeviceId,
      originId: originId,
      type: clipType,
    );
  }

  void _processIncomingClip({
    required List<int> bodyBytes,
    required String fromDeviceId,
    required String originId,
    required ClipItemType type,
  }) {
    try {
      final bodyStr = utf8.decode(bodyBytes);
      final json = jsonDecode(bodyStr) as Map<String, dynamic>;

      final ts = json['ts'] as int? ?? 0;
      if (DateTime.now().millisecondsSinceEpoch - ts > _kReplayWindowMs) {
        logger.w('LAN: Replay detected from $fromDeviceId, dropping');
        return;
      }

      final content = json['content'] as String? ?? '';
      final label = json['label'] as String? ?? '';
      final encrypted = json['encrypted'] as bool? ?? false;
      final iv = json['iv'] as String?;
      final encMode = json['encMode'] as String?;

      // Build a minimal ClipboardItem for batch-sync persistence.
      final item = _buildClipboardItem(
        originId: originId,
        type: type,
        content: content,
        label: label,
        encrypted: encrypted,
        iv: iv,
        encMode: encMode,
      );

      if (item == null) return;

      // Persist via the batch-sync service (same path as Supabase delivery).
      _batchSync
          .syncBatch([item], {})
          .then((events) {
            if (events.isEmpty) return;
            if (lanAutoWrite && onAutoWrite != null) {
              final (_, persisted) = events.first;
              onAutoWrite!(persisted);
            }
          })
          .catchError((e) {
            logger.e('LAN: syncBatch error: $e');
          });
    } catch (e) {
      logger.e('LAN: Failed to process incoming clip: $e');
    }
  }

  ClipboardItem? _buildClipboardItem({
    required String originId,
    required ClipItemType type,
    required String content,
    required String label,
    required bool encrypted,
    String? iv,
    String? encMode,
  }) {
    final now = systemTime();
    switch (type) {
      case ClipItemType.text:
        return ClipboardItem(
          userId: userId.isNotEmpty ? userId : kLocalUserId,
          type: ClipItemType.text,
          text: content,
          title: label.isNotEmpty ? label : null,
          created: now,
          modified: now,
          os: currentPlatformOS(),
          encrypted: encrypted,
          iv: iv,
          encMode: encMode,
          originId: originId,
        );
      case ClipItemType.url:
        return ClipboardItem(
          userId: userId.isNotEmpty ? userId : kLocalUserId,
          type: ClipItemType.url,
          url: content,
          title: label.isNotEmpty ? label : null,
          created: now,
          modified: now,
          os: currentPlatformOS(),
          encrypted: encrypted,
          iv: iv,
          encMode: encMode,
          originId: originId,
        );
      default:
        // Media/file types need binary data — skip on desktop for now.
        return null;
    }
  }

  // ── UDP discovery ─────────────────────────────────────────────────────────

  Future<void> _startUdp() async {
    try {
      _udpSocket = await io.RawDatagramSocket.bind(
        io.InternetAddress.anyIPv4,
        _kDiscoveryPort,
        reuseAddress: true,
        reusePort: !Platform.isWindows, // Windows doesn't support SO_REUSEPORT
      );
      _udpSocket!.broadcastEnabled = true;
      _udpSocket!.listen(_onUdpEvent);
    } catch (e) {
      logger.w('LAN: Could not bind UDP socket on port $_kDiscoveryPort: $e');
    }
  }

  void _onUdpEvent(io.RawSocketEvent event) {
    if (event != io.RawSocketEvent.read) return;
    final datagram = _udpSocket?.receive();
    if (datagram == null) return;
    try {
      final msg = utf8.decode(datagram.data);
      final json = jsonDecode(msg) as Map<String, dynamic>;
      final did = json['did'] as String?;
      final port = json['port'] as int?;
      if (did == null || port == null || did == deviceId) return;
      final host = datagram.address.address;
      _peers[did] = _Peer(host, port);
    } catch (_) {
      // Malformed UDP packet — ignore.
    }
  }

  void _startAnnounceTimer() {
    _announce(); // immediate
    _announceTimer = Timer.periodic(_kAnnounceInterval, (_) => _announce());
  }

  void _announce() {
    if (_udpSocket == null || _serverPort == 0) return;
    try {
      final payload = utf8.encode(
        jsonEncode({'did': deviceId, 'port': _serverPort}),
      );
      _udpSocket!.send(
        payload,
        io.InternetAddress('255.255.255.255'),
        _kDiscoveryPort,
      );
    } catch (e) {
      logger.w('LAN: UDP announce error: $e');
    }
  }

  // ── sending ───────────────────────────────────────────────────────────────

  /// Broadcast a text or URL clip to all discovered LAN peers.
  Future<void> broadcastClip(ClipboardItem item) async {
    if (!_started || _peers.isEmpty) return;
    if (item.type != ClipItemType.text && item.type != ClipItemType.url) return;

    final content = item.type == ClipItemType.url
        ? (item.url ?? '')
        : (item.text ?? '');
    if (content.isEmpty) return;

    final ts = DateTime.now().millisecondsSinceEpoch;
    final body = jsonEncode({
      'content': content,
      'label': item.title ?? '',
      'ts': ts,
      'encrypted': item.encrypted,
      if (item.iv != null) 'iv': item.iv,
      if (item.encMode != null) 'encMode': item.encMode,
    });
    final bodyBytes = utf8.encode(body);
    final hmac = _computeHmac(bodyBytes);
    final originId = item.originId ?? ClipboardItem.generateOriginId();

    for (final peer in _peers.values) {
      _sendToPeer(
        peer: peer,
        originId: originId,
        typeStr: item.type.name,
        bodyBytes: bodyBytes,
        hmac: hmac,
        contentType: 'application/json',
      );
    }
  }

  Future<void> _sendToPeer({
    required _Peer peer,
    required String originId,
    required String typeStr,
    required List<int> bodyBytes,
    required String hmac,
    required String contentType,
  }) async {
    try {
      final client = io.HttpClient();
      client.connectionTimeout = const Duration(seconds: 3);
      final req = await client.postUrl(
        Uri.parse('http://${peer.host}:${peer.port}/clip'),
      );
      req.headers
        ..set('X-CC-DID', deviceId)
        ..set('X-CC-OID', originId)
        ..set('X-CC-TYPE', typeStr)
        ..set('X-CC-HMAC', hmac)
        ..contentType = io.ContentType.parse(contentType)
        ..contentLength = bodyBytes.length;
      req.add(bodyBytes);
      final resp = await req.close();
      await resp.drain<void>();
      client.close();
    } catch (e) {
      logger.d('LAN: Could not reach peer ${peer.host}:${peer.port}: $e');
    }
  }

  // ── auth ──────────────────────────────────────────────────────────────────

  String _computeHmac(List<int> body) {
    final key = utf8.encode(userId);
    final mac = Hmac(sha256, key);
    return mac.convert(body).toString();
  }

  bool _verifyHmac(List<int> body, String expected) {
    if (userId.isEmpty) return false;
    return _computeHmac(body) == expected;
  }

  // ── helpers ───────────────────────────────────────────────────────────────

  ClipItemType? _parseClipType(String raw) {
    try {
      return ClipItemType.values.byName(raw.toLowerCase());
    } catch (_) {
      return null;
    }
  }
}

class _Peer {
  final String host;
  final int port;
  const _Peer(this.host, this.port);
}
