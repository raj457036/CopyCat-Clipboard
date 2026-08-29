import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:flutter/foundation.dart';

@immutable
class WebDavConfig {
  final String serverUrl;
  final String username;
  final String password;
  final String basePath;
  final bool allowSelfSignedCert;

  const WebDavConfig({
    required this.serverUrl,
    required this.username,
    required this.password,
    this.basePath = defaultWebDavBasePath,
    this.allowSelfSignedCert = false,
  });

  String get sanitizedBasePath {
    String path = basePath.trim();
    if (!path.startsWith('/')) {
      path = '/$path';
    }
    if (path.endsWith('/') && path.length > 1) {
      path = path.substring(0, path.length - 1);
    }
    return path;
  }

  WebDavConfig copyWith({
    String? serverUrl,
    String? username,
    String? password,
    String? basePath,
    bool? allowSelfSignedCert,
  }) {
    return WebDavConfig(
      serverUrl: serverUrl ?? this.serverUrl,
      username: username ?? this.username,
      password: password ?? this.password,
      basePath: basePath ?? this.basePath,
      allowSelfSignedCert: allowSelfSignedCert ?? this.allowSelfSignedCert,
    );
  }

  Map<String, dynamic> toJson() => {
        'serverUrl': serverUrl,
        'username': username,
        'password': password,
        'basePath': basePath,
        'allowSelfSignedCert': allowSelfSignedCert,
      };

  factory WebDavConfig.fromJson(Map<String, dynamic> json) => WebDavConfig(
        serverUrl: json['serverUrl'] as String? ?? '',
        username: json['username'] as String? ?? '',
        password: json['password'] as String? ?? '',
        basePath: json['basePath'] as String? ?? defaultWebDavBasePath,
        allowSelfSignedCert: json['allowSelfSignedCert'] as bool? ?? false,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WebDavConfig &&
          runtimeType == other.runtimeType &&
          serverUrl == other.serverUrl &&
          username == other.username &&
          password == other.password &&
          basePath == other.basePath &&
          allowSelfSignedCert == other.allowSelfSignedCert;

  @override
  int get hashCode =>
      serverUrl.hashCode ^
      username.hashCode ^
      password.hashCode ^
      basePath.hashCode ^
      allowSelfSignedCert.hashCode;

  @override
  String toString() =>
      'WebDavConfig(serverUrl: $serverUrl, username: $username, basePath: $basePath, allowSelfSignedCert: $allowSelfSignedCert)';
}
