import 'dart:async';

import 'package:easy_worker/easy_worker.dart';
import 'package:encrypt/encrypt.dart';
import 'package:uuid/uuid.dart';

class EncryptionMode {
  static const String gcm = "GCM";
  static const String cfb = "CFB";
}

enum EncDecType { encrypt, decrypt, ping }

typedef EncryptionPayload = (
  String id,
  String content,
  String secret,
  String? customIV,
  String? mode,
  EncDecType action,
);

Encrypter? _aesCFB;
Encrypter? _aesGCM;
(String, String)? _secretAndInit;

void _encryptorEntryPoint(EncryptionPayload payload, Sender send) {
  final (id, content, secret, customIV, mode, action) = payload;
  if (id == "") return;

  IV? iv;
  if (id != "PING") {
    _secretAndInit ??= _deserializeSecret(secret);
    final (secretValue, initValue) = _secretAndInit!;
    iv = customIV != null ? IV.fromBase64(customIV) : IV.fromBase64(initValue);

    if (mode == EncryptionMode.gcm) {
      _aesGCM ??= Encrypter(AES(Key.fromUtf8(secretValue), mode: AESMode.gcm));
    } else {
      _aesCFB ??= Encrypter(
        AES(Key.fromUtf8(secretValue), mode: AESMode.cfb64),
      );
    }
  }

  final encrypter = mode == EncryptionMode.gcm ? _aesGCM : _aesCFB;

  switch (action) {
    case EncDecType.encrypt:
      try {
        final encrypted = encrypter!.encrypt(content, iv: iv);
        send((id, encrypted.base64));
      } catch (e) {
        send((id, EncryptionException(e.toString())));
      }

    case EncDecType.decrypt:
      try {
        final decrypted = encrypter!.decrypt64(content, iv: iv);
        send((id, decrypted));
      } catch (e) {
        send((id, DecryptionException(e.toString())));
      }

    case EncDecType.ping:
      send(("PING", "PONG"));
  }
}

(String, String) _deserializeSecret(String serialized) {
  final split = serialized.split("-+-");
  if (split.length != 2) {
    throw Exception("Invalid serialized secret");
  }
  return (split[0], split[1]);
}

class DecryptionException implements Exception {
  final String code;
  final String message;

  DecryptionException(this.message, {this.code = "not-active"});
}

class EncryptionException implements Exception {
  final String code;
  final String message;

  EncryptionException(this.message, {this.code = "not-active"});
}

class EncryptionWorker {
  Completer? _completer;
  bool _isRunning = false;
  bool _isStarting = false;
  bool _encryption = false;
  bool _decryption = true;
  bool _useNonce = false;

  String? secret;
  final Map<String, Completer> _tasks = <String, Completer>{};

  EasyWorker? _encryptor;

  StreamSubscription? _subscription;

  EncryptionWorker._();

  static final EncryptionWorker _instance = EncryptionWorker._();
  static EncryptionWorker get instance => _instance;

  bool get isRunning => _isRunning;
  bool get isStarting => _isStarting;
  bool get isEncryptionActive => _encryption;
  bool get isDecryptionActive => _decryption;
  bool get useNonce => _useNonce;

  String generateIV([int length = 16]) => IV.fromLength(length).base64;

  void dispose() {
    if (!_isRunning) return;
    _isRunning = false;
    _subscription?.cancel();
    _encryptor?.dispose();
    _encryptor = null;
    _completer = null;
  }

  void setEncryption(bool value) {
    _encryption = value;
  }

  void setDecryption(bool value) {
    _decryption = value;
  }

  void setUseNonce(bool value) {
    _useNonce = value;
  }

  Future<void> start(String secret) async {
    if (_completer != null || _isRunning) return;
    _completer = Completer();
    _isStarting = true;
    try {
      _isRunning = false;
      this.secret = secret;
      _subscription?.cancel();
      _encryptor = EasyWorker<(String, dynamic), EncryptionPayload>(
        Entrypoint(_encryptorEntryPoint),
        workerName: "Encryptor Worker",
      );

      await _encryptor?.waitUntilReady();
      _subscription = _encryptor?.onMessage((p0) {
        final (id, content) = p0;
        if (id == "PING" && content == "PONG") _completer?.complete();

        final taskCompleter = _tasks.remove(id);
        if (content is Exception) {
          taskCompleter?.completeError(content);
        } else {
          taskCompleter?.complete(content);
        }
      });
      await _encryptor?.send((
        "PING",
        "PING",
        "PING",
        null,
        null,
        EncDecType.ping,
      ));
      _isRunning = true;
    } finally {
      _isStarting = false;
    }
  }

  Future<void> waitUntilReady() async {
    if (_completer == null || (_completer?.isCompleted ?? true)) return;
    await _completer?.future;
  }

  Future<String> encrypt(
    String content, {
    String? customIV,
    String? mode,
  }) async {
    if (secret == null) {
      throw EncryptionException("Secret is not set", code: "invalid-secret");
    }
    if (_encryptor == null) {
      throw EncryptionException("Encryptor is not running");
    }
    if (!_encryption) {
      throw EncryptionException("Encryption is not active");
    }
    final id = const Uuid().v4();
    final completer = Completer();
    _tasks[id] = completer;
    await _encryptor?.send((
      id,
      content,
      secret!,
      customIV,
      mode,
      EncDecType.encrypt,
    ));

    final result = await completer.future;
    if (result is String) {
      return result;
    } else {
      throw result;
    }
  }

  Future<String> decrypt(
    String content, {
    String? customIV,
    String? mode,
  }) async {
    if (secret == null) {
      throw DecryptionException("Secret is not set", code: "invalid-secret");
    }
    if (_encryptor == null) {
      throw DecryptionException("Encryptor is not running");
    }
    if (!_decryption) {
      throw DecryptionException("Decryption is not active");
    }
    final id = const Uuid().v4();
    final completer = Completer();
    _tasks[id] = completer;
    await _encryptor?.send((
      id,
      content,
      secret!,
      customIV,
      mode,
      EncDecType.decrypt,
    ));

    final result = await completer.future;
    if (result is String) {
      return result;
    } else {
      throw result;
    }
  }
}
