import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class E2EETransferSecret {
  final String enc2Id;
  final String enc2;

  const E2EETransferSecret({required this.enc2Id, required this.enc2});
}

class E2EEQrTransferService {
  static const int _version = 1;

  const E2EEQrTransferService._();

  static String generatePasscode() {
    return (100000 + Random.secure().nextInt(900000)).toString();
  }

  static Future<bool> hasCamera() async {
    final supportedLenses = await MobileScannerPlatform.instance
        .getSupportedLenses();
    return supportedLenses.isNotEmpty;
  }

  static String encodeKeyFile({required String enc2Id, required String enc2}) {
    return jsonEncode({'enc2Id': enc2Id, 'enc2': enc2});
  }

  static E2EETransferSecret? decodeKeyFile(String content) {
    try {
      final json = jsonDecode(content);
      if (json is! Map<String, dynamic>) return null;

      final enc2Id = json['enc2Id'];
      final enc2 = json['enc2'];
      if (enc2Id is! String || enc2 is! String) return null;

      return E2EETransferSecret(enc2Id: enc2Id, enc2: enc2);
    } catch (_) {
      return null;
    }
  }

  static String buildEncryptedPayload({
    required String enc2Id,
    required String enc2,
    required String passcode,
    int? timestampMs,
  }) {
    final ts = timestampMs ?? DateTime.now().millisecondsSinceEpoch;
    final key = _deriveKey(passcode);
    final iv = IV.fromSecureRandom(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.gcm));

    final plaintext = jsonEncode({'enc2Id': enc2Id, 'enc2': enc2});
    final encrypted = encrypter.encrypt(plaintext, iv: iv);

    return jsonEncode({
      'v': _version,
      'ts': ts,
      'iv': iv.base64,
      'ct': encrypted.base64,
    });
  }

  static E2EETransferSecret? decryptPayload({
    required String payload,
    required String passcode,
    Duration maxAge = const Duration(minutes: 5),
  }) {
    try {
      final envelope = jsonDecode(payload);
      if (envelope is! Map<String, dynamic>) return null;

      final version = envelope['v'];
      final ts = envelope['ts'];
      final ivBase64 = envelope['iv'];
      final cipherTextBase64 = envelope['ct'];

      if (version != _version ||
          ts is! int ||
          ivBase64 is! String ||
          cipherTextBase64 is! String) {
        return null;
      }

      final ageMs = DateTime.now().millisecondsSinceEpoch - ts;
      if (ageMs < 0 || ageMs > maxAge.inMilliseconds) {
        return null;
      }

      final key = _deriveKey(passcode);
      final iv = IV.fromBase64(ivBase64);
      final encrypted = Encrypted.fromBase64(cipherTextBase64);
      final encrypter = Encrypter(AES(key, mode: AESMode.gcm));
      final plaintext = encrypter.decrypt(encrypted, iv: iv);

      final secret = jsonDecode(plaintext);
      if (secret is! Map<String, dynamic>) return null;

      final enc2Id = secret['enc2Id'];
      final enc2 = secret['enc2'];
      if (enc2Id is! String || enc2 is! String) return null;

      return E2EETransferSecret(enc2Id: enc2Id, enc2: enc2);
    } catch (_) {
      return null;
    }
  }

  static Key _deriveKey(String passcode) {
    final hash = sha256.convert(utf8.encode(passcode)).bytes;
    return Key(Uint8List.fromList(hash));
  }
}
