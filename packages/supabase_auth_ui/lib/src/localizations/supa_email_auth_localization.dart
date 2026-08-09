class SupaEmailAuthLocalization {
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
  final String requiredFieldError;
  final String confirmPasswordError;
  final String confirmPassword;

  const SupaEmailAuthLocalization({
    this.enterEmail = 'Enter your email',
    this.validEmailError = 'Please enter a valid email address',
    this.enterPassword = 'Enter your password',
    this.passwordLengthError =
        'Please enter a password that is at least 6 characters long',
    this.signIn = 'Sign In',
    this.signUp = 'Sign Up',
    this.forgotPassword = 'Forgot your password?',
    this.dontHaveAccount = 'Don\'t have an account? Sign up',
    this.haveAccount = 'Already have an account? Sign in',
    this.sendPasswordReset = 'Send password reset email',
    this.passwordResetSent = 'Password reset email has been sent',
    this.backToSignIn = 'Back to sign in',
    this.unexpectedError = 'An unexpected error occurred',
    this.requiredFieldError = 'This field is required',
    this.confirmPasswordError = 'Passwords do not match',
    this.confirmPassword = 'Confirm Password',
  });
}
