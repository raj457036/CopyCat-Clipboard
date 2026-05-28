import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clipboard/base/data/services/lan_sync/lan_hmac.dart';
import 'package:clipboard/base/data/services/lan_sync/lan_sync_config.dart';

void main() {
  group('LanHmac', () {
    late LanSyncConfig config;
    late LanHmac hmac;

    setUp(() {
      config = LanSyncConfig()..userId = 'test-user-secret';
      hmac = LanHmac(config);
    });

    // MARK: - compute

    test('compute returns non-empty hex string', () {
      final result = hmac.compute(utf8.encode('hello'));
      expect(result, isNotEmpty);
      expect(result, matches(RegExp(r'^[0-9a-f]+$')));
    });

    test('compute is deterministic for same input', () {
      final body = utf8.encode('clipboard content');
      expect(hmac.compute(body), equals(hmac.compute(body)));
    });

    test('compute differs for different userId', () {
      final body = utf8.encode('hello');
      final mac1 = hmac.compute(body);
      config.userId = 'different-secret';
      final mac2 = hmac.compute(body);
      expect(mac1, isNot(equals(mac2)));
    });

    test('compute differs for different body', () {
      final mac1 = hmac.compute(utf8.encode('payload-A'));
      final mac2 = hmac.compute(utf8.encode('payload-B'));
      expect(mac1, isNot(equals(mac2)));
    });

    test('compute on empty body still produces a hash', () {
      final result = hmac.compute([]);
      expect(result, isNotEmpty);
    });

    // MARK: - verify

    test('verify returns true for matching body and HMAC', () {
      final body = utf8.encode('some clip');
      final mac = hmac.compute(body);
      expect(hmac.verify(body, mac), isTrue);
    });

    test('verify returns false for wrong HMAC', () {
      final body = utf8.encode('some clip');
      expect(hmac.verify(body, 'deadbeef' * 8), isFalse);
    });

    test('verify returns false when userId is empty', () {
      config.userId = '';
      final body = utf8.encode('some clip');
      // Even if we somehow have the right hash, empty userId short-circuits.
      final mac = LanHmac(LanSyncConfig()..userId = 'secret').compute(body);
      expect(hmac.verify(body, mac), isFalse);
    });

    test('verify returns false when body is altered', () {
      final body = utf8.encode('original');
      final mac = hmac.compute(body);
      final tampered = utf8.encode('tampered');
      expect(hmac.verify(tampered, mac), isFalse);
    });

    test('verify returns false for malformed hex (wrong length)', () {
      final body = utf8.encode('some clip');
      expect(hmac.verify(body, 'short'), isFalse);
      expect(hmac.verify(body, ''), isFalse);
    });

    test('verify returns false for malformed hex (non-hex chars)', () {
      final body = utf8.encode('some clip');
      // 64 chars but invalid hex
      expect(hmac.verify(body, 'z' * 64), isFalse);
    });

    // MARK: - verifyDigest

    test('verifyDigest returns true for matching digest and hex', () {
      final body = utf8.encode('streaming payload');
      final key = utf8.encode(config.userId);
      final digest = Hmac(sha256, key).convert(body);
      final mac = hmac.compute(body);
      expect(hmac.verifyDigest(digest, mac), isTrue);
    });

    test('verifyDigest returns false for mismatched digest', () {
      final body = utf8.encode('streaming payload');
      final wrongBody = utf8.encode('tampered payload');
      final key = utf8.encode(config.userId);
      final digest = Hmac(sha256, key).convert(wrongBody);
      final mac = hmac.compute(body);
      expect(hmac.verifyDigest(digest, mac), isFalse);
    });

    test('verifyDigest returns false for malformed hex', () {
      final body = utf8.encode('x');
      final key = utf8.encode(config.userId);
      final digest = Hmac(sha256, key).convert(body);
      expect(hmac.verifyDigest(digest, 'short'), isFalse);
      expect(hmac.verifyDigest(digest, 'z' * 64), isFalse);
    });

    test('verifyDigest returns false when userId is empty', () {
      final body = utf8.encode('x');
      final key = utf8.encode('secret');
      final digest = Hmac(sha256, key).convert(body);
      final mac = LanHmac(LanSyncConfig()..userId = 'secret').compute(body);
      config.userId = '';
      expect(hmac.verifyDigest(digest, mac), isFalse);
    });
  });
}
