import 'dart:async';

import 'package:clipboard/base/enums/platform_os.dart';
import 'package:clipboard/common/logging.dart';
import 'package:mdns_dart/mdns_dart.dart';

import 'lan_clip_builder.dart';
import 'lan_constants.dart';
import 'lan_peer_registry.dart';
import 'lan_sync_config.dart';

/// Manages mDNS service advertisement and peer discovery for LAN sync.
class LanDiscovery {
  final LanSyncConfig _config;
  final LanPeerRegistry _registry;

  MDNSServer? _mdnsServer;
  Timer? _warmupTimer;
  bool _inFlight = false;
  DateTime? _lastDiscoveryAt;

  LanDiscovery(this._config, this._registry);

  // MARK: - Lifecycle

  Future<void> start() async {
    await _registerService();
    await discoverThrottled(force: true);
  }

  Future<void> stop() async {
    _warmupTimer?.cancel();
    _warmupTimer = null;
    await _mdnsServer?.stop();
    _mdnsServer = null;
    _inFlight = false;
    _lastDiscoveryAt = null;
  }

  // MARK: - Service registration

  Future<void> _registerService() async {
    final localOs = currentPlatformOS().name;
    final service = await MDNSService.create(
      instance: 'copycat-${_config.deviceId}',
      service: kLanServiceType,
      port: _config.serverPort,
      txt: ['did=${_config.deviceId}', 'os=$localOs'],
    );
    _mdnsServer = MDNSServer(MDNSServerConfig(zone: service, reusePort: true));
    await _mdnsServer!.start();
    logger.i(
      () =>
          'LAN mDNS: advertising "$kLanServiceType" on port ${_config.serverPort}',
    );
  }

  // MARK: - Discovery

  /// Throttled discovery — skips when [kLanDiscoveryCooldown] has not elapsed
  /// unless [force] is true.
  Future<void> discoverThrottled({bool force = false}) async {
    if (_inFlight) return;
    if (!force && _lastDiscoveryAt != null) {
      final elapsed = DateTime.now().difference(_lastDiscoveryAt!);
      if (elapsed < kLanDiscoveryCooldown) return;
    }

    _inFlight = true;
    _lastDiscoveryAt = DateTime.now();
    try {
      await _discoverPeers();
    } finally {
      _inFlight = false;
    }
  }

  Future<void> _discoverPeers() async {
    try {
      final entries = await MDNSClient.discover(
        kLanServiceType,
        timeout: const Duration(seconds: 5),
        reusePort: true,
      );
      for (final entry in entries) {
        if (!entry.isComplete) continue;
        _handleEntry(entry);
      }
    } catch (e) {
      logger.w(() => 'LAN mDNS: discovery error: $e');
    }
  }

  void _handleEntry(ServiceEntry entry) {
    final didField = entry.infoFields.firstWhere(
      (f) => f.startsWith('did='),
      orElse: () => '',
    );
    final osField = entry.infoFields.firstWhere(
      (f) => f.startsWith('os='),
      orElse: () => '',
    );

    final did = didField.isNotEmpty
        ? didField.substring(4)
        : (entry.name.startsWith('copycat-') ? entry.name.substring(8) : '');
    if (did.isEmpty || did == _config.deviceId) return;

    final ip = entry.addrV4?.address ?? entry.addrV6?.address;
    if (ip == null) return;

    final peerOs = osField.isNotEmpty
        ? LanClipBuilder.parseOS(osField.substring(3))
        : null;

    final isNew = !_registry.peers.containsKey(did);
    final changed = _registry.recordPeer(did, ip, entry.port, os: peerOs);
    if (!changed) return;

    unawaited(_registry.save());

    // Stop warmup once at least one peer is found.
    _warmupTimer?.cancel();
    _warmupTimer = null;

    if (isNew) {
      logger.i(() => 'LAN: discovered peer $did at $ip:${entry.port}');
    } else {
      logger.i(() => 'LAN: refreshed peer $did -> $ip:${entry.port}');
    }
  }

  // MARK: - Warmup

  /// Periodically re-runs discovery at [kLanDiscoveryWarmupInterval] until at
  /// least one peer is found, then stops.
  ///
  /// [isRunning] is a callback so the caller can gate the timer without the
  /// discovery object holding a back-reference to the main service.
  void startWarmup(bool Function() isRunning) {
    _warmupTimer?.cancel();
    _warmupTimer = Timer.periodic(kLanDiscoveryWarmupInterval, (_) {
      if (!isRunning()) return;
      if (_registry.peers.isNotEmpty) {
        _warmupTimer?.cancel();
        _warmupTimer = null;
        return;
      }
      unawaited(discoverThrottled(force: true));
    });
  }
}
