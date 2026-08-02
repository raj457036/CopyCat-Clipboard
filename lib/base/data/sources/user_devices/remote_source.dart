import 'package:clipboard/base/constants/numbers/values.dart';
import 'package:clipboard/base/domain/model/sync/user_device_access.dart';
import 'package:clipboard/base/domain/sources/user_devices.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@Named('remote')
@LazySingleton(as: UserDevicesSource)
class RemoteUserDevicesSource implements UserDevicesSource {
  final SupabaseClient client;

  RemoteUserDevicesSource(this.client);

  static const String _devicesTable = 'user_devices';
  static const String _manageDevicesFunction = 'manage_sync_devices';
  static const String _subscriptionTable = 'subscription';
  static const int _defaultDeviceLimit = defaultNoOfSyncedDevices;
  static const int _activityWindowDays = 30;

  PostgrestClient get db => client.rest;
  FunctionsClient get function => client.functions;

  List<SyncDeviceInfo> _parseDevices(dynamic rawDevices) {
    final rows = (rawDevices as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>();

    return rows.map(SyncDeviceInfo.fromJson).toList(growable: false);
  }

  Future<int> _getPlanDeviceLimit(String userId) async {
    final data = await db
        .from(_subscriptionTable)
        .select('devices')
        .eq('userId', userId)
        .maybeSingle();

    final configuredLimit = (data?['devices'] as num?)?.toInt();
    if (configuredLimit == null || configuredLimit <= 0) {
      return _defaultDeviceLimit;
    }
    return configuredLimit;
  }

  Future<List<SyncDeviceInfo>> _getActiveDevices(String userId) async {
    final activeSince = DateTime.now()
        .subtract(const Duration(days: _activityWindowDays))
        .toIso8601String();

    final rows = await db
        .from(_devicesTable)
        .select('deviceId, platform, appVersion, name, isRevoked, last_seen_at')
        .eq('userId', userId)
        .eq('isRevoked', false)
        .gte('last_seen_at', activeSince)
        .order('last_seen_at', ascending: false);

    return rows
        .whereType<Map<String, dynamic>>()
        .map(SyncDeviceInfo.fromJson)
        .toList(growable: false);
  }

  @override
  Future<DeviceRegistrationResult> registerDevice({
    required String userId,
    required String deviceId,
    required String platform,
    String? appVersion,
  }) async {
    assert(userId.isNotEmpty);

    final response = await function.invoke(
      _manageDevicesFunction,
      method: HttpMethod.post,
      body: {
        'action': 'register',
        'deviceId': deviceId,
        'platform': platform,
        'appVersion': appVersion,
      },
    );

    final data = Map<String, dynamic>.from(response.data as Map);
    final devices = _parseDevices(data['devices']);

    return DeviceRegistrationResult(
      allowed: (data['allowed'] as bool?) ?? false,
      limit: (data['limit'] as num?)?.toInt() ?? 0,
      activeCount: (data['activeCount'] as num?)?.toInt() ?? devices.length,
      devices: devices,
    );
  }

  @override
  Future<DeviceListResult> listDevices({required String userId}) async {
    final rows = await db
        .from(_devicesTable)
        .select('deviceId, platform, appVersion, name, isRevoked, last_seen_at')
        .eq('userId', userId)
        .order('last_seen_at', ascending: false);

    final devices = rows
        .whereType<Map<String, dynamic>>()
        .map(SyncDeviceInfo.fromJson)
        .toList(growable: false);

    final limit = await _getPlanDeviceLimit(userId);
    final activeDevices = await _getActiveDevices(userId);

    return DeviceListResult(
      devices: devices,
      limit: limit,
      activeCount: activeDevices.length,
    );
  }

  @override
  Future<void> updateDeviceName({
    required String userId,
    required String deviceId,
    String? name,
  }) async {
    assert(userId.isNotEmpty);

    final normalizedName = name?.trim();
    await db
        .from(_devicesTable)
        .update({'name': normalizedName?.isNotEmpty == true ? normalizedName : null})
        .eq('userId', userId)
        .eq('deviceId', deviceId);
  }

  @override
  Future<void> revokeDevice({
    required String userId,
    required String deviceId,
  }) async {
    assert(userId.isNotEmpty);

    await function.invoke(
      _manageDevicesFunction,
      method: HttpMethod.post,
      body: {'action': 'revoke', 'deviceId': deviceId},
    );
  }
}
