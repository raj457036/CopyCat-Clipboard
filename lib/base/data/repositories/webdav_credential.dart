import 'dart:convert';

import 'package:clipboard/base/domain/model/webdav_config/webdav_config.dart';
import 'package:clipboard/base/domain/repositories/webdav_credential.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/logging.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:simple_webdav_client/client.dart';
import 'package:universal_io/io.dart';

@LazySingleton(as: WebDavCredentialRepository)
class WebDavCredentialRepositoryImpl implements WebDavCredentialRepository {
  static const String _storageKey = 'copycat.webdav_config';
  static const _logger = AppLogger.scoped('WebDavCredentialRepo');

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  WebDavCredentialRepositoryImpl();

  @override
  FailureOr<WebDavConfig?> getConfig() async {
    try {
      final raw = await _secureStorage.read(key: _storageKey);
      if (raw == null || raw.isEmpty) {
        return const Right(null);
      }
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return Right(WebDavConfig.fromJson(json));
    } catch (e) {
      _logger.e('Failed to read WebDAV config: $e');
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<void> saveConfig(WebDavConfig config) async {
    try {
      final raw = jsonEncode(config.toJson());
      await _secureStorage.write(key: _storageKey, value: raw);
      return const Right(null);
    } catch (e) {
      _logger.e('Failed to save WebDAV config: $e');
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<void> deleteConfig() async {
    try {
      await _secureStorage.delete(key: _storageKey);
      return const Right(null);
    } catch (e) {
      _logger.e('Failed to delete WebDAV config: $e');
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<void> testConnection(WebDavConfig config) async {
    try {
      final uri = Uri.parse(config.serverUrl.trim());
      if (!uri.hasScheme || !uri.hasAuthority) {
        return const Left(
          Failure(
            message: 'Invalid WebDAV Server URL format.',
            code: 'invalid-url',
          ),
        );
      }

      final client = WebDavStdClient();
      final dispatcher = client.dispatch(uri);

      final req = await dispatcher.findAllProps();
      final authHeader =
          'Basic ${base64Encode(utf8.encode('${config.username}:${config.password}'))}';
      req.request.headers.set(HttpHeaders.authorizationHeader, authHeader);

      final resp = await req.close().timeout(const Duration(seconds: 15));

      final statusCode = resp.response.statusCode;
      if ((statusCode >= 200 && statusCode < 300) || statusCode == 207) {
        return const Right(null);
      } else if (statusCode == 401 || statusCode == 403) {
        return const Left(
          Failure(
            message:
                'Authentication failed. Please check your username and password.',
            code: 'webdav-auth-failed',
          ),
        );
      } else if (statusCode == 404) {
        return const Left(
          Failure(
            message: 'Server URL path not found (404).',
            code: 'webdav-not-found',
          ),
        );
      } else {
        return Left(
          Failure(
            message: 'WebDAV server returned status code $statusCode.',
            code: 'webdav-status-$statusCode',
          ),
        );
      }
    } catch (e) {
      _logger.e('WebDAV test connection error: $e');
      return Left(Failure.fromException(e));
    }
  }
}
