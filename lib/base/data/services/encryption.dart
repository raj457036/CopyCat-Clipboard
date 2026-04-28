import 'dart:math' show Random;

import 'package:encrypt/encrypt.dart';

export 'package:clipboard/base/background/encryption_worker.dart';

String generateSecurePassword(int length) {
  const String upperCaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const String lowerCaseLetters = 'abcdefghijklmnopqrstuvwxyz';
  const String digits = '0123456789';
  const String specialCharacters = '!@#\$%^&*()-_=+[]{}|;:,.<>?';

  final Random random = Random.secure();

  // Ensure the password contains at least one character from each set
  List<String> passwordChars = [
    upperCaseLetters[random.nextInt(upperCaseLetters.length)],
    lowerCaseLetters[random.nextInt(lowerCaseLetters.length)],
    digits[random.nextInt(digits.length)],
    specialCharacters[random.nextInt(specialCharacters.length)],
  ];

  // Fill the remaining length of the password with random characters from all sets
  String allChars =
      upperCaseLetters + lowerCaseLetters + digits + specialCharacters;
  for (int i = 4; i < length; i++) {
    passwordChars.add(allChars[random.nextInt(allChars.length)]);
  }

  // Shuffle the password characters to ensure randomness
  passwordChars.shuffle(random);

  // Convert the list of characters to a string and return
  return passwordChars.join();
}

class EncryptionSecret {
  final String secret;
  final String init;
  late final Key key;
  late final IV iv;

  EncryptionSecret(this.secret, this.init) {
    key = Key.fromUtf8(secret);
    iv = IV.fromBase64(init);
  }

  factory EncryptionSecret.generate() {
    const secretKeyLength = 32;
    const ivLength = 16;
    final secret = generateSecurePassword(secretKeyLength);
    final iv = IV.fromLength(ivLength);
    return EncryptionSecret(secret, iv.base64);
  }

  String get serialized => "$secret-+-$init";

  factory EncryptionSecret.deserilize(String serialized) {
    final List<String> split = serialized.split("-+-");

    if (split.length != 2) {
      throw Exception("Invalid serialized secret");
    }

    return EncryptionSecret(split[0], split[1]);
  }
}

class EncryptionManager {
  late final IV _iv;
  late final Encrypter encrypter;

  EncryptionManager(EncryptionSecret secret) {
    _iv = secret.iv;
    encrypter = Encrypter(AES(secret.key, mode: AESMode.cfb64));
  }

  String encrypt(String content, [String? customIV]) {
    final iv = customIV != null ? IV.fromBase64(customIV) : _iv;
    return encrypter.encrypt(content, iv: iv).base64;
  }

  String decrypt(String content, [String? customIV]) {
    final iv = customIV != null ? IV.fromBase64(customIV) : _iv;
    return encrypter.decrypt64(content, iv: iv);
  }
}
