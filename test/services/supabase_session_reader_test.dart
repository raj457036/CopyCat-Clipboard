import 'dart:convert';

import 'package:clipboard/base/data/services/supabase_session_reader.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';

void main() {
  const sessionKey = 'sb-example-auth-token';

  Future<SupabaseSessionReader> readerWith(Map<String, Object> values) async {
    SharedPreferences.setMockInitialValues(values);
    return SupabaseSessionReader(
      await SharedPreferences.getInstance(),
      'example',
    );
  }

  test('returns the persisted refresh token', () async {
    final reader = await readerWith({
      sessionKey: jsonEncode({'refresh_token': 'stored-token'}),
    });

    expect(await reader.latestRefreshToken(), 'stored-token');
  });

  test('sees tokens written outside the Dart cache', () async {
    final reader = await readerWith({
      sessionKey: jsonEncode({'refresh_token': 'cached-token'}),
    });
    // Simulates the Android background service writing directly to disk.
    await SharedPreferencesStorePlatform.instance.setValue(
      'String',
      'flutter.$sessionKey',
      jsonEncode({'refresh_token': 'native-token'}),
    );

    expect(await reader.latestRefreshToken(), 'native-token');
  });

  test('returns null when no usable session is stored', () async {
    for (final values in <Map<String, Object>>[
      {},
      {sessionKey: '{"refresh_token":'},
      {sessionKey: '[]'},
      {sessionKey: '{"refresh_token":null}'},
      {sessionKey: '{"refresh_token":""}'},
    ]) {
      final reader = await readerWith(values);
      expect(await reader.latestRefreshToken(), isNull, reason: '$values');
    }
  });
}
