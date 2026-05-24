import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:path_provider/path_provider.dart';

import 'package:mdns_dart/mdns_dart.dart';
import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/services/clip_batch_sync_service.dart';
import 'package:clipboard/base/domain/services/sync_event_bus.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/base/enums/platform_os.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:crypto/crypto.dart';
import 'package:injectable/injectable.dart';

/// mDNS service type — matches Android NsdManager registration.
const _kServiceType = '_copycat._tcp';

/// Maximum age of a clip's timestamp before we reject it as a replay.
const _kReplayWindowMs = 10000;

/// How often all known peers are re-pinged to update reachability.
const _kPingInterval = Duration(seconds: 20);

/// Desktop (macOS / Windows / Linux) LAN instant-sync service.
///
/// Architecture:
/// - HTTP server on a random port receives clips from peers.
/// - mDNS (Bonjour/Avahi) registers our service and discovers peers on [_kServiceType].
/// - HMAC-SHA256(body, userId) authenticates every incoming request.
@lazySingleton
class LanSyncService {
  final ClipBatchSyncService _batchSync;
  final SyncEventBus _syncEventBus;

  LanSyncService(this._batchSync, this._syncEventBus);

  // MARK: - Config
  String deviceId = '';
  String userId = '';
  bool lanSyncEnabled = false;

  // MARK: - Runtime State
  io.HttpServer? _httpServer;
  int _serverPort = 0;
  MDNSServer? _mdnsServer;
  Timer? _pingTimer;
  final Map<String, LanPeer> _peers = {};
  final Map<String, int> _peerFailures = {};
  bool _started = false;

  final _peersController = StreamController<List<LanPeer>>.broadcast();

  /// Stream of currently discovered peers — listen to drive UI indicators.
  Stream<List<LanPeer>> get peersStream => _peersController.stream;

  /// Current snapshot of discovered peers.
  List<LanPeer> get currentPeers => List.unmodifiable(_peers.values.toList());

  // MARK: - Lifecycle

  Future<void> start() async {
    if (_started || !lanSyncEnabled) return;

    // Bind the HTTP server first. If this fails the service cannot run at all.
    try {
      await _startHttpServer();
    } catch (e, st) {
      logger.e(
        'LanSyncService: HTTP server failed to start: $e',
        stackTrace: st,
      );
      return; // _started remains false — caller can retry
    }
    _started = true;

    // Immediately reconnect to peers we knew before the restart — avoids
    // waiting for mDNS re-discovery when the other side is still online.
    unawaited(_restorePersistedPeers());

    // mDNS registration + initial discovery are non-fatal: reverse peer
    // learning (/ping + X-CC-PORT on /clip) keeps things working even if
    // mDNS fails (e.g. port 5353 still held by OS after abrupt termination).
    try {
      await _startMdns();
    } catch (e) {
      logger.w(
        'LanSyncService: mDNS failed (non-fatal, reverse learning still active): $e',
      );
    }

    // Periodic reachability check only — new peers are learned via reverse
    // discovery (/ping announcement + X-CC-PORT on /clip), so there is no
    // need to re-scan mDNS every cycle.
    _pingTimer = Timer.periodic(_kPingInterval, (_) => _pingAllPeers());
    logger.i('LanSyncService started on port $_serverPort');
  }

  Future<void> stop() async {
    if (!_started) return;
    _started = false;
    await _httpServer?.close(force: true);
    _httpServer = null;
    _pingTimer?.cancel();
    _pingTimer = null;
    await _mdnsServer?.stop();
    _mdnsServer = null;
    _peers.clear();
    _peerFailures.clear();
    _peersController.add([]);
    logger.i('LanSyncService stopped');
  }

  Future<void> reconfigure({bool? enabled}) async {
    if (enabled != null) lanSyncEnabled = enabled;
    if (lanSyncEnabled && !_started) {
      await start();
    } else if (!lanSyncEnabled && _started) {
      await stop();
    }
  }
  // MARK: - Reachability Ping

