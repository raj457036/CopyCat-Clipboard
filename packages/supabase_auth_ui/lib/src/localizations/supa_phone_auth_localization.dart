class SupaPhoneAuthLocalization {
  final String enterPhoneNumber;
  final String validPhoneNumberError;
  final String enterPassword;
  final String passwordLengthError;
  final String signIn;
  final String signUp;
  final String unexpectedError;

  const SupaPhoneAuthLocalization({
    this.enterPhoneNumber = 'Enter your phone number',
    this.validPhoneNumberError = 'Please enter a valid phone number',
    this.enterPassword = 'Enter your password',
    this.passwordLengthError =
        'Please enter a password that is at least 6 characters long',
    this.signIn = 'Sign In',
    this.signUp = 'Sign Up',
    this.unexpectedError = 'An unexpected error occurred',
  });
}
