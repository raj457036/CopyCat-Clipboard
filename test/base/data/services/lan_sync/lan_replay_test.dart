import 'package:flutter_test/flutter_test.dart';
import 'package:clipboard/base/data/services/lan_sync/lan_receiver.dart';

void main() {
  group('LanReceiver.isReplayTimestamp', () {
    test('returns false when timestamp is fresh (within window)', () {
      final nowMs = DateTime.now().millisecondsSinceEpoch;
      expect(LanReceiver.isReplayTimestamp(nowMs, 10000), isFalse);
    });

    test('returns false when timestamp is slightly old but inside window', () {
      final ts = DateTime.now().millisecondsSinceEpoch - 5000; // 5 s ago
      expect(LanReceiver.isReplayTimestamp(ts, 10000), isFalse);
    });

    test('returns true when timestamp is older than window', () {
      final ts = DateTime.now().millisecondsSinceEpoch - 11000; // 11 s ago
      expect(LanReceiver.isReplayTimestamp(ts, 10000), isTrue);
    });

    test('returns true for ts=0 (epoch)', () {
      expect(LanReceiver.isReplayTimestamp(0, 10000), isTrue);
    });

    test('returns true when ts is exactly at the boundary', () {
      // Boundary: ts == now - windowMs  →  diff == windowMs  →  NOT > windowMs
      // One ms over the boundary should be a replay.
      final ts =
          DateTime.now().millisecondsSinceEpoch - 10001; // 1 ms past window
      expect(LanReceiver.isReplayTimestamp(ts, 10000), isTrue);
    });

    test('uses correct binary replay window constant (60 s)', () {
      final ts = DateTime.now().millisecondsSinceEpoch - 61000; // 61 s
      expect(LanReceiver.isReplayTimestamp(ts, 60000), isTrue);
    });

    test('within binary window is not a replay', () {
      final ts = DateTime.now().millisecondsSinceEpoch - 30000; // 30 s
      expect(LanReceiver.isReplayTimestamp(ts, 60000), isFalse);
    });
  });
}