  Future<void> _pingAllPeers() async {
    for (final did in _peers.keys.toList()) {
      unawaited(_pingSinglePeer(did));
    }
  }

  Future<void> _pingSinglePeer(String did) async {
    final peer = _peers[did];
    if (peer == null) return;

    final reachable = await _checkReachable(peer.host, peer.port);
    if (!_peers.containsKey(did)) return;

    if (reachable) {
      _peerFailures[did] = 0;
      _peers[did] = peer.withReachable(true);
    } else {
      final failures = (_peerFailures[did] ?? 0) + 1;
      _peerFailures[did] = failures;
      if (failures >= 3) {
        _peers.remove(did);
        _peerFailures.remove(did);
        unawaited(_savePeers());
        logger.i(
          'LAN: removed unresponsive peer $did after $failures failures',
        );
      } else {
        _peers[did] = peer.withReachable(false);
      }
    }
    _peersController.add(currentPeers);
  }

  Future<bool> _checkReachable(String host, int port) async {
    try {
      final client = io.HttpClient();
      client.connectionTimeout = const Duration(seconds: 2);
      final req = await client.getUrl(Uri.parse('http://$host:$port/ping'));
      final resp = await req.close();
      await resp.drain<void>();
      client.close();
      return resp.statusCode == io.HttpStatus.ok;
    } catch (_) {
      return false;
    }
  }
  // MARK: - HTTP Server

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
    // Health-check for reachability probing.
    // Also supports reverse peer learning: if a peer sends X-CC-DID and
    // X-CC-PORT, we record it so we can broadcast clips back without waiting
    // for our own mDNS discovery cycle.
    if (request.method == 'GET' && request.uri.path == '/ping') {
      final annDid = request.headers.value('x-cc-did') ?? '';
      final annPort = int.tryParse(request.headers.value('x-cc-port') ?? '');
      if (annDid.isNotEmpty && annDid != deviceId && annPort != null) {
        final host = request.connectionInfo?.remoteAddress.address ?? '';
        if (host.isNotEmpty) {
          _peers[annDid] = LanPeer(annDid, host, annPort, reachable: true);
          _peersController.add(currentPeers);
          unawaited(_savePeers());
          logger.i('LAN: learned peer $annDid at $host:$annPort via /ping');
        }
      }
      request.response
        ..statusCode = io.HttpStatus.ok
        ..close();
      return;
    }

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

