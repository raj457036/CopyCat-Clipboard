import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/constants/strings/asset_constants.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/pages/login/widgets/login_page_scaffold.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/locale_dropdown_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> _launchPrivacyPolicyPage() async {
    await launchUrl(Uri.parse(privacyPolicyUrl));
  }

  Future<void> _launchTermsOfServicePage() async {
    await launchUrl(Uri.parse(termsConditionsUrl));
  }

  @override
  Widget build(BuildContext context) {
    return LoginPageScaffold(
      child: _LoginModeSelectionCard(
        onOfflineSelected: () => context.read<AuthCubit>().localAuthenticated(),
        onSignInSelected: () => context.pushNamed(RouteConstants.loginForm),
        onPrivacyPolicyTap: _launchPrivacyPolicyPage,
        onTermsTap: _launchTermsOfServicePage,
      ),
    );
  }
}

class _LoginModeSelectionCard extends StatelessWidget {
  final VoidCallback onOfflineSelected;
  final VoidCallback onSignInSelected;
  final VoidCallback onPrivacyPolicyTap;
  final VoidCallback onTermsTap;

  const _LoginModeSelectionCard({
    required this.onOfflineSelected,
    required this.onSignInSelected,
    required this.onPrivacyPolicyTap,
    required this.onTermsTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    final isMobile = context.isMobile;

    final content = Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Positioned(
          top: isMobile ? 13 : 0,
          left: isMobile ? 15 : 24,
          child: Image(
            image: isMobile
                ? const AssetImage(AssetConstants.catPeekImage)
                : const AssetImage(AssetConstants.catPeekUpSideDownImage),
            height: 68,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 64, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height24,
              Text('Welcome to', style: textTheme.headlineSmall),
              Text(
                context.locale.app__name,
                style: textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              height12,
              Text(
                context.locale.app__slogan,
                style: textTheme.bodyLarge?.copyWith(
                  color: colors.onSurfaceVariant,
                  height: 1.3,
                ),
              ),
              height24,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onSignInSelected,
                  icon: const Icon(Icons.login_rounded),
                  label: Text(context.locale.login__form__button__signin),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                  ),
                ),
              ),
              height12,
              Tooltip(
                message: context.locale.login__local_signin__tooltip,
                child: ElevatedButton.icon(
                  onPressed: onOfflineSelected,
                  icon: const Icon(Icons.cloud_off_rounded),
                  label: Text(context.locale.login__local_signin__btn__label),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(44),
                    backgroundColor: colors.secondaryContainer,
                    foregroundColor: colors.onSecondaryContainer,
                  ),
                ),
              ),
              height20,
              const Center(child: LocaleDropdownButton()),
              height12,
              _ModeSelectionTermsText(
                onPrivacyPolicyTap: onPrivacyPolicyTap,
                onTermsTap: onTermsTap,
              ),
            ],
          ),
        ),
      ],
    );

    if (isMobile) {
      return content;
    }

    return Card.filled(
      elevation: 6,
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(borderRadius: radius26),
      color: colors.surface.withValues(alpha: .96),
      child: content,
    );
  }
}

class _ModeSelectionTermsText extends StatelessWidget {
  final VoidCallback onPrivacyPolicyTap;
  final VoidCallback onTermsTap;

  const _ModeSelectionTermsText({
    required this.onPrivacyPolicyTap,
    required this.onTermsTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;

    return Text.rich(
      TextSpan(
        style: textTheme.bodySmall?.copyWith(
          color: colors.onSurfaceVariant,
          height: 1.45,
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
