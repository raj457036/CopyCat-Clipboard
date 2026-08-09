import 'package:clipboard/base/constants/numbers/breakpoints.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/data/services/notification_service.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/titlebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

enum NonMobilePresentation { dialog, endSheet }

/// A [Page] that renders [pageChild] as a full-screen page on narrow (mobile)
/// screens and [dialogChild] inside a dialog or end-sheet on wide screens.
class DynamicPage<T> extends CustomTransitionPage<T> {
  final Widget pageChild;
  final Widget? dialogChild;
  final Offset? anchorPoint;
  final bool useSafeArea;
  final CapturedThemes? themes;
  final bool fullScreenDialog;
  final bool childOfTitlebar;
  final NonMobilePresentation nonMobilePresentation;
  final double? nonMobileSheetWidth;
  final bool closeOnSpace;

  DynamicPage({
    required this.pageChild,
    this.dialogChild,
    this.anchorPoint,
    this.useSafeArea = true,
    this.fullScreenDialog = false,
    this.childOfTitlebar = true,
    this.nonMobilePresentation = NonMobilePresentation.endSheet,
    this.nonMobileSheetWidth,
    this.closeOnSpace = false,
    this.themes,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  }) : super(
         child: pageChild,
         transitionsBuilder: (context, animation, secondaryAnimation, child) =>
             ScaleTransition(scale: animation, child: child),
         barrierColor: Colors.black54,
         barrierDismissible: true,
       );

  Widget _wrap(Widget child) =>
      closeOnSpace ? _SpaceToCloseWrapper(child: child) : child;

  @override
  Route<T> createRoute(BuildContext context) {
    final width = context.mq.size.width;

    if (Breakpoints.isMobile(width)) {
      final wrapped = _wrap(pageChild);
      return MaterialPageRoute<T>(
        settings: this,
        builder: (context) =>
            childOfTitlebar ? TitlebarView(child: wrapped) : wrapped,
        fullscreenDialog: fullScreenDialog,
        maintainState: true,
        barrierDismissible: barrierDismissible,
      );
    }

    final effectiveDialogChild = _wrap(dialogChild ?? pageChild);

    if (nonMobilePresentation == NonMobilePresentation.endSheet) {
      final sheetWidth =
          nonMobileSheetWidth ?? (width * 0.8).clamp(440.0, 860.0).toDouble();

      return _EndSheetDialogRoute<T>(
        context: context,
        settings: this,
        builder: (context) => Align(
          alignment: Alignment.centerRight,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: sheetWidth),
            child: effectiveDialogChild,
          ),
        ),
        anchorPoint: anchorPoint,
        barrierColor: barrierColor,
        barrierDismissible: barrierDismissible,
        barrierLabel: barrierLabel,
        useSafeArea: useSafeArea,
        themes: themes,
      );
    }

    return DialogRoute<T>(
      context: context,
      settings: this,
      builder: (context) => Dialog(
        shape: const RoundedRectangleBorder(borderRadius: radius12),
        clipBehavior: Clip.hardEdge,
        child: ConstrainedBox(
          constraints: BoxConstraints.loose(const Size(924, 580)),
          child: effectiveDialogChild,
        ),
      ),
      anchorPoint: anchorPoint,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      themes: themes,
    );
  }
}

class _EndSheetDialogRoute<T> extends DialogRoute<T> {
  _EndSheetDialogRoute({
    required super.context,
    required super.builder,
    super.settings,
    super.anchorPoint,
    super.barrierColor,
    super.barrierDismissible,
    super.barrierLabel,
    super.useSafeArea,
    super.themes,
  });

  CurvedAnimation? opacityAnimation, slideAnimation;
  GlobalKey<ScaffoldMessengerState>? _scaffoldMessengerKey;

  void _setAnimation(Animation<double> animation) {
    if (slideAnimation?.parent != animation) {
      slideAnimation?.dispose();
      slideAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
    }

    if (opacityAnimation?.parent != animation) {
      opacityAnimation?.dispose();
      opacityAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      );
    }
  }

  @override
  void dispose() {
    slideAnimation?.dispose();
    opacityAnimation?.dispose();
    if (_scaffoldMessengerKey != null) {
      InAppNotificationService.removeScaffoldMessengerKey(
        _scaffoldMessengerKey!,
      );
    }
    super.dispose();
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 220);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    _scaffoldMessengerKey ??= InAppNotificationService.mintScaffoldMessengerKey;
    _setAnimation(animation);
    return FadeTransition(
      opacity: opacityAnimation!,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(slideAnimation!),
        child: ScaffoldMessenger(key: _scaffoldMessengerKey, child: child),
      ),
    );
  }
}

class _SpaceToCloseWrapper extends StatefulWidget {
  final Widget child;

  const _SpaceToCloseWrapper({required this.child});

  @override
  State<_SpaceToCloseWrapper> createState() => _SpaceToCloseWrapperState();
}

class _SpaceToCloseWrapperState extends State<_SpaceToCloseWrapper> {
  bool _consumeSpaceUp = false;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_handleHardwareKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_handleHardwareKey);
    super.dispose();
  }

  static bool _isEditingText() {
    final focusContext = FocusManager.instance.primaryFocus?.context;
    if (focusContext == null) return false;

    if (focusContext.widget is EditableText) {
      return true;
    }

    return focusContext.findAncestorWidgetOfExactType<EditableText>() != null;
  }

  bool _handleHardwareKey(KeyEvent event) {
    if (!mounted) return false;
    if (event.logicalKey != LogicalKeyboardKey.space) return false;

    if (event is KeyUpEvent) {
      if (_consumeSpaceUp) {
        _consumeSpaceUp = false;
        return true;
      }
      return false;
    }

    if (event is KeyRepeatEvent) {
      return _consumeSpaceUp;
    }

    if (event is! KeyDownEvent) return false;

    // Allow normal typing in text fields.
    if (_isEditingText()) {
      return false;
    }

    final route = ModalRoute.of(context);
    if (route?.isCurrent != true) {
      return false;
    }

    final navigator = Navigator.maybeOf(context);
    if (navigator == null || !navigator.canPop()) {
      return true;
    }

    _consumeSpaceUp = true;
    navigator.maybePop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
