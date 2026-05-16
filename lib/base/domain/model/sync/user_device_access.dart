class SyncDeviceInfo {
  final String deviceId;
  final String platform;
  final String? appVersion;
  final DateTime lastSeenAt;
  final bool isRevoked;

  const SyncDeviceInfo({
    required this.deviceId,
    required this.platform,
    required this.appVersion,
    required this.lastSeenAt,
    required this.isRevoked,
  });

  factory SyncDeviceInfo.fromJson(Map<String, dynamic> json) {
    return SyncDeviceInfo(
      deviceId: (json['deviceId'] ?? json['device_id']) as String,
      platform: (json['platform'] as String?) ?? 'unknown',
      appVersion: (json['appVersion'] ?? json['app_version']) as String?,
      lastSeenAt:
          DateTime.tryParse(
            (json['lastSeenAt'] ?? json['last_seen_at']) as String? ?? '',
          ) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      isRevoked: (json['isRevoked'] ?? json['is_revoked']) as bool? ?? false,
    );
  }
}

class DeviceRegistrationResult {
  final bool allowed;
  final int limit;
  final int activeCount;
  final List<SyncDeviceInfo> devices;

  const DeviceRegistrationResult({
    required this.allowed,
    required this.limit,
    required this.activeCount,
    required this.devices,
  });
}

class DeviceListResult {
  final List<SyncDeviceInfo> devices;
  final int limit;
  final int activeCount;

  const DeviceListResult({
    required this.devices,
    required this.limit,
    required this.activeCount,
  });
}
