import 'package:clipboard/base/domain/model/auth_user/auth_user.dart';
import 'package:clipboard/common/failure.dart';

enum AuthSessionChange { updated, signedOut }

abstract class AuthRepository {
  Stream<AuthSessionChange> get authStateChanges;
  FailureOr<void> refreshSession();
  FailureOr<(String?, AuthUser?)> validateAuthCode(String code);
  FailureOr<void> logout();
  FailureOr<AuthUser> updateUserInfo(Map<String, dynamic> data);
  String? get userId;
  AuthUser? get currentUser;
  String? get accessToken;
  bool get needsSessionRefresh;
}
