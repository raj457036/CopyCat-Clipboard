import 'package:clipboard/base/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class SupabaseAuthLocalizations extends SupabaseAuthUILocalizations {
  final String _enterEmail;
  final String _validEmailError;
  final String _enterPassword;
  final String _passwordLengthError;
  final String _signIn;
  final String _signUp;
  final String _forgotPassword;
  final String _dontHaveAccount;
  final String _haveAccount;
  final String _sendPasswordReset;
  final String _passwordResetSent;
  final String _backToSignIn;
  final String _unexpectedError;
  final String _changePassword;
  final String _checkYourEmail;
  final String _confirmPassword;
  final String _confirmPasswordError;
  final String _continueWithMagicLink;
  final String _enterCodeSent;
  final String _enterNewPassword;
  final String _enterOneTimeCode;
  final String _enterOtpCode;
  final String _enterPhoneNumber;
  final String _otpCodeError;
  final String _otpDisabledError;
  final String _passwordChangedSuccess;
  final String _requiredFieldError;
  final String _successSignInMessage;
  final String _updatePassword;
  final String _validPhoneNumberError;
  final String _verifyPhone;
  final String Function(String provider) _continueWithProvider;

  SupabaseAuthLocalizations(
    super.locale, {
    required String enterEmail,
    required String validEmailError,
    required String enterPassword,
    required String passwordLengthError,
    required String signIn,
    required String signUp,
    required String forgotPassword,
    required String dontHaveAccount,
    required String haveAccount,
    required String sendPasswordReset,
    required String passwordResetSent,
    required String backToSignIn,
    required String unexpectedError,
    required String changePassword,
    required String checkYourEmail,
    required String confirmPassword,
    required String confirmPasswordError,
    required String continueWithMagicLink,
    required String enterCodeSent,
    required String enterNewPassword,
    required String enterOneTimeCode,
    required String enterOtpCode,
    required String enterPhoneNumber,
    required String otpCodeError,
    required String otpDisabledError,
    required String passwordChangedSuccess,
    required String requiredFieldError,
    required String successSignInMessage,
    required String updatePassword,
    required String validPhoneNumberError,
    required String verifyPhone,
    required String Function(String provider) continueWithProvider,
  }) : _enterEmail = enterEmail,
       _validEmailError = validEmailError,
       _enterPassword = enterPassword,
       _passwordLengthError = passwordLengthError,
       _signIn = signIn,
       _signUp = signUp,
       _forgotPassword = forgotPassword,
       _dontHaveAccount = dontHaveAccount,
       _haveAccount = haveAccount,
       _sendPasswordReset = sendPasswordReset,
       _passwordResetSent = passwordResetSent,
       _backToSignIn = backToSignIn,
       _unexpectedError = unexpectedError,
       _changePassword = changePassword,
       _checkYourEmail = checkYourEmail,
       _confirmPassword = confirmPassword,
       _confirmPasswordError = confirmPasswordError,
       _continueWithMagicLink = continueWithMagicLink,
       _enterCodeSent = enterCodeSent,
       _enterNewPassword = enterNewPassword,
       _enterOneTimeCode = enterOneTimeCode,
       _enterOtpCode = enterOtpCode,
       _enterPhoneNumber = enterPhoneNumber,
       _otpCodeError = otpCodeError,
       _otpDisabledError = otpDisabledError,
       _passwordChangedSuccess = passwordChangedSuccess,
       _requiredFieldError = requiredFieldError,
       _successSignInMessage = successSignInMessage,
       _updatePassword = updatePassword,
       _validPhoneNumberError = validPhoneNumberError,
       _verifyPhone = verifyPhone,
       _continueWithProvider = continueWithProvider;

  @override
  String get signIn => _signIn;

  @override
  String get signUp => _signUp;

  @override
  String get forgotPassword => _forgotPassword;

  @override
  String get dontHaveAccount => _dontHaveAccount;

  @override
  String get haveAccount => _haveAccount;

  @override
  String get sendPasswordReset => _sendPasswordReset;

  @override
  String get passwordResetSent => _passwordResetSent;

  @override
  String get backToSignIn => _backToSignIn;

  @override
  String get unexpectedError => _unexpectedError;

  @override
  String get enterEmail => _enterEmail;

  @override
  String get validEmailError => _validEmailError;

  @override
  String get enterPassword => _enterPassword;

  @override
  String get passwordLengthError => _passwordLengthError;

  @override
  String get changePassword => _changePassword;

  @override
  String get checkYourEmail => _checkYourEmail;

  @override
  String get confirmPassword => _confirmPassword;

  @override
  String get confirmPasswordError => _confirmPasswordError;

  @override
  String get continueWithMagicLink => _continueWithMagicLink;

  @override
  String continueWithProvider(String provider) {
    return _continueWithProvider(provider);
  }

  @override
  String get enterCodeSent => _enterCodeSent;

  @override
  String get enterNewPassword => _enterNewPassword;

  @override
  String get enterOneTimeCode => _enterOneTimeCode;

  @override
  String get enterOtpCode => _enterOtpCode;

  @override
  String get enterPhoneNumber => _enterPhoneNumber;

  @override
  String get otpCodeError => _otpCodeError;

  @override
  String get otpDisabledError => _otpDisabledError;

  @override
  String get passwordChangedSuccess => _passwordChangedSuccess;

  @override
  String get requiredFieldError => _requiredFieldError;

  @override
  String get successSignInMessage => _successSignInMessage;

  @override
  String get updatePassword => _updatePassword;

  @override
  String get validPhoneNumberError => _validPhoneNumberError;

  @override
  String get verifyPhone => _verifyPhone;
}

