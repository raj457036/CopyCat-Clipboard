import 'package:clipboard/base/domain/model/auth_user/auth_user.dart';
import 'package:clipboard/common/failure.dart';

abstract class AuthRepository {
  FailureOr<(String?, AuthUser?)> validateAuthCode(String code);
  FailureOr<void> logout();
  FailureOr<AuthUser> updateUserInfo(Map<String, dynamic> data);
  String? get userId;
  AuthUser? get currentUser;
  String? get accessToken;
}
