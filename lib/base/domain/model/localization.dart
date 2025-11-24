class AuthUserFormLocalization {
  final String displayNameLabel;
  final String enterEmail;
  final String validEmailError;
  final String enterPassword;
  final String passwordLengthError;
  final String signIn;
  final String signUp;
  final String forgotPassword;
  final String dontHaveAccount;
  final String haveAccount;
  final String sendPasswordReset;
  final String passwordResetSent;
  final String backToSignIn;
  final String unexpectedError;

  AuthUserFormLocalization({
    required this.displayNameLabel,
    required this.enterEmail,
    required this.validEmailError,
    required this.enterPassword,
    required this.passwordLengthError,
    required this.signIn,
    required this.signUp,
    required this.forgotPassword,
    required this.dontHaveAccount,
    required this.haveAccount,
    required this.sendPasswordReset,
    required this.passwordResetSent,
    required this.backToSignIn,
    required this.unexpectedError,
  });
}

class AuthUserResetPasswordFormLocalization {
  final String enterPassword;
  final String passwordLengthError;
  final String updatePassword;
  final String unexpectedError;
  final String passwordResetSent;

  AuthUserResetPasswordFormLocalization({
    required this.enterPassword,
    required this.passwordLengthError,
    required this.updatePassword,
    required this.unexpectedError,
    required this.passwordResetSent,
  });
}