    // Reverse peer learning: the sender includes its own HTTP server port so
    // we can send clips back without waiting for our own mDNS discovery cycle.
    final inboundPort = int.tryParse(request.headers.value('x-cc-port') ?? '');
    if (inboundPort != null) {
      final host = request.connectionInfo?.remoteAddress.address ?? '';
      if (host.isNotEmpty) {
        _peers[fromDeviceId] = LanPeer(
          fromDeviceId,
          host,
          inboundPort,
          reachable: true,
        );
        _peersController.add(currentPeers);
        unawaited(_savePeers());
        logger.i(
          'LAN: learned peer $fromDeviceId at $host:$inboundPort from /clip',
        );
      }
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
      final createdMs = json['created'] as int?;
      final modifiedMs = json['modified'] as int?;
      final osStr = json['os'] as String?;

      // Build a minimal ClipboardItem for batch-sync persistence.
      final item = _buildClipboardItem(
        originId: originId,
        fromDeviceId: fromDeviceId,
        type: type,
        content: content,
        label: label,
        encrypted: encrypted,
        iv: iv,
        encMode: encMode,
        created: createdMs != null
            ? DateTime.fromMillisecondsSinceEpoch(createdMs)
            : null,
        modified: modifiedMs != null
            ? DateTime.fromMillisecondsSinceEpoch(modifiedMs)
            : null,
        osStr: osStr,
      );

      if (item == null) return;

      unawaited(() async {
        try {
          final decrypted = await item.decrypt();
          final events = await _batchSync.syncBatch([decrypted], {});
          _syncEventBus.emit<ClipboardItem>(events.first);
          logger.d(
            () =>
                'LAN: processed clip from $fromDeviceId with originId $originId and type ${type.name}',
          );
        } catch (e) {
          logger.e(() => 'LAN: syncBatch error: $e');
        }
      }());
    } catch (e) {
      logger.e(() => 'LAN: Failed to process incoming clip: $e');
    }
  }

  ClipboardItem? _buildClipboardItem({
    required String originId,
    required String fromDeviceId,
    required ClipItemType type,
    required String content,
    required String label,
    required bool encrypted,
    String? iv,
    String? encMode,
    DateTime? created,
    DateTime? modified,
    String? osStr,
  }) {
    final now = systemTime();
    final itemCreated = created ?? now;
    final itemModified = modified ?? now;
    final itemOs = _parseOS(osStr) ?? currentPlatformOS();
    switch (type) {
      case ClipItemType.text:
        return ClipboardItem(
          userId: userId.isNotEmpty ? userId : kLocalUserId,
          deviceId: fromDeviceId.isNotEmpty ? fromDeviceId : null,
          type: ClipItemType.text,
          text: content,
          title: label.isNotEmpty ? label : null,
          created: itemCreated,
          modified: itemModified,
          os: itemOs,
          encrypted: encrypted,
          iv: iv,
          encMode: encMode,
          originId: originId,
        );
      case ClipItemType.url:
        return ClipboardItem(
          userId: userId.isNotEmpty ? userId : kLocalUserId,
          deviceId: fromDeviceId.isNotEmpty ? fromDeviceId : null,
          type: ClipItemType.url,
          url: content,
          title: label.isNotEmpty ? label : null,
          created: itemCreated,
          modified: itemModified,
          os: itemOs,
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

  PlatformOS? _parseOS(String? raw) {
    if (raw == null) return null;
    try {
      return PlatformOS.values.byName(raw);
    } catch (_) {
      return null;
    }
  }

  // MARK: - Peer Persistence

  /// Returns a stable file in the app-support directory for persisting peers.
  Future<io.File> get _peersFile async {
    final dir = await getApplicationSupportDirectory();
    return io.File('${dir.path}/lan_peers.json');
  }

  /// Writes the current peer map to disk so they can be restored on next start.
  Future<void> _savePeers() async {
    try {
      final data = <String, dynamic>{};
      for (final e in _peers.entries) {
        data[e.key] = {'host': e.value.host, 'port': e.value.port};
      }
      final file = await _peersFile;
      await file.writeAsString(jsonEncode(data));
    } catch (_) {}
  }

  /// Reads persisted peers and immediately re-pings them.
  /// Peers that respond are added to [_peers] right away, so clips can be
  /// broadcast without waiting for mDNS re-discovery or Android to announce.
  Future<void> _restorePersistedPeers() async {
    try {
      final file = await _peersFile;
      if (!await file.exists()) return;
      final data =
          jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      var restored = false;
      for (final entry in data.entries) {
        final did = entry.key;
        if (did == deviceId) continue;
        final peerData = entry.value as Map<String, dynamic>;
        final host = peerData['host'] as String?;
        final port = peerData['port'] as int?;
        if (host == null || port == null) continue;
        if (await _checkReachable(host, port)) {
          _peers[did] = LanPeer(did, host, port, reachable: true);
          restored = true;
          logger.i('LAN: restored peer $did at $host:$port from disk');
        }
      }
      if (restored) _peersController.add(currentPeers);
    } catch (e) {
      logger.w('LAN: could not restore persisted peers: $e');
    }
  }

  // MARK: - mDNS

  Future<void> _startMdns() async {
    await _registerService();
    await _discoverPeers();
  }

  Future<void> _registerService() async {
    final service = await MDNSService.create(
      instance: 'copycat-$deviceId',
      service: _kServiceType,
      port: _serverPort,
      txt: ['did=$deviceId'],
    );
    _mdnsServer = MDNSServer(MDNSServerConfig(zone: service, reusePort: true));
    await _mdnsServer!.start();
    logger.i('LAN mDNS: advertising "$_kServiceType" on port $_serverPort');
  }

  Future<void> _discoverPeers() async {
    try {
      final entries = await MDNSClient.discover(
        _kServiceType,
        timeout: const Duration(seconds: 5),
        reusePort: true,
      );
      for (final entry in entries) {
        if (!entry.isComplete) continue;
        _handleDiscoveredEntry(entry);
      }
    } catch (e) {
      logger.w('LAN mDNS: discovery error: $e');
    }
  }

  void _handleDiscoveredEntry(ServiceEntry entry) {
    final didField = entry.infoFields.firstWhere(
      (f) => f.startsWith('did='),
      orElse: () => '',
    );
    final did = didField.isNotEmpty
        ? didField.substring(4)
        : (entry.name.startsWith('copycat-') ? entry.name.substring(8) : '');
    if (did.isEmpty || did == deviceId) return;

    final ip = entry.addrV4?.address ?? entry.addrV6?.address;
    if (ip == null) return;

    if (!_peers.containsKey(did)) {
      _peers[did] = LanPeer(did, ip, entry.port);
      _peersController.add(currentPeers);
      unawaited(_savePeers());
      logger.i('LAN: discovered peer $did at $ip:${entry.port}');
      unawaited(_pingSinglePeer(did));
    }
  }

  // MARK: - Sending

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
      'created': item.created.millisecondsSinceEpoch,
      'modified': item.modified.millisecondsSinceEpoch,
      'os': item.os.name,
      'encrypted': item.encrypted,
      if (item.iv != null) 'iv': item.iv,
      if (item.encMode != null) 'encMode': item.encMode,
    });
    final bodyBytes = utf8.encode(body);
    final hmac = _computeHmac(bodyBytes);
    final originId = item.originId ?? ClipboardItem.generateOriginId();

    for (final peer in _peers.values) {
      _sendToPeer(
        host: peer.host,
        port: peer.port,
        originId: originId,
        typeStr: item.type.name,
        bodyBytes: bodyBytes,
        hmac: hmac,
      );
    }
  }

  Future<void> _sendToPeer({
    required String host,
    required int port,
    required String originId,
    required String typeStr,
    required List<int> bodyBytes,
    required String hmac,
  }) async {
    try {
      final client = io.HttpClient();
      client.connectionTimeout = const Duration(seconds: 3);
      final req = await client.postUrl(Uri.parse('http://$host:$port/clip'));
      req.headers
        ..set('X-CC-DID', deviceId)
        ..set('X-CC-OID', originId)
        ..set('X-CC-TYPE', typeStr)
        ..set('X-CC-HMAC', hmac)
        ..contentType = io.ContentType.json
        ..contentLength = bodyBytes.length;
      req.add(bodyBytes);
      final resp = await req.close();
      await resp.drain<void>();
      client.close();
    } catch (e) {
      logger.d('LAN: Could not reach peer $host:$port: $e');
    }
  }

  // MARK: - Auth

  String _computeHmac(List<int> body) {
    final key = utf8.encode(userId);
    final mac = Hmac(sha256, key);
    return mac.convert(body).toString();
  }

  bool _verifyHmac(List<int> body, String expected) {
    if (userId.isEmpty) return false;
    return _computeHmac(body) == expected;
  }

  // MARK: - Helpers

  ClipItemType? _parseClipType(String raw) {
    try {
      return ClipItemType.values.byName(raw.toLowerCase());
    } catch (_) {
      return null;
    }
  }
}

/// A peer discovered on the local network via mDNS.
class LanPeer {
  final String deviceId;
  final String host;
  final int port;

  /// Whether this peer responded to a HTTP `/ping` — i.e. is actively reachable.
  final bool reachable;

  const LanPeer(this.deviceId, this.host, this.port, {this.reachable = false});

  LanPeer withReachable(bool value) =>
      LanPeer(deviceId, host, port, reachable: value);
}
