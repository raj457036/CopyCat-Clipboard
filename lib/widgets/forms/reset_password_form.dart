import 'package:clipboard/base/domain/model/auth_user/auth_user.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart' as sb;

class ResetPasswordForm extends StatelessWidget {
  final String accessToken;
  final Function(AuthUser user) onSuccess;
  final Function(Object? error) onError;

  const ResetPasswordForm({
    super.key,
    required this.accessToken,
    required this.onSuccess,
    required this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return sb.SupaResetPassword(
      accessToken: accessToken,
      onSuccess: (sb.UserResponse response) {
        onSuccess(response.user!.toAuthUser());
      },
      onError: (error) {
        onError(error);
      },
    );
  }
}
