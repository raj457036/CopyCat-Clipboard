import 'package:animate_do/animate_do.dart' show BounceInUp;
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/constants/strings/asset_constants.dart';
import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/data/services/notification_service.dart'
    show InAppNotificationService;
import 'package:clipboard/base/domain/model/auth_user/auth_user.dart';
import 'package:clipboard/base/domain/model/localization.dart';
import 'package:clipboard/base/domain/model/notification_message.dart'
    show NotificationMessage;
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/pages/login/widgets/local_signin_button.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/forms/login_form.dart';
import 'package:clipboard/widgets/locale_dropdown_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginForm extends StatelessWidget {
  final ScrollController? scrollController;
  final bool useInternalScrollView;

  const LoginForm({
    super.key,
    this.scrollController,
    this.useInternalScrollView = true,
  });

  static const _mobileHorizontalPadding = 20.0;
  static const _desktopHorizontalPadding = 28.0;
  static const _mobileVerticalPadding = 20.0;
  static const _desktopVerticalPadding = 24.0;

  Future<void> launchPrivacyPolicyPage() async {
    await launchUrl(Uri.parse(privacyPolicyUrl));
  }

  Future<void> launchTermsOfServicePage() async {
    await launchUrl(Uri.parse(termsConditionsUrl));
  }

  ThemeData _buildAuthTheme(BuildContext context) {
    final colors = context.colors;
    return context.theme.copyWith(
      inputDecorationTheme: context.theme.inputDecorationTheme.copyWith(
        filled: true,
        fillColor: colors.surfaceContainerHighest.withValues(alpha: 0.72),
        border: const OutlineInputBorder(borderRadius: radius12),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius12,
          borderSide: BorderSide(color: colors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius12,
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
      ),
    );
  }

  AuthUserFormLocalization _buildAuthLocalization(BuildContext context) {
    return AuthUserFormLocalization(
      displayNameLabel: context.locale.login__form__input__name,
      enterEmail: context.locale.login__form__input__email,
      validEmailError: context.locale.login__form__input__error_email,
      enterPassword: context.locale.login__form__input__password,
      passwordLengthError:
          context.locale.login__form__input__error_password_length,
      signIn: context.locale.login__form__button__signin,
      signUp: context.locale.login__form__button__signup,
      forgotPassword: context.locale.login__form__button__forgot_password,
      dontHaveAccount: context.locale.login__form__text__signup,
      haveAccount: context.locale.login__form__text__old_user,
      sendPasswordReset: context.locale.login__form__text__reset_password,
      passwordResetSent: context.locale.login__form__text__reset_ack,
      backToSignIn: context.locale.login__form__button__back,
      unexpectedError: context.locale.app__unknown_error,
    );
  }

  Future<void> _onAuthComplete(
    BuildContext context,
    AuthUser user,
    String accessToken, {
    required bool isSignUp,
  }) async {
    final appConfigCubit = context.read<AppConfigCubit>();
    final authCubit = context.read<AuthCubit>();
    await appConfigCubit.changeOnBoardStatus(false);
    authCubit.authenticated(user, accessToken);

    if (isSignUp) {
      authCubit.analyticsRepo.logSignup(
        signUpMethod: "Email",
        parameters: {"userId": user.userId, "email": user.email},
      );
      return;
    }

    authCubit.analyticsRepo.logSignin(
      loginMethod: "Email",
      parameters: {"userId": user.userId, "email": user.email},
    );
  }

  void _onAuthError(BuildContext context, Object? error) {
    final cubit = context.read<AuthCubit>();
    final failure = Failure.fromException(error);
    cubit.unauthenticated(failure);
    InAppNotificationService.i.notify(
      NotificationMessage(id: "login_failed", body: failure.message),
    );
  }

  EdgeInsets _contentPadding(bool isMobile) {
    final horizontal = isMobile
        ? _mobileHorizontalPadding
        : _desktopHorizontalPadding;
    final vertical = isMobile
        ? _mobileVerticalPadding
        : _desktopVerticalPadding;
    return EdgeInsets.fromLTRB(horizontal, vertical, horizontal, vertical);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isMobile = context.mq.isMobile;
    final authTheme = _buildAuthTheme(context);
    final localization = _buildAuthLocalization(context);
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const _LoginHeader(),
        height32,
        Theme(
          data: authTheme,
          child: CopyCatClipboardLoginForm(
            onSignUpComplete: (user, accessToken) =>
                _onAuthComplete(context, user, accessToken, isSignUp: true),
            onSignInComplete: (user, accessToken) =>
                _onAuthComplete(context, user, accessToken, isSignUp: false),
            onError: (error) => _onAuthError(context, error),
            localization: localization,
          ),
        ),
        Text(
          "· ─────── ·𖥸· ─────── ·",
          style: context.textTheme.titleMedium?.copyWith(
            color: colors.secondary,
          ),
          textAlign: TextAlign.center,
        ),
        height20,
        const LocalSigninButton(),
        height20,
        _TermsAndLocaleSection(
          isMobile: isMobile,
          onPrivacyPolicyTap: launchPrivacyPolicyPage,
          onTermsTap: launchTermsOfServicePage,
        ),
      ],
    );
    final body = useInternalScrollView
        ? SingleChildScrollView(
            controller: scrollController,
            padding: _contentPadding(isMobile),
            child: content,
          )
        : Padding(padding: _contentPadding(isMobile), child: content);

    if (isMobile) {
      return body;
    }

    return Card(
      elevation: 6,
      margin: EdgeInsets.zero,
      color: colors.surface.withValues(alpha: .96),
      shape: const RoundedRectangleBorder(borderRadius: radius26),
      child: body,
    );
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    final onSurfaceVariant = colors.onSurfaceVariant;

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: CircleAvatar(
            radius: 34,
            backgroundColor: colors.primaryContainer,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: BounceInUp(
                child: const Image(
                  image: AssetImage(AssetConstants.catPeekImage),
                  height: 55,
                ),
              ),
            ),
          ),
        ),
        width12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.locale.app__name, style: textTheme.titleLarge),
              Text(
                context.locale.app__slogan,
                style: textTheme.bodySmall?.copyWith(color: onSurfaceVariant),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TermsAndLocaleSection extends StatelessWidget {
  final bool isMobile;
  final VoidCallback onPrivacyPolicyTap;
  final VoidCallback onTermsTap;

  const _TermsAndLocaleSection({
    required this.isMobile,
    required this.onPrivacyPolicyTap,
    required this.onTermsTap,
  });

  @override
  Widget build(BuildContext context) {
    final termsText = _TermsText(
      onPrivacyPolicyTap: onPrivacyPolicyTap,
      onTermsTap: onTermsTap,
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [const LocaleDropdownButton(), height12, termsText],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: termsText),
        width16,
        const LocaleDropdownButton(),
      ],
    );
  }
}

class _TermsText extends StatelessWidget {
  final VoidCallback onPrivacyPolicyTap;
  final VoidCallback onTermsTap;

  const _TermsText({
    required this.onPrivacyPolicyTap,
    required this.onTermsTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    final onSurfaceVariant = colors.onSurfaceVariant;

    return Text.rich(
      TextSpan(
        style: textTheme.bodySmall?.copyWith(
          color: onSurfaceVariant,
          height: 1.55,
        ),
        text: context.locale.login__form__text_tnc_p1,
        children: [
          TextSpan(
            text: context.locale.login__form__text_tnc_p2,
            style: textTheme.bodySmall?.copyWith(
              color: colors.primary,
              decoration: TextDecoration.underline,
              decorationColor: colors.primary,
            ),
            recognizer: TapGestureRecognizer()..onTap = onPrivacyPolicyTap,
          ),
          TextSpan(text: context.locale.login__form__text_tnc_p3),
          TextSpan(
            text: context.locale.login__form__text_tnc_p4,
            style: textTheme.bodySmall?.copyWith(
              color: colors.primary,
              decoration: TextDecoration.underline,
              decorationColor: colors.primary,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTermsTap,
          ),
        ],
      ),
    );
  }
}
