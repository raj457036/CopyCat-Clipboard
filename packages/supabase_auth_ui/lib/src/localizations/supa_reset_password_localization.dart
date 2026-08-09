class SupaResetPasswordLocalization {
  final String enterPassword;
  final String passwordLengthError;
  final String updatePassword;
  final String unexpectedError;
  final String passwordResetSent;

  const SupaResetPasswordLocalization({
    this.enterPassword = 'Enter your password',
    this.passwordLengthError =
        'Please enter a password that is at least 6 characters long',
    this.updatePassword = 'Update Password',
    this.unexpectedError = 'An unexpected error occurred',
    this.passwordResetSent = 'Password reset email has been sent',
  });
}