class SupabaseAuthLocalizationsDelegate
    extends LocalizationsDelegate<SupabaseAuthUILocalizations> {
  const SupabaseAuthLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.delegate.isSupported(locale);

  @override
  Future<SupabaseAuthUILocalizations> load(Locale locale) async {
    final sbl = lookupSupabaseAuthUILocalizations(const Locale('en'));
    final localizations = await lookupAppLocalizations(locale);
    return SupabaseAuthLocalizations(
      locale.languageCode,
      enterEmail: localizations.login__form__input__email,
      validEmailError: localizations.login__form__input__error_email,
      enterPassword: localizations.login__form__input__password,
      passwordLengthError:
          localizations.login__form__input__error_password_length,
      signIn: localizations.login__form__button__signin,
      signUp: localizations.login__form__button__signup,
      forgotPassword: localizations.login__form__button__forgot_password,
      dontHaveAccount: localizations.login__form__text__signup,
      haveAccount: localizations.login__form__text__old_user,
      sendPasswordReset: localizations.login__form__text__reset_password,
      passwordResetSent: localizations.login__form__text__reset_ack,
      backToSignIn: localizations.login__form__button__back,
      unexpectedError: localizations.app__unknown_error,
      continueWithMagicLink: sbl.continueWithMagicLink,
      continueWithProvider: (provider) => sbl.continueWithProvider(provider),
      verifyPhone: sbl.verifyPhone,
      changePassword: sbl.changePassword,
      checkYourEmail: sbl.checkYourEmail,
      confirmPassword: sbl.confirmPassword,
      confirmPasswordError: sbl.confirmPasswordError,
      enterCodeSent: sbl.enterCodeSent,
      enterNewPassword: sbl.enterNewPassword,
      enterOneTimeCode: sbl.enterOneTimeCode,
      enterOtpCode: sbl.enterOtpCode,
      enterPhoneNumber: sbl.enterPhoneNumber,
      otpCodeError: sbl.otpCodeError,
      otpDisabledError: sbl.otpDisabledError,
      passwordChangedSuccess: sbl.passwordChangedSuccess,
      requiredFieldError: sbl.requiredFieldError,
      successSignInMessage: sbl.successSignInMessage,
      validPhoneNumberError: sbl.validPhoneNumberError,
      updatePassword: localizations.login__form__button__update_password,
    );
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}
