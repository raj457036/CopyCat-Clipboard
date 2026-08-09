class SupaVerifyPhoneLocalization {
  final String enterOneTimeCode;
  final String enterCodeSent;
  final String verifyPhone;
  final String unexpectedErrorOccurred;

  const SupaVerifyPhoneLocalization({
    this.enterOneTimeCode = 'Please enter the one time code sent',
    this.enterCodeSent = 'Enter the code sent',
    this.verifyPhone = 'Verify Phone',
    this.unexpectedErrorOccurred = 'Unexpected error has occurred',
  });
}
