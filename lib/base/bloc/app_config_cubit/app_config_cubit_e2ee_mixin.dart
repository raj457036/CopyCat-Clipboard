part of 'app_config_cubit.dart';

mixin AppConfigE2EEMixin on Cubit<AppConfigState> {
  static const String _enc2SecureStorageKey = 'copycat.enc2';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  bool _hasStoredE2EEKey = false;

  AppConfigRepository get repo;

  bool get isE2EESetupDone => _hasStoredE2EEKey;

  Future<void> _migrateLegacyEnc2ToSecureStorage(AppConfig config) async {
    try {
      final secureEnc2 = await _readStoredE2EEKey();
      final legacyEnc2 = config.enc2;

      if (legacyEnc2 == null) return;

      if (secureEnc2 == null) {
        await _writeStoredE2EEKey(legacyEnc2);
        logger.i('Migrated legacy enc2 key to secure storage.');
      }

      final sanitizedConfig = config.copyWith(enc2: null);
      emit(state.copyWith(config: sanitizedConfig));
      await repo.update(sanitizedConfig);
    } catch (e) {
      logger.e('Failed to migrate legacy enc2 key: $e');
    }
  }

  Future<void> _refreshE2EEKeyPresence() async {
    _hasStoredE2EEKey = (await _readStoredE2EEKey()) != null;
  }

  Future<String?> _readStoredE2EEKey() {
    return _secureStorage.read(key: _enc2SecureStorageKey);
  }

  Future<void> _writeStoredE2EEKey(String value) {
    return _secureStorage.write(key: _enc2SecureStorageKey, value: value);
  }

  Future<void> _clearStoredE2EEKey() {
    return _secureStorage.delete(key: _enc2SecureStorageKey);
  }

  Future<String?> getE2EEKey() {
    return _readStoredE2EEKey();
  }

  Future<String?> decryptEnc2(String? enc1) async {
    if (enc1 == null) return null;
    final enc2 = await _readStoredE2EEKey();
    if (enc2 == null) return null;

    try {
      final secret = EncryptionSecret.deserilize(enc2);
      final encMngr = EncryptionManager(secret);
      return encMngr.decrypt(enc1);
    } catch (e) {
      logger.e('Failed to decrypt enc1 using stored enc2 key: $e');
      return null;
    }
  }

  Future<void> setE2EEKey(String? key) async {
    if (key == null) {
      await _clearStoredE2EEKey();
      _hasStoredE2EEKey = false;
    } else {
      await _writeStoredE2EEKey(key);
      _hasStoredE2EEKey = true;
    }

    // Force-clear legacy plaintext persistence in AppConfig.
    if (state.config.enc2 != null) {
      final newConfig = state.config.copyWith(enc2: null);
      emit(state.copyWith(config: newConfig));
      await repo.update(newConfig);
    } else {
      emit(state.copyWith());
    }
  }
}
