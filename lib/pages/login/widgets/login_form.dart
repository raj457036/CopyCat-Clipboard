import 'package:clipboard/pages/login/widgets/local_signin_button.dart';
import 'package:clipboard/widgets/locale_dropdown_button.dart';
import 'package:copycat_base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:copycat_base/bloc/auth_cubit/auth_cubit.dart';
import 'package:copycat_base/common/failure.dart';
import 'package:copycat_base/constants/numbers/breakpoints.dart';
import 'package:copycat_base/constants/strings/asset_constants.dart';
import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/domain/model/localization.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:copycat_base/utils/snackbar.dart';
import 'package:copycat_pro/widgets/forms/login_form.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  Future<void> launchPrivacyPolicyPage() async {
    await launchUrl(
      Uri.parse(
        const String.fromEnvironment("PRIVACY_POLICY_URL"),
      ),
    );
  }

  Future<void> launchTermsOfServicePage() async {
    await launchUrl(
      Uri.parse(
        const String.fromEnvironment("TERMS_CONDITIONS_URL"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;
    final mq = context.mq;
    final isMobile = Breakpoints.isMobile(mq.size.width);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (!isMobile)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image(
              image: AssetImage(AssetConstants.catPeekUpSideDownImage),
              height: 140,
            ),
          ),
        Positioned.fill(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: padding16,
              right: padding16,
              top: 180,
            ),
            child: SizedBox(
              // height: mq.size.height,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // const Spacer(),
                  Text(
                    context.locale.app__name,
                    style: textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  height12,
                  Text(
                    context.locale.app__slogan,
                    style: textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  height24,
                  const LocalSigninButton(),
                  height10,
                  Text(
                    "· · ─────── ·𖥸· ─────── · ·",
                    style: textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  height10,
                  SizedBox(
                    width: 350,
                    // height: 390,
                    child: CopyCatClipboardLoginForm(
                      onSignUpComplete: (user, accessToken) async {
                        final appConfigCubit = context.read<AppConfigCubit>();
                        final authCubit = context.read<AuthCubit>();
                        await appConfigCubit.changeOnBoardStatus(false);
                        authCubit.authenticated(user, accessToken);
                        authCubit.analyticsRepo.logSignup(
                          signUpMethod: "Email",
                          parameters: {
                            "userId": user.userId,
                            "email": user.email,
                          },
                        );
                      },
                      onSignInComplete: (user, accessToken) async {
                        final appConfigCubit = context.read<AppConfigCubit>();
                        final authCubit = context.read<AuthCubit>();
                        await appConfigCubit.changeOnBoardStatus(false);
                        authCubit.authenticated(user, accessToken);
                        authCubit.analyticsRepo.logSignin(
                          loginMethod: "Email",
                          parameters: {
                            "userId": user.userId,
                            "email": user.email,
                          },
                        );
                      },
                      onError: (error) {
                        final cubit = context.read<AuthCubit>();
                        final failure = Failure.fromException(error);
                        cubit.unauthenticated(failure);
                        showFailureSnackbar(failure);
                      },
                      localization: AuthUserFormLocalization(
                        displayNameLabel:
                            context.locale.login__form__input__name,
                        enterEmail: context.locale.login__form__input__email,
                        validEmailError:
                            context.locale.login__form__input__error_email,
                        enterPassword:
                            context.locale.login__form__input__password,
                        passwordLengthError: context
                            .locale.login__form__input__error_password_length,
                        signIn: context.locale.login__form__button__signin,
                        signUp: context.locale.login__form__button__signup,
                        forgotPassword:
                            context.locale.login__form__button__forgot_password,
                        dontHaveAccount:
                            context.locale.login__form__text__signup,
                        haveAccount: context.locale.login__form__text__old_user,
                        sendPasswordReset:
                            context.locale.login__form__text__reset_password,
                        passwordResetSent:
                            context.locale.login__form__text__reset_ack,
                        backToSignIn: context.locale.login__form__button__back,
                        unexpectedError: context.locale.app__unknown_error,
                      ),
                    ),
                  ),

                  // const Spacer(),
                  const LocaleDropdownButton(),
                  height10,
                  Text.rich(
                    TextSpan(
                      text: context.locale.login__form__text_tnc_p1,
                      children: [
                        TextSpan(
                          text: context.locale.login__form__text_tnc_p2,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.primary,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = launchPrivacyPolicyPage,
                        ),
                        TextSpan(
                          text: context.locale.login__form__text_tnc_p3,
                        ),
                        TextSpan(
                          text: context.locale.login__form__text_tnc_p4,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.primary,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = launchTermsOfServicePage,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // height12,
                  if (isMobile)
                    const Image(
                      image: AssetImage(AssetConstants.catPeekUpSideDownImage),
                      height: 50,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
