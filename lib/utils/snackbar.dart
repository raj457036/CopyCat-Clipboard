import 'package:clipboard/base/common/failure.dart';
import 'package:clipboard/base/common/logging.dart';
import 'package:clipboard/base/constants/key.dart';
import 'package:clipboard/base/constants/numbers/breakpoints.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/widgets/timer_progress_bar.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showFailureSnackbar(
  Failure failure,
) {
  final context = scaffoldMessengerKey.currentContext;
  if (context == null) return null;

  final mq = context.mq;
  final colors = context.colors;
  final isMobile = Breakpoints.isMobile(mq.size.width);
  return showSnackbar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: colors.onError,
          ),
          width8,
          Expanded(
            child: Text(
              failure.message,
              maxLines: 10,
              overflow: TextOverflow.clip,
              style: TextStyle(
                color: colors.onError,
              ),
            ),
          )
        ],
      ),
      shape: isMobile ? null : const StadiumBorder(),
      closeIconColor: colors.onError,
      behavior: isMobile ? SnackBarBehavior.fixed : SnackBarBehavior.floating,
      width: isMobile ? null : 480,
      showCloseIcon: !isMobile,
      backgroundColor: colors.error,
    ),
    closePrevious: true,
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showDebugSnackbar(
    String text) {
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

  final isMobile = Breakpoints.isMobile(mq.size.width);

  Color? bg;
  if (success) bg = Colors.green;
  if (failure) {
    final colors = innerContext.colors;
    bg = colors.error;
  }

  Widget child;

  if (isLoading) {
    child = Row(
      children: [
        const SizedBox.square(
          dimension: 22,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        width8,
        Text(text)
      ],
    );
  } else if (isProgress) {
    child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text),
        height6,
        TimerProgressBar(
          duration: Duration(seconds: duration ?? 4),
        ),
      ],
    );
  } else {
    child = Text(text);
  }

  return showSnackbar(
    SnackBar(
      content: child,
      backgroundColor: bg,
      showCloseIcon: !isMobile && !isLoading,
      behavior: isMobile ? SnackBarBehavior.fixed : SnackBarBehavior.floating,
      width: isMobile ? null : 480,
      duration: duration != null
          ? Duration(seconds: duration)
          : isLoading
              ? const Duration(seconds: 30)
              : const Duration(seconds: 4),
      action: action,
      shape: isMobile ? null : const StadiumBorder(),
    ),
    closePrevious: closePrevious,
    context: innerContext,
  );
}
