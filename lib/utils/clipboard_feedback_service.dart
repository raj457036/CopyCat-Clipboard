import 'package:clipboard/common/logging.dart';
import 'package:flutter/services.dart';
import 'package:universal_io/io.dart';

enum ClipboardFeedbackIcon {
  checkmark,
  nosign,
}

class ClipboardFeedbackParams {
  final bool showToast;
  final String message;
  final ClipboardFeedbackIcon icon;

  const ClipboardFeedbackParams({
    required this.showToast,
    this.message = 'Copied',
    this.icon = ClipboardFeedbackIcon.checkmark,
  });
}

class ClipboardFeedbackService {
  static const MethodChannel _channel = MethodChannel(
    'copycat_clipboard_feedback',
  );

  ClipboardFeedbackService._();

  static final ClipboardFeedbackService i = ClipboardFeedbackService._();

  Future<void> notifyFeedback(ClipboardFeedbackParams params) async {
    if (!(Platform.isMacOS || Platform.isWindows)) return;

    if (!params.showToast) return;

    try {
      await _channel.invokeMethod<void>('showClipboardFeedback', {
        'message': params.message,
        'showToast': params.showToast,
        'icon': params.icon.name,
      });
    } catch (e) {
      logger.e(() => 'Failed to show clipboard toast: $e');
    }
  }

  Future<void> notifyClipboardCopied({
    required bool showToast,
    String? message,
    ClipboardFeedbackIcon icon = ClipboardFeedbackIcon.checkmark,
  }) async {
    await notifyFeedback(
      ClipboardFeedbackParams(
        showToast: showToast,
        message: message ?? 'Copied',
        icon: icon,
      ),
    );
  }
}
