import 'package:clipboard/base/constants/numbers/breakpoints.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/titlebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

enum NonMobilePresentation { dialog, endSheet }

class DynamicPage<T> extends CustomTransitionPage<T> {
  final Offset? anchorPoint;
  final bool useSafeArea;
  final CapturedThemes? themes;
  final bool fullScreenDialog;
  final bool isBottomSheet;
  final bool childOfTitlebar;
  final NonMobilePresentation nonMobilePresentation;
  final double? nonMobileSheetWidth;
  final bool closeOnSpace;

  DynamicPage({
    required super.child,
    this.anchorPoint,
    this.useSafeArea = true,
    this.fullScreenDialog = false,
    this.isBottomSheet = false,
    this.childOfTitlebar = true,
    this.nonMobilePresentation = NonMobilePresentation.dialog,
    this.nonMobileSheetWidth,
    this.closeOnSpace = false,
    this.themes,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  }) : assert(
         !isBottomSheet || !fullScreenDialog,
         'Cannot have both bottom sheet and full screen dialog',
       ),
       super(
         transitionsBuilder: (context, animation, secondaryAnimation, child) =>
             ScaleTransition(scale: animation, child: child),
         barrierColor: Colors.black54,
         barrierDismissible: true,
       );

  @override
  Route<T> createRoute(BuildContext context) {
    final mq = context.mq;
    final width = mq.size.width;
    final wrappedChild = closeOnSpace
        ? _SpaceToCloseWrapper(child: child)
        : child;

    if (Breakpoints.isMobile(width)) {
      if (isBottomSheet) {
        return ModalBottomSheetRoute<T>(
          settings: this,
          isScrollControlled: false,
          showDragHandle: true,
          constraints: BoxConstraints(maxWidth: width * 0.9),
          backgroundColor: Colors.transparent,
          builder: (context) {
            final bottom = MediaQuery.of(context).viewInsets.bottom;
            return Padding(
              padding: EdgeInsets.only(bottom: bottom),
              child: childOfTitlebar
                  ? TitlebarView(child: wrappedChild)
                  : wrappedChild,
            );
          },
        );
      }
      return MaterialPageRoute<T>(
        settings: this,
        builder: (context) =>
            childOfTitlebar ? TitlebarView(child: wrappedChild) : wrappedChild,
        fullscreenDialog: fullScreenDialog,
        maintainState: true,
        barrierDismissible: barrierDismissible,
      );
    }

    if (nonMobilePresentation == NonMobilePresentation.endSheet) {
      final sheetWidth =
          nonMobileSheetWidth ?? (width * 0.52).clamp(440.0, 760.0).toDouble();

      return _EndSheetDialogRoute<T>(
        context: context,
        settings: this,
        builder: (context) {
          final sheetChild = wrappedChild;

          return Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: SizedBox(
                width: sheetWidth,
                height: double.infinity,
                child: ClipRRect(
                  borderRadius: radius12,
                  child: Material(
                    color: Theme.of(context).colorScheme.surface,
                    child: ScaffoldMessenger(child: sheetChild),
                  ),
                ),
              ),
            ),
          );
        },
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
        child: ConstrainedBox(
          constraints: BoxConstraints.loose(const Size(924, 580)),
          child: ClipRRect(borderRadius: radius12, child: wrappedChild),
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

  @override
  Duration get transitionDuration => const Duration(milliseconds: 220);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curve = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(curve),
        child: child,
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
