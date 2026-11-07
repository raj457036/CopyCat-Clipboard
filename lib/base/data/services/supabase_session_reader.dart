import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Reads the Supabase session that `supabase_flutter` persists in
/// SharedPreferences.
///
/// SharedPreferences is the source of truth for the session on Android, where
/// the native background service can rotate the refresh token without the
/// Supabase SDK noticing.
class SupabaseSessionReader {
  SupabaseSessionReader(this._preferences, String projectKey)
    : _storageKey = 'sb-$projectKey-auth-token';

  final SharedPreferences _preferences;
  final String _storageKey;

  /// Returns the latest persisted refresh token, or `null` when no usable
  /// session is stored.
  Future<String?> latestRefreshToken() async {
    // Bypass the in-memory cache so writes made by native code are visible.
    await _preferences.reload();
    final session = _preferences.getString(_storageKey);
    if (session == null) return null;

    try {
      final decoded = jsonDecode(session);
      final token = decoded is Map ? decoded['refresh_token'] : null;
      return token is String && token.isNotEmpty ? token : null;
    } on FormatException {
      return null;
    }
  }
}
