import 'dart:async';
import 'dart:io' as io;

import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/services/clip_batch_sync_service.dart';
import 'package:clipboard/base/domain/services/sync_event_bus.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/base/enums/platform_os.dart';
import 'package:clipboard/common/logging.dart';
import 'package:injectable/injectable.dart';

import 'lan_clip_builder.dart';
import 'lan_constants.dart';
import 'lan_discovery.dart';
import 'lan_hmac.dart';
import 'lan_http_handler.dart';
import 'lan_peer.dart';
import 'lan_peer_registry.dart';
import 'lan_receiver.dart';
import 'lan_sender.dart';
import 'lan_sync_config.dart';

export 'lan_peer.dart';

/// LAN sync service.
///
/// Orchestrates the HTTP server, mDNS advertisement/discovery, peer management,
/// and clip send/receive across the local network.
///
/// Collaborator Classes:
/// - [LanPeerRegistry] — peer state and persistence
/// - [LanDiscovery]    — mDNS registration and discovery
/// - [LanHttpHandler]  — HTTP request dispatch
/// - [LanSender]       — outbound clip delivery
/// - [LanReceiver]     — inbound clip processing
/// - [LanHmac]         — HMAC authentication
/// - [LanClipBuilder]  — ClipboardItem construction from payloads
@lazySingleton
class LanSyncService {
  final ClipBatchSyncService _batchSync;
  final SyncEventBus _syncEventBus;

  // MARK: - Collaborators

  late final LanSyncConfig _cfg;
  late final LanPeerRegistry _registry;
  late final LanHmac _hmac;
  late final LanClipBuilder _clipBuilder;
  late final LanReceiver _receiver;
  late final LanSender _sender;
  late final LanDiscovery _discovery;
  late final LanHttpHandler _httpHandler;

  LanSyncService(this._batchSync, this._syncEventBus) {
    _cfg = LanSyncConfig();
    _registry = LanPeerRegistry(_cfg);
    _hmac = LanHmac(_cfg);
    _clipBuilder = LanClipBuilder(_cfg);
    _receiver = LanReceiver(_cfg, _batchSync, _syncEventBus, _clipBuilder);
    _sender = LanSender(_cfg, _registry, _hmac);
    _discovery = LanDiscovery(_cfg, _registry);
    _httpHandler = LanHttpHandler(_cfg, _registry, _hmac, _receiver);
  }

  // MARK: - Config surface

  String get deviceId => _cfg.deviceId;
  set deviceId(String v) => _cfg.deviceId = v;

  String get userId => _cfg.userId;
  set userId(String v) => _cfg.userId = v;

  bool lanSyncEnabled = false;

  // MARK: - Runtime state

  io.HttpServer? _httpServer;
  Timer? _pingTimer;
  Timer? _discoveryTimer;
  bool _started = false;

  // MARK: - Public streams / snapshot

  Stream<List<LanPeer>> get peersStream => _registry.peersStream;
  List<LanPeer> get currentPeers => _registry.currentPeers;

  // MARK: - Lifecycle

  Future<void> start() async {
    if (_started || !lanSyncEnabled) return;

    try {
      await _startHttpServer();
    } catch (e, st) {
      logger.e(
        'LanSyncService: HTTP server failed to start: $e',
        stackTrace: st,
      );
      return;
    }
    _started = true;

    unawaited(_registry.restore((host, port) => _checkReachable(host, port)));

    try {
      await _discovery.start();
    } catch (e) {
      logger.w(
        () =>
            'LanSyncService: mDNS failed (non-fatal, reverse learning active): $e',
      );
    }

    _pingTimer = Timer.periodic(kLanPingInterval, (_) => _pingAllPeers());
    _discoveryTimer = Timer.periodic(
      kLanDiscoveryInterval,
      (_) => unawaited(_discovery.discoverThrottled()),
    );
    _discovery.startWarmup(() => _started);
    logger.i(() => 'LanSyncService started on port ${_cfg.serverPort}');
  }

  Future<void> stop() async {
    if (!_started) return;
    _started = false;
    await _httpServer?.close(force: true);
    _httpServer = null;
    _pingTimer?.cancel();
    _pingTimer = null;
    _discoveryTimer?.cancel();
    _discoveryTimer = null;
    await _discovery.stop();
    _registry.clear();
    logger.i(() => 'LanSyncService stopped');
  }

  Future<void> reconfigure({bool? enabled}) async {
    if (enabled != null) lanSyncEnabled = enabled;
    if (lanSyncEnabled && !_started) {
      await start();
    } else if (!lanSyncEnabled && _started) {
      await stop();
    }
  }

  // MARK: - Send

  Future<void> broadcastClip(ClipboardItem item) async {
    if (!_started || _registry.peers.isEmpty) return;
    if (item.type == ClipItemType.text || item.type == ClipItemType.url) {
      await _sender.broadcastTextClip(item);
    } else if (item.type == ClipItemType.media ||
        item.type == ClipItemType.file) {
      await _sender.broadcastBinaryClip(item);
    }
  }

  // MARK: - HTTP server

  Future<void> _startHttpServer() async {
    _httpServer = await io.HttpServer.bind(io.InternetAddress.anyIPv4, 0);
    _cfg.serverPort = _httpServer!.port;
    _httpServer!.listen(
      _httpHandler.handle,
      onError: (Object e) {
        logger.w(() => 'LAN HTTP server error: $e');
      },
    );
  }

  // MARK: - Peer reachability / ping

  void _pingAllPeers() {
    for (final did in _registry.peers.keys.toList()) {
      unawaited(_pingSinglePeer(did));
    }
  }

  Future<void> _pingSinglePeer(String did) async {
    final peer = _registry.peers[did];
    if (peer == null) return;

    final reachable = await _checkReachable(peer.host, peer.port);
    if (!_registry.peers.containsKey(did)) return;

    if (reachable) {
      _registry.peerFailures[did] = 0;
      _registry.updateReachability(did, reachable: true);
    } else {
      final failures = (_registry.peerFailures[did] ?? 0) + 1;
      _registry.peerFailures[did] = failures;
      if (failures >= kLanMaxPeerFailures) {
        _registry.evictPeer(did);
        unawaited(_registry.save());
        logger.i(
          () => 'LAN: removed unresponsive peer $did after $failures failures',
        );
        unawaited(_discovery.discoverThrottled(force: true));
      } else {
        _registry.updateReachability(did, reachable: false);
      }
    }
  }

  Future<bool> _checkReachable(String host, int port) async {
    final client = io.HttpClient();
    try {
      client.connectionTimeout = const Duration(seconds: 2);
      final req = await client.getUrl(Uri.parse('http://$host:$port/ping'));
      req.headers
        ..set('X-CC-DID', _cfg.deviceId)
        ..set('X-CC-PORT', _cfg.serverPort.toString())
        ..set('X-CC-OS', currentPlatformOS().name);
      final resp = await req.close();
      await resp.drain<void>();
      return resp.statusCode == io.HttpStatus.ok;
    } catch (_) {
      return false;
    } finally {
      client.close(force: true);
    }
  }
}
