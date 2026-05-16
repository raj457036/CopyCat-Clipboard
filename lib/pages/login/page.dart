import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/constants/strings/asset_constants.dart';
import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/data/services/notification_service.dart'
    show InAppNotificationService;
import 'package:clipboard/base/domain/model/notification_message.dart'
    show NotificationMessage;
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/pages/login/widgets/login_form.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/locale_dropdown_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

String _loginArtworkAssetPath(BuildContext context) {
  final isDarkMode = context.theme.brightness == Brightness.dark;

  return isDarkMode
      ? AssetConstants.catInValleyWideDark
      : AssetConstants.catInValleyWide;
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const _switchDuration = Duration(milliseconds: 420);
  static const _desktopInset = 24.0;
  static const _mobileMaxWidth = 560.0;
  static const _desktopMaxWidth = 430.0;

  bool _showModeSelection = true;
  final ScrollController _mobileFormScrollController = ScrollController();

  void _continueToSignIn() {
    if (!mounted) return;
    setState(() {
      _showModeSelection = false;
    });
  }

  void _continueOffline() {
    if (!mounted) return;
    context.read<AuthCubit>().localAuthenticated();
  }

  Future<void> _launchPrivacyPolicyPage() async {
    await launchUrl(Uri.parse(privacyPolicyUrl));
  }

  Future<void> _launchTermsOfServicePage() async {
    await launchUrl(Uri.parse(termsConditionsUrl));
  }

  Widget _transitionBuilder(Widget child, Animation<double> animation) {
    final offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(position: offsetAnimation, child: child),
    );
  }

  @override
  void dispose() {
    _mobileFormScrollController.dispose();
    super.dispose();
  }

  Widget _buildContentSwitcher({required bool isSmallDevice}) {
    return AnimatedSwitcher(
      duration: _switchDuration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: _transitionBuilder,
      child: _showModeSelection
          ? _LoginModeSelectionCard(
              key: const ValueKey('mode-selection'),
              onOfflineSelected: _continueOffline,
              onSignInSelected: _continueToSignIn,
              onPrivacyPolicyTap: _launchPrivacyPolicyPage,
              onTermsTap: _launchTermsOfServicePage,
            )
          : LoginForm(
              key: const ValueKey('login-form'),
              useInternalScrollView: !isSmallDevice,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = context.mq;
    final isSmallDevice = mq.isMobile;
    final content = _buildContentSwitcher(isSmallDevice: isSmallDevice);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) async {
        switch (state) {
          case UnauthenticatedAuthState(:final failure):
            if (failure == null) return;
            InAppNotificationService.i.notify(
              NotificationMessage(id: "login_failed", body: failure.message),
            );

          default:
        }
      },
      child: Scaffold(
        body: isSmallDevice
            ? _MobileLoginLayout(
                maxWidth: _mobileMaxWidth,
                scrollController: _mobileFormScrollController,
                child: content,
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  const _LoginBackground(),
                  _LoginSurfaceContainer(
                    isMobile: false,
                    maxHeight: mq.size.height - 72,
                    inset: _desktopInset,
                    maxWidth: _desktopMaxWidth,
                    child: content,
                  ),
                ],
              ),
      ),
    );
  }
}

class _LoginBackground extends StatelessWidget {
  static const _themeSwapDuration = Duration(milliseconds: 320);

  const _LoginBackground();

  @override
  Widget build(BuildContext context) {
    final assetPath = _loginArtworkAssetPath(context);

    return AnimatedSwitcher(
      duration: _themeSwapDuration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      layoutBuilder: (currentChild, previousChildren) => Stack(
        fit: StackFit.expand,
        children: [...previousChildren, ?currentChild],
      ),
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: Image(
        key: ValueKey(assetPath),
        image: AssetImage(assetPath),
        fit: BoxFit.cover,
        alignment: const Alignment(0.3, 0.02),
        gaplessPlayback: true,
      ),
    );
  }
}

class _MobileLoginLayout extends StatelessWidget {
  static const _horizontalInset = 16.0;
  static const _bottomInset = 16.0;
  static const _contentOverlap = 52.0;
  static const _heroMinHeight = 208.0;
  static const _heroMaxHeight = 320.0;
  static const _heroMinHeightWithKeyboard = 120.0;
  static const _heroMaxHeightWithKeyboard = 180.0;

  final double maxWidth;
  final ScrollController scrollController;
  final Widget child;

  const _MobileLoginLayout({
    required this.maxWidth,
    required this.scrollController,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasKeyboard = MediaQuery.viewInsetsOf(context).bottom > 0;

    return ColoredBox(
      color: colors.surface,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final heroHeight =
                (constraints.maxHeight * (hasKeyboard ? 0.24 : 0.38))
                    .clamp(
                      hasKeyboard ? _heroMinHeightWithKeyboard : _heroMinHeight,
                      hasKeyboard ? _heroMaxHeightWithKeyboard : _heroMaxHeight,
                    )
                    .toDouble();
            final contentTopPadding = (heroHeight - _contentOverlap)
                .clamp(0.0, heroHeight)
                .toDouble();

            return Stack(
              children: [
                Positioned.fill(
                  child: Column(
                    children: [
                      SizedBox(
                        height: heroHeight,
                        child: const _MobileLoginHero(),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(
                      _horizontalInset,
                      0,
                      _horizontalInset,
                      _bottomInset,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: contentTopPadding),
                        Align(
                          alignment: Alignment.topCenter,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: maxWidth),
                            child: child,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MobileLoginHero extends StatelessWidget {
  static const _themeSwapDuration = Duration(milliseconds: 320);

  const _MobileLoginHero();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final assetPath = _loginArtworkAssetPath(context);

    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedSwitcher(
          duration: _themeSwapDuration,
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          layoutBuilder: (currentChild, previousChildren) => Stack(
            fit: StackFit.expand,
            children: [...previousChildren, ?currentChild],
          ),
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: Image(
            key: ValueKey(assetPath),
            image: AssetImage(assetPath),
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
            gaplessPlayback: true,
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colors.surface.withValues(alpha: 0),
                colors.surface.withValues(alpha: 0.14),
                colors.surface,
              ],
              stops: const [0.0, 0.72, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}

class _LoginSurfaceContainer extends StatelessWidget {
  final bool isMobile;
  final double inset;
  final double maxWidth;
  final double maxHeight;
  final Widget child;

  const _LoginSurfaceContainer({
    required this.isMobile,
    required this.inset,
    required this.maxWidth,
    required this.maxHeight,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: isMobile ? Alignment.bottomCenter : Alignment.topRight,
        child: Padding(
          padding: EdgeInsets.all(inset),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
              maxHeight: maxHeight,
            ),
            child: child,
          ),
        ),
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
    super.key,
    required this.onOfflineSelected,
    required this.onSignInSelected,
    required this.onPrivacyPolicyTap,
    required this.onTermsTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    final isMobile = context.mq.isMobile;

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
      elevation: isMobile ? 0 : 6,
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
