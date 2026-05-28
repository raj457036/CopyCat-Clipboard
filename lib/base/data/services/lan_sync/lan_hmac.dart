import 'dart:convert';
import 'dart:io' as io;

import 'package:crypto/crypto.dart';

import 'lan_sync_config.dart';

/// HMAC-SHA256 helpers for authenticating LAN sync payloads.
///
/// The HMAC key is [LanSyncConfig.userId]. Verification delegates to
/// [Digest.==], which performs constant-time byte comparison.
class LanHmac {
  final LanSyncConfig _config;

  const LanHmac(this._config);

  // MARK: - Compute

  /// Returns HMAC-SHA256(body, userId) as a hex string.
  String compute(List<int> body) {
    final key = utf8.encode(_config.userId);
    return Hmac(sha256, key).convert(body).toString();
  }

  /// Returns HMAC-SHA256 over a file's byte stream as a hex string.
  Future<String> computeForFile(io.File file) async {
    final digests = <Digest>[];
    final sink = Hmac(sha256, utf8.encode(_config.userId))
        .startChunkedConversion(
          ChunkedConversionSink.withCallback(digests.addAll),
        );
    await for (final chunk in file.openRead()) {
      sink.add(chunk);
    }
    sink.close();
    return digests.single.toString();
  }

  // MARK: - Verify

  /// Verify [expectedHex] against the computed HMAC for [body].
  ///
  /// Returns false when [userId] is empty or [expectedHex] is malformed.
  bool verify(List<int> body, String expectedHex) {
    if (_config.userId.isEmpty) return false;
    final expected = _parseHex(expectedHex);
    if (expected == null) return false;
    final key = utf8.encode(_config.userId);
    return Hmac(sha256, key).convert(body) == expected;
  }

  /// Verify a pre-computed streaming [actual] digest against [expectedHex].
  ///
  /// Returns false when [userId] is empty or [expectedHex] is malformed.
  bool verifyDigest(Digest actual, String expectedHex) {
    if (_config.userId.isEmpty) return false;
    final expected = _parseHex(expectedHex);
    if (expected == null) return false;
    return actual == expected;
  }

  // MARK: - Private

  /// Decode a 64-char HMAC-SHA256 hex string. Returns null for malformed input.
  static Digest? _parseHex(String hex) {
    if (hex.length != 64) return null;
    try {
      final bytes = [
        for (var i = 0; i < 64; i += 2)
          int.parse(hex.substring(i, i + 2), radix: 16),
      ];
      return Digest(bytes);
    } on FormatException {
      return null;
    }
  }
}
