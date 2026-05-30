import 'package:injectable/injectable.dart';
import 'package:local_auth/local_auth.dart';

@lazySingleton
class LocalAuthService {
  final _auth = LocalAuthentication();

  DateTime? _unlockedAt;
  int _timeoutMinutes = 1;

  /// True when the user has authenticated within the current timeout window.
  bool get isUnlocked {
    if (_unlockedAt == null) return false;
    // timeout == 0 means "lock as soon as the app backgrounds" — the session
    // stays valid until onAppBackground() clears it, so return true here.
    if (_timeoutMinutes == 0) return true;
    final elapsed = DateTime.now().difference(_unlockedAt!);
    return elapsed < Duration(minutes: _timeoutMinutes);
  }

  /// Returns true when the device has any authentication method available
  /// (biometric or device credential). Returns false on unsupported platforms.
  Future<bool> isAvailable() async {
    try {
      return await _auth.isDeviceSupported();
    } on LocalAuthException {
      return false;
    } catch (_) {
      return false; // Linux or other unsupported platform
    }
  }

  /// Prompt the user to authenticate. Returns [true] if authentication
  /// succeeded or if no auth hardware is available (allow-through).
  Future<bool> authorize({String? reason}) async {
    try {
      final supported = await _auth.isDeviceSupported();
      if (!supported) return true;
      // biometricOnly: true = Touch ID / Face ID only — no system password
      // dialog, giving a seamless in-window experience on macOS/Windows.
      return await _auth.authenticate(
        localizedReason: reason ?? 'Authenticate to access CopyCat Clipboard',
        biometricOnly: true,
      );
    } on LocalAuthException catch (e) {
      switch (e.code) {
        case LocalAuthExceptionCode.temporaryLockout:
        case LocalAuthExceptionCode.biometricLockout:
          return false;
        case LocalAuthExceptionCode.noBiometricsEnrolled:
        case LocalAuthExceptionCode.noBiometricHardware:
        case LocalAuthExceptionCode.userRequestedFallback:
        case LocalAuthExceptionCode.noCredentialsSet:
          // No biometrics available — fall back to device credentials
          // (password/PIN) so the lock still protects the user.
          return _authorizeWithCredentials(reason);
        default:
          return true;
      }
    } catch (_) {
      return true; // Unsupported platform (e.g. Linux)
    }
  }

  Future<bool> _authorizeWithCredentials(String? reason) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason ?? 'Authenticate to access CopyCat Clipboard',
      );
    } on LocalAuthException catch (e) {
      if (e.code == LocalAuthExceptionCode.temporaryLockout ||
          e.code == LocalAuthExceptionCode.biometricLockout) {
        return false;
      }
      return true;
    } catch (_) {
      return true;
    }
  }

  /// Called after a successful app-level unlock. Starts the grace-period
  /// window during which [isUnlocked] returns true.
  void onUnlocked({required int timeoutMinutes}) {
    _timeoutMinutes = timeoutMinutes;
    _unlockedAt = DateTime.now();
  }

  /// Invalidates the current unlock session.
  void lock() {
    _unlockedAt = null;
  }
}
