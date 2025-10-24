import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';

@freezed
class AuthUser with _$AuthUser {
  factory AuthUser({
    required String userId,
    required String email,
    String? enc2KeyId,
    String? enc1,
    String? displayName,
  }) = _AuthUser;
}
