import 'package:clipboard/base/constants/key.dart';
import 'package:clipboard/base/constants/numbers/breakpoints.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/timer_progress_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class _SnackStyle {
  final Color? background;
  final Color? foreground;

  const _SnackStyle({this.background, this.foreground});
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSnackbar(
  SnackBar snackBar, {
  bool closePrevious = false,
  BuildContext? context,
}) {
  ScaffoldMessengerState? state = context != null
      ? (ScaffoldMessenger.maybeOf(context) ??
            scaffoldMessengerKey.currentState)
      : scaffoldMessengerKey.currentState;

  if (closePrevious) {
    state?.removeCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
  }
  return state?.showSnackBar(snackBar);
}

void closeSnackbar() {
  ScaffoldMessengerState? state = scaffoldMessengerKey.currentState;
  state?.removeCurrentSnackBar(reason: SnackBarClosedReason.dismiss);
}

EdgeInsets? _getSnackBarMargin(BuildContext context) {
  final mq = context.mq;
  const double snackBarWidth = 480.0;
  final double horizontalMargin = (mq.size.width - snackBarWidth) / 2;
  return Breakpoints.isMobile(mq.size.width)
      ? null
      : EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: 8.0);
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showFailureSnackbar(
  Failure failure,
) {
  final context = scaffoldMessengerKey.currentContext;
  if (context == null) return null;

  final mq = context.mq;
  final colors = context.colors;
  final isMobile = Breakpoints.isMobile(mq.size.width);
  final style = _snackStyle(context, failure: true);
  return showSnackbar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: style.foreground ?? colors.onErrorContainer,
          ),
          width8,
          Expanded(
            child: Text(
              failure.message,
              maxLines: 10,
              overflow: TextOverflow.clip,
              style: TextStyle(
                color: style.foreground ?? colors.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
      shape: isMobile ? null : const StadiumBorder(),
      closeIconColor: style.foreground ?? colors.onErrorContainer,
      behavior: isMobile ? SnackBarBehavior.fixed : SnackBarBehavior.floating,
      margin: _getSnackBarMargin(context),
      showCloseIcon: !isMobile,
      backgroundColor: style.background ?? colors.errorContainer,
    ),
    closePrevious: true,
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showDebugSnackbar(
  String text,
) {
  if (!kDebugMode) return null;
  final message = "DEBUG :: $text";
  logger.d(message);
  showTextSnackbar(message, closePrevious: true);
  return null;
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showTextSnackbar(
  String text, {
  bool isLoading = false,
  bool isProgress = false,
  bool success = false,
  bool failure = false,
  bool closePrevious = false,
  int? duration,
  SnackBarAction? action,
  BuildContext? context,
}) {
  final innerContext = context ?? scaffoldMessengerKey.currentContext;
  if (innerContext == null) return null;
  final mq = innerContext.mq;
  final colors = innerContext.colors;

  final isMobile = Breakpoints.isMobile(mq.size.width);
  final style = _snackStyle(innerContext, success: success, failure: failure);

  Widget child;

  if (isLoading) {
    child = Row(
      children: [
        const SizedBox.square(
          dimension: 22,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        width8,
        Text(text),
      ],
    );
  } else if (isProgress) {
    child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text),
        height6,
        TimerProgressBar(duration: Duration(seconds: duration ?? 3)),
      ],
    );
  } else {
    child = Text(text);
  }

  return showSnackbar(
    SnackBar(
      content: IconTheme(
        data: IconThemeData(color: style.foreground),
        child: DefaultTextStyle.merge(
          style: TextStyle(color: style.foreground ?? colors.onInverseSurface),
          child: child,
        ),
      ),
      backgroundColor: style.background ?? colors.inverseSurface,
      showCloseIcon: !isMobile && !isLoading,
      closeIconColor: style.foreground ?? colors.onInverseSurface,
      behavior: isMobile ? SnackBarBehavior.fixed : SnackBarBehavior.floating,
      margin: _getSnackBarMargin(innerContext),
      duration: duration != null
          ? Duration(seconds: duration)
          : isLoading
          ? const Duration(seconds: 30)
          : const Duration(seconds: 4),
      action: action == null
          ? null
          : SnackBarAction(
              label: action.label,
              onPressed: action.onPressed,
              textColor: style.foreground ?? colors.inversePrimary,
              disabledTextColor: style.foreground?.withValues(alpha: 0.6),
            ),
      shape: isMobile ? null : const StadiumBorder(),
    ),
    closePrevious: closePrevious,
    context: innerContext,
  );
}

_SnackStyle _snackStyle(
  BuildContext context, {
  bool success = false,
  bool failure = false,
}) {
  final colors = context.colors;

  if (failure) {
    return _SnackStyle(
      background: colors.errorContainer,
      foreground: colors.onErrorContainer,
    );
  }

  if (success) {
    return _SnackStyle(
      background: colors.tertiaryContainer,
      foreground: colors.onTertiaryContainer,
    );
  }

  return const _SnackStyle();
}
