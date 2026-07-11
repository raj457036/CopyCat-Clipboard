import 'package:clipboard/base/constants/strings/asset_constants.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';

String loginArtworkAssetPath(BuildContext context) {
  final isDarkMode = context.theme.brightness == Brightness.dark;

  return isDarkMode
      ? AssetConstants.catInValleyWideDark
      : AssetConstants.catInValleyWide;
}

// MARK: - Scaffold

class LoginPageScaffold extends StatefulWidget {
  final Widget child;

  const LoginPageScaffold({super.key, required this.child});

  @override
  State<LoginPageScaffold> createState() => _LoginPageScaffoldState();
}

class _LoginPageScaffoldState extends State<LoginPageScaffold> {
  static const _desktopInset = 24.0;
  static const _mobileMaxWidth = 560.0;
  static const _desktopMaxWidth = 430.0;

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: context.isMobile
          ? LoginMobileLayout(
              maxWidth: _mobileMaxWidth,
              scrollController: _scrollController,
              child: widget.child,
            )
          : Stack(
              fit: StackFit.expand,
              children: [
                const LoginBackground(),
                LoginSurfaceContainer(
                  maxHeight: context.screenSize.height - 72,
                  inset: _desktopInset,
                  maxWidth: _desktopMaxWidth,
                  child: widget.child,
                ),
              ],
            ),
    );
  }
}

// MARK: - Background

class LoginBackground extends StatelessWidget {
  static const _themeSwapDuration = Duration(milliseconds: 320);

  const LoginBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final assetPath = loginArtworkAssetPath(context);

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

// MARK: - Surface Container (desktop)

class LoginSurfaceContainer extends StatelessWidget {
  final double inset;
  final double maxWidth;
  final double maxHeight;
  final Widget child;

  const LoginSurfaceContainer({
    super.key,
    required this.inset,
    required this.maxWidth,
    required this.maxHeight,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.all(inset),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
          child: child,
        ),
      ),
    );
  }
}

// MARK: - Mobile Layout

class LoginMobileLayout extends StatelessWidget {
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

  const LoginMobileLayout({
    super.key,
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
                        child: const LoginMobileHero(),
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

// MARK: - Mobile Hero

class LoginMobileHero extends StatelessWidget {
  static const _themeSwapDuration = Duration(milliseconds: 320);

  const LoginMobileHero({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final assetPath = loginArtworkAssetPath(context);

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
