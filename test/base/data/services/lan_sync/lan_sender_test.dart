import 'package:flutter_test/flutter_test.dart';
import 'package:clipboard/base/data/services/lan_sync/lan_sender.dart';

void main() {
  group('LanSender.buildPeerUri', () {
    test('constructs valid URI for standard IPv4 host', () {
      final uri = LanSender.buildPeerUri('192.168.0.218', 35859, '/clip');
      expect(uri.toString(), equals('http://192.168.0.218:35859/clip'));
      expect(uri.host, equals('192.168.0.218'));
      expect(uri.port, equals(35859));
      expect(uri.path, equals('/clip'));
    });

    test('constructs valid bracketed URI for unbracketed IPv6 host without throwing', () {
      const ipv6 = 'fe80:0:0:0:7bea:6331:6684:c69c';
      final uri = LanSender.buildPeerUri(ipv6, 35859, '/clip');
      expect(uri.toString(), equals('http://[fe80:0:0:0:7bea:6331:6684:c69c]:35859/clip'));
      expect(uri.host, equals('fe80:0:0:0:7bea:6331:6684:c69c'));
      expect(uri.port, equals(35859));
      expect(uri.path, equals('/clip'));
    });

    test('handles already bracketed IPv6 host gracefully', () {
      const ipv6 = '[fe80:0:0:0:7bea:6331:6684:c69c]';
      final uri = LanSender.buildPeerUri(ipv6, 35859, '/ping');
      expect(uri.toString(), equals('http://[fe80:0:0:0:7bea:6331:6684:c69c]:35859/ping'));
      expect(uri.host, equals('fe80:0:0:0:7bea:6331:6684:c69c'));
      expect(uri.port, equals(35859));
      expect(uri.path, equals('/ping'));
    });
  });

  group('LanSender.formatPeerDescription', () {
    test('formats IPv4 as host:port', () {
      expect(
        LanSender.formatPeerDescription('192.168.1.5', 8080),
        equals('192.168.1.5:8080'),
      );
    });

    test('brackets IPv6 in peer description', () {
      expect(
        LanSender.formatPeerDescription('fe80::1', 8080),
        equals('[fe80::1]:8080'),
      );
    });

    test('does not double bracket already bracketed IPv6', () {
      expect(
        LanSender.formatPeerDescription('[fe80::1]', 8080),
        equals('[fe80::1]:8080'),
      );
    });
  });
}
