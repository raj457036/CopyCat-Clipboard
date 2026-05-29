import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:path_provider/path_provider.dart';
import 'package:clipboard/base/enums/platform_os.dart';
import 'package:clipboard/common/logging.dart';

import 'lan_peer.dart';
import 'lan_sync_config.dart';

/// Manages the in-memory peer state (map, failure counters, OS hints) and
/// provides persistence so peers survive app restarts.
class LanPeerRegistry {
  final LanSyncConfig _config;

  final Map<String, LanPeer> peers = {};
  final Map<String, int> peerFailures = {};
  final Map<String, PlatformOS> peerOsByDeviceId = {};

  final _controller = StreamController<List<LanPeer>>.broadcast();

  LanPeerRegistry(this._config);

  Stream<List<LanPeer>> get peersStream => _controller.stream;

  List<LanPeer> get currentPeers => List.unmodifiable(peers.values.toList());

  /// Record a peer (from mDNS, ping response, or clip header).
  /// Returns true if the registry changed (new peer or updated address).
  bool recordPeer(
    String did,
    String host,
    int port, {
    PlatformOS? os,
    bool reachable = true,
  }) {
    if (did.isEmpty || did == _config.deviceId) return false;
    if (os != null) peerOsByDeviceId[did] = os;
    final existing = peers[did];
    final changed =
        existing == null ||
        existing.host != host ||
        existing.port != port ||
        existing.reachable != reachable;
    if (!changed) return false;
    peers[did] = LanPeer(did, host, port, reachable: reachable);
    peerFailures[did] = 0;
    _controller.add(currentPeers);
    return true;
  }

  /// Remove a peer and all its associated state from the registry.
  void evictPeer(String did) {
    peers.remove(did);
    peerFailures.remove(did);
    peerOsByDeviceId.remove(did);
    _controller.add(currentPeers);
  }

  /// Mark a peer as reachable or unreachable without removing it.
  void updateReachability(String did, {required bool reachable}) {
    final peer = peers[did];
    if (peer == null) return;
    peers[did] = peer.withReachable(reachable);
    _controller.add(currentPeers);
  }

  void clear() {
    peers.clear();
    peerFailures.clear();
    peerOsByDeviceId.clear();
    _controller.add([]);
  }

  void dispose() {
    _controller.close();
  }

  // MARK: - Persistence

  Future<io.File> get _peersFile async {
    final dir = await getApplicationSupportDirectory();
    return io.File('${dir.path}/cached_lan_peers.json');
  }

  /// Persist the current peer map to disk.
  Future<void> save() async {
    try {
      final data = <String, dynamic>{};
      for (final e in peers.entries) {
        data[e.key] = {
          'host': e.value.host,
          'port': e.value.port,
          'os': peerOsByDeviceId[e.key]?.name,
        };
      }
      final file = await _peersFile;
      await file.writeAsString(jsonEncode(data));
    } catch (_) {}
  }

  /// Restore peers from disk, pinging each one to verify reachability.
  ///
  /// [isReachable] is a callback so the caller can inject the HTTP check.
  Future<void> restore(
    Future<bool> Function(String host, int port) isReachable,
  ) async {
    try {
      final file = await _peersFile;
      if (!await file.exists()) return;
      final data =
          jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      var anyRestored = false;
      await Future.wait(
        data.entries.map((entry) async {
          final did = entry.key;
          if (did == _config.deviceId) return;
          final peerData = entry.value as Map<String, dynamic>;
          final host = peerData['host'] as String?;
          final port = peerData['port'] as int?;
          final os = _parseOS(peerData['os'] as String?);
          if (host == null || port == null) return;
          if (await isReachable(host, port)) {
            peers[did] = LanPeer(did, host, port, reachable: true);
            if (os != null) peerOsByDeviceId[did] = os;
            anyRestored = true;
            logger.i(() => 'LAN: restored peer $did at $host:$port from disk');
          }
        }),
      );
      if (anyRestored) _controller.add(currentPeers);
    } catch (e) {
      logger.w(() => 'LAN: could not restore persisted peers: $e');
    }
  }

  static PlatformOS? _parseOS(String? raw) {
    if (raw == null) return null;
    try {
      return PlatformOS.values.byName(raw);
    } catch (_) {
      return null;
    }
  }
}
