import 'package:clipboard/base/domain/model/sync/user_device_access.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SyncDeviceInfo.fromJson', () {
    test('parses the device name when present', () {
      final device = SyncDeviceInfo.fromJson({
        'deviceId': 'device-123',
        'platform': 'macos',
        'appVersion': '1.2.3',
        'name': 'My MacBook',
        'last_seen_at': '2026-08-02T10:00:00.000Z',
        'isRevoked': false,
      });

      expect(device.name, 'My MacBook');
      expect(device.platform, 'macos');
      expect(device.isRevoked, isFalse);
    });

    test('falls back to alternate key names for device name', () {
      final device = SyncDeviceInfo.fromJson({
        'deviceId': 'device-456',
        'platform': 'windows',
        'deviceName': 'Office PC',
        'last_seen_at': '2026-08-02T10:00:00.000Z',
      });

      expect(device.name, 'Office PC');
    });
  });
}
