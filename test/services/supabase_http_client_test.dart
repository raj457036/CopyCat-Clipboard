import 'dart:convert';

import 'package:clipboard/base/data/services/supabase_http_client.dart';
import 'package:clipboard/base/data/services/supabase_session_reader.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class _FakeSessionReader implements SupabaseSessionReader {
  _FakeSessionReader(this.token);

  final String? token;

  @override
  Future<String?> latestRefreshToken() async => token;
}

void main() {
  final refreshUrl = Uri.parse(
    'https://example.supabase.co/auth/v1/token?grant_type=refresh_token',
  );

  group('refresh token sync', () {
    Future<Map<String, dynamic>> sentRefreshBody({
      required SupabaseSessionReader? reader,
      required Map<String, dynamic> body,
      Uri? url,
    }) async {
      late Map<String, dynamic> sent;
      final client = SupabaseHttpClient(
        sessionReader: reader,
        inner: MockClient((request) async {
          sent = jsonDecode(request.body) as Map<String, dynamic>;
          return http.Response('{}', 200);
        }),
      );
      await client.post(url ?? refreshUrl, body: jsonEncode(body));
      return sent;
    }

    test('sends the latest persisted token and keeps other fields', () async {
      final sent = await sentRefreshBody(
        reader: _FakeSessionReader('latest-token'),
        body: {'refresh_token': 'stale-token', 'other': 'preserved'},
      );

      expect(sent, {'refresh_token': 'latest-token', 'other': 'preserved'});
    });

    test('keeps the in-memory token when nothing is persisted', () async {
      final sent = await sentRefreshBody(
        reader: _FakeSessionReader(null),
        body: {'refresh_token': 'in-memory-token'},
      );

      expect(sent['refresh_token'], 'in-memory-token');
    });

    test('keeps the in-memory token without a session reader', () async {
      final sent = await sentRefreshBody(
        reader: null,
        body: {'refresh_token': 'in-memory-token'},
      );

      expect(sent['refresh_token'], 'in-memory-token');
    });

    test('leaves non-refresh requests untouched', () async {
      final sent = await sentRefreshBody(
        reader: _FakeSessionReader('latest-token'),
        body: {'refresh_token': 'in-memory-token'},
        url: Uri.parse(
          'https://example.supabase.co/auth/v1/token?grant_type=password',
        ),
      );

      expect(sent['refresh_token'], 'in-memory-token');
    });

    test('Supabase adopts the session returned for the latest token', () async {
      const session = {
        'access_token': 'access-token',
        'token_type': 'bearer',
        'user': {'id': 'user-1'},
      };
      String? sentToken;
      final client = SupabaseHttpClient(
        sessionReader: _FakeSessionReader('native-token'),
        inner: MockClient((request) async {
          sentToken = jsonDecode(request.body)['refresh_token'] as String;
          return http.Response(
            jsonEncode({...session, 'refresh_token': 'rotated-token'}),
            200,
          );
        }),
      );
      final auth = supabase.GoTrueClient(
        url: 'https://example.supabase.co/auth/v1',
        httpClient: client,
        autoRefreshToken: false,
      );
      addTearDown(auth.dispose);

      await auth.setInitialSession(
        jsonEncode({...session, 'refresh_token': 'stale-token'}),
      );
      await auth.refreshSession();

      expect(sentToken, 'native-token');
      expect(auth.currentSession?.refreshToken, 'rotated-token');
    });
  });

  group('refresh error normalization', () {
    SupabaseHttpClient clientReturning(int status, String body) =>
        SupabaseHttpClient(
          inner: MockClient((_) async => http.Response(body, status)),
        );

    test('non-JSON 4xx becomes retryable 503', () async {
      final response = await clientReturning(
        403,
        '<html>Captive portal</html>',
      ).post(refreshUrl);

      expect(response.statusCode, 503);
      expect(response.body, '<html>Captive portal</html>');
    });

    test('empty redirect becomes retryable 503', () async {
      final response = await clientReturning(302, '').post(refreshUrl);

      expect(response.statusCode, 503);
    });

    test('rate limiting becomes retryable 503', () async {
      final response = await clientReturning(
        429,
        jsonEncode({'code': 'over_request_rate_limit', 'msg': 'slow down'}),
      ).post(refreshUrl);

      expect(response.statusCode, 503);
    });

    test('genuine auth error is passed through', () async {
      final body = jsonEncode({
        'code': 'refresh_token_not_found',
        'msg': 'Invalid Refresh Token',
      });
      final response = await clientReturning(400, body).post(refreshUrl);

      expect(response.statusCode, 400);
      expect(response.body, body);
    });

    test('non-refresh errors are passed through', () async {
      final response = await clientReturning(403, '<html></html>').post(
        Uri.parse(
          'https://example.supabase.co/auth/v1/token?grant_type=password',
        ),
      );

      expect(response.statusCode, 403);
    });
  });
}
