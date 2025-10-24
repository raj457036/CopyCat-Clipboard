import 'package:clipboard/base/constants/numbers/breakpoints.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/titlebar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DynamicPage<T> extends CustomTransitionPage<T> {
  final Offset? anchorPoint;
  final bool useSafeArea;
  final CapturedThemes? themes;
  final bool fullScreenDialog;
  final bool isBottomSheet;
  final bool childOfTitlebar;

  DynamicPage({
    required super.child,
    this.anchorPoint,
    this.useSafeArea = true,
    this.fullScreenDialog = false,
    this.isBottomSheet = false,
    this.childOfTitlebar = true,
    this.themes,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  })  : assert(!isBottomSheet || !fullScreenDialog,
            'Cannot have both bottom sheet and full screen dialog'),
        super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              ScaleTransition(
            scale: animation,
            child: child,
          ),
          barrierColor: Colors.black54,
          barrierDismissible: true,
        );

  @override
  Route<T> createRoute(BuildContext context) {
    final mq = context.mq;
    final width = mq.size.width;

    if (Breakpoints.isMobile(width)) {
      if (isBottomSheet) {
        return ModalBottomSheetRoute<T>(
          settings: this,
          isScrollControlled: false,
          showDragHandle: true,
          constraints: BoxConstraints(
            maxWidth: width * 0.9,
          ),
          backgroundColor: Colors.transparent,
          builder: (context) {
            final bottom = MediaQuery.of(context).viewInsets.bottom;
            return Padding(
              padding: EdgeInsets.only(bottom: bottom),
              child: childOfTitlebar ? TitlebarView(child: child) : child,
            );
          },
        );
      }
      return MaterialPageRoute<T>(
        settings: this,
        builder: (context) =>
            childOfTitlebar ? TitlebarView(child: child) : child,
        fullscreenDialog: fullScreenDialog,
        maintainState: true,
        barrierDismissible: barrierDismissible,
      );
    }

    return DialogRoute<T>(
      context: context,
      settings: this,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: BoxConstraints.loose(const Size(924, 580)),
          child: ClipRRect(
            borderRadius: radius12,
            child: child,
          ),
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
