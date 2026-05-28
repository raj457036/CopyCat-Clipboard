import 'package:flutter_test/flutter_test.dart';
import 'package:clipboard/base/data/services/lan_sync/lan_peer.dart';
import 'package:clipboard/base/data/services/lan_sync/lan_peer_registry.dart';
import 'package:clipboard/base/data/services/lan_sync/lan_sync_config.dart';
import 'package:clipboard/base/enums/platform_os.dart';

void main() {
  group('LanPeer', () {
    test('withReachable returns a copy with updated reachable flag', () {
      const peer = LanPeer('did1', '192.168.1.1', 8080, reachable: false);
      final reachable = peer.withReachable(true);
      expect(reachable.reachable, isTrue);
      expect(reachable.deviceId, 'did1');
      expect(reachable.host, '192.168.1.1');
      expect(reachable.port, 8080);
    });

    test(
      'withReachable(false) on a reachable peer returns unreachable copy',
      () {
        const peer = LanPeer('did2', '10.0.0.1', 9000, reachable: true);
        final unreachable = peer.withReachable(false);
        expect(unreachable.reachable, isFalse);
      },
    );

    test('default reachable value is false', () {
      const peer = LanPeer('did3', 'localhost', 1234);
      expect(peer.reachable, isFalse);
    });
  });

  group('LanPeerRegistry', () {
    late LanSyncConfig config;
    late LanPeerRegistry registry;

    setUp(() {
      config = LanSyncConfig()..deviceId = 'self-device';
      registry = LanPeerRegistry(config);
    });

    tearDown(() {
      registry.dispose();
    });

    // MARK: - recordPeer

    test('recordPeer adds a new peer and returns true', () {
      final changed = registry.recordPeer('peer1', '192.168.1.2', 8080);
      expect(changed, isTrue);
      expect(registry.peers, contains('peer1'));
    });

    test('recordPeer stores OS hint', () {
      registry.recordPeer('peer1', '192.168.1.2', 8080, os: PlatformOS.android);
      expect(registry.peerOsByDeviceId['peer1'], PlatformOS.android);
    });

    test('recordPeer ignores self-device', () {
      final changed = registry.recordPeer('self-device', '127.0.0.1', 9000);
      expect(changed, isFalse);
      expect(registry.peers, isEmpty);
    });

    test('recordPeer ignores empty did', () {
      final changed = registry.recordPeer('', '127.0.0.1', 9000);
      expect(changed, isFalse);
    });

    test('recordPeer returns false when address is unchanged', () {
      registry.recordPeer('peer1', '10.0.0.1', 1234);
      final second = registry.recordPeer('peer1', '10.0.0.1', 1234);
      expect(second, isFalse);
    });

    test('recordPeer returns true when host changes', () {
      registry.recordPeer('peer1', '10.0.0.1', 1234);
      final changed = registry.recordPeer('peer1', '10.0.0.2', 1234);
      expect(changed, isTrue);
    });

    test('recordPeer returns true when port changes', () {
      registry.recordPeer('peer1', '10.0.0.1', 1234);
      final changed = registry.recordPeer('peer1', '10.0.0.1', 5678);
      expect(changed, isTrue);
    });

    test('recordPeer resets failure counter for known peer', () {
      registry.recordPeer('peer1', '10.0.0.1', 1234);
      registry.peerFailures['peer1'] = 5;
      registry.recordPeer('peer1', '10.0.0.1', 9999); // port change → reset
      expect(registry.peerFailures['peer1'], 0);
    });

    // MARK: - evictPeer

    test('evictPeer removes peer, failure count, and OS hint', () {
      registry.recordPeer('peer1', '10.0.0.1', 1234, os: PlatformOS.windows);
      registry.peerFailures['peer1'] = 9;

      registry.evictPeer('peer1');

      expect(registry.peers, isNot(contains('peer1')));
      expect(registry.peerFailures, isNot(contains('peer1')));
      expect(registry.peerOsByDeviceId, isNot(contains('peer1')));
    });

    test('evictPeer on unknown peer is a no-op', () {
      expect(() => registry.evictPeer('nonexistent'), returnsNormally);
    });

    // MARK: - updateReachability

    test('updateReachability marks peer as unreachable', () {
      registry.recordPeer('peer1', '10.0.0.1', 1234, reachable: true);
      registry.updateReachability('peer1', reachable: false);
      expect(registry.peers['peer1']!.reachable, isFalse);
    });

    test('updateReachability marks peer as reachable', () {
      registry.recordPeer('peer1', '10.0.0.1', 1234, reachable: false);
      registry.updateReachability('peer1', reachable: true);
      expect(registry.peers['peer1']!.reachable, isTrue);
    });

    test('updateReachability on unknown peer is a no-op', () {
      expect(
        () => registry.updateReachability('ghost', reachable: true),
        returnsNormally,
      );
    });

    // MARK: - clear

    test('clear empties all maps and emits empty list', () async {
      registry.recordPeer('peer1', '10.0.0.1', 1234, os: PlatformOS.macos);
      registry.peerFailures['peer1'] = 3;

      final emitted = <int>[];
      registry.peersStream.listen((peers) => emitted.add(peers.length));

      registry.clear();

      expect(registry.peers, isEmpty);
      expect(registry.peerFailures, isEmpty);
      expect(registry.peerOsByDeviceId, isEmpty);
    });

    // MARK: - currentPeers

    test('currentPeers returns unmodifiable snapshot', () {
      registry.recordPeer('peer1', '10.0.0.1', 1234);
      final snapshot = registry.currentPeers;
      const extra = LanPeer('extra', '10.0.0.9', 9999);
      expect(() => (snapshot as dynamic).add(extra), throwsUnsupportedError);
    });

    // MARK: - peersStream events

    test('peersStream emits on recordPeer (new peer)', () async {
      final emissions = <List<LanPeer>>[];
      final sub = registry.peersStream.listen(emissions.add);
      addTearDown(sub.cancel);

      registry.recordPeer('peer1', '10.0.0.1', 1234);

      // Allow microtasks to flush.
      await Future<void>.delayed(Duration.zero);

      expect(emissions, isNotEmpty);
      expect(emissions.last.any((p) => p.deviceId == 'peer1'), isTrue);
    });
  });
}
