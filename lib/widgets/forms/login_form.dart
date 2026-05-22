import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/auth_user/auth_user.dart';
import 'package:clipboard/base/domain/model/localization.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart' as su_auth;

class CopyCatClipboardLoginForm extends StatelessWidget {
  final Function(AuthUser user, String accessToken) onSignUpComplete;
  final Function(AuthUser user, String accessToken) onSignInComplete;
  final Function(Object? error) onError;
  final AuthUserFormLocalization localization;

  const CopyCatClipboardLoginForm({
    super.key,
    required this.onSignUpComplete,
    required this.onSignInComplete,
    required this.onError,
    required this.localization,
  });

  @override
  Widget build(BuildContext context) {
    final decorationTheme = context.theme.inputDecorationTheme.copyWith(
      border: const OutlineInputBorder(borderRadius: radius16),
      isDense: context.isMobile,
    );

    return ElevatedButtonTheme(
      data: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(padding16),
          backgroundColor: context.colors.primary,
          foregroundColor: context.colors.onPrimary,
          enabledMouseCursor: SystemMouseCursors.click,
        ),
      ),
      child: InputDecorationTheme(
        data: decorationTheme,
        child: su_auth.SupaEmailAuth(
          autofocus: true,
          resetPasswordRedirectTo:
              "https://clipboard-419514.web.app/reset-password",
          onSignUpComplete: (su_auth.AuthResponse response) {
            if (response.session != null && response.user != null) {
              final user = response.user!.toAuthUser();
              onSignUpComplete(user, response.session!.accessToken);
            }
          },
          onSignInComplete: (su_auth.AuthResponse response) {
            if (response.session != null && response.user != null) {
              final user = response.user!.toAuthUser();
              onSignInComplete(user, response.session!.accessToken);
            }
          },
          onError: (error) {
            onError(error);
          },
          metadataFields: [
            su_auth.MetaDataField(
              label: localization.displayNameLabel,
              key: "display_name",
              prefixIcon: const Icon(Icons.person_rounded),
              validator: ValidationBuilder().minLength(2).build(),
            ),
          ],
          localization: su_auth.SupaEmailAuthLocalization(
            enterEmail: localization.enterEmail,
            validEmailError: localization.validEmailError,
            enterPassword: localization.enterPassword,
            passwordLengthError: localization.passwordLengthError,
            signIn: localization.signIn,
            signUp: localization.signUp,
            forgotPassword: localization.forgotPassword,
            dontHaveAccount: localization.dontHaveAccount,
            haveAccount: localization.haveAccount,
            sendPasswordReset: localization.sendPasswordReset,
            passwordResetSent: localization.passwordResetSent,
            backToSignIn: localization.backToSignIn,
            unexpectedError: localization.unexpectedError,
          ),
        ),
      ),
    );
  }
}
