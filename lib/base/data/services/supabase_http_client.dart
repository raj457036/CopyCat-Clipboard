import 'dart:convert';

import 'package:clipboard/base/data/services/supabase_session_reader.dart';
import 'package:clipboard/common/logging.dart';
import 'package:http/http.dart' as http;

/// HTTP client used by Supabase that keeps the session alive across token
/// refreshes. Only refresh-token requests are touched:
///
/// 1. Before sending, the refresh token is replaced with the latest persisted
///    one when a [SupabaseSessionReader] is provided. This lets the SDK pick
///    up tokens rotated by the Android background service.
/// 2. After receiving, transient failures are rewritten to `503`. gotrue signs
///    the user out on *any* non-5xx refresh error, but non-JSON 3xx/4xx
///    responses (captive portals, VPN/proxy reconnects, CDN error pages) and
///    rate limiting are not session problems. Genuine auth errors (a JSON body
///    carrying an error code, e.g. `refresh_token_not_found`) pass through.
class SupabaseHttpClient extends http.BaseClient {
  SupabaseHttpClient({http.Client? inner, SupabaseSessionReader? sessionReader})
    : _inner = inner ?? http.Client(),
      _sessionReader = sessionReader;

  final http.Client _inner;
  final SupabaseSessionReader? _sessionReader;

  static const _transientStatusCodes = {408, 425, 429};
  static const _transientErrorCodes = {'over_request_rate_limit'};
  static const _logThrottle = Duration(minutes: 1);

  String? _lastLogKey;
  DateTime? _lastLogAt;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (!_isRefreshTokenRequest(request.url)) return _inner.send(request);

    await _useLatestRefreshToken(request);
    return _normalizeRefreshResponse(await _inner.send(request));
  }

  @override
  void close() => _inner.close();

  bool _isRefreshTokenRequest(Uri url) =>
      url.path.endsWith('/auth/v1/token') &&
      url.queryParameters['grant_type'] == 'refresh_token';

  Future<void> _useLatestRefreshToken(http.BaseRequest request) async {
    final reader = _sessionReader;
    if (reader == null || request is! http.Request) return;

    final body = _decodeJsonObject(request.body);
    final latestToken = await reader.latestRefreshToken();
    if (body == null ||
        latestToken == null ||
        body['refresh_token'] == latestToken) {
      return;
    }
    request.body = jsonEncode({...body, 'refresh_token': latestToken});
  }

  Future<http.StreamedResponse> _normalizeRefreshResponse(
    http.StreamedResponse response,
  ) async {
    final status = response.statusCode;
    if (status >= 200 && status < 300) return response;

    if (status >= 500) {
      _log(status, null, transient: true);
      return response;
    }

    final bytes = await response.stream.toBytes();
    final errorCode = _authErrorCode(bytes);
    final transient =
        errorCode == null ||
        _transientStatusCodes.contains(status) ||
        _transientErrorCodes.contains(errorCode);

    _log(status, errorCode, transient: transient);

    return http.StreamedResponse(
      Stream.value(bytes),
      transient ? 503 : status,
      contentLength: bytes.length,
      request: response.request,
      headers: response.headers,
      isRedirect: response.isRedirect,
      persistentConnection: response.persistentConnection,
      reasonPhrase: transient ? 'Service Unavailable' : response.reasonPhrase,
    );
  }

  String? _authErrorCode(List<int> bytes) {
    final data = _decodeJsonObject(utf8.decode(bytes, allowMalformed: true));
    if (data == null) return null;
    for (final key in const ['error_code', 'code', 'error']) {
      final value = data[key];
      if (value is String && value.isNotEmpty) return value;
    }
    return null;
  }

  Map<String, dynamic>? _decodeJsonObject(String source) {
    try {
      final decoded = jsonDecode(source);
      return decoded is Map<String, dynamic> ? decoded : null;
    } on FormatException {
      return null;
    }
  }

  void _log(int status, String? errorCode, {required bool transient}) {
    final key = '$status:$errorCode:$transient';
    final now = DateTime.now();
    if (key == _lastLogKey &&
        _lastLogAt != null &&
        now.difference(_lastLogAt!) < _logThrottle) {
      return;
    }
    _lastLogKey = key;
    _lastLogAt = now;

    final message =
        'Auth token refresh failed: status=$status, '
        'code=${errorCode ?? 'none'}';
    if (transient) {
      logger.w('$message (treated as transient, will retry)');
    } else {
      logger.e('$message (session rejected by server)');
    }
  }
}
