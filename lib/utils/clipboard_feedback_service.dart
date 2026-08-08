import 'package:clipboard/common/logging.dart';
import 'package:flutter/services.dart';
import 'package:universal_io/io.dart';

class ClipboardFeedbackService {
  static const MethodChannel _channel = MethodChannel(
    'copycat_clipboard_feedback',
  );

  ClipboardFeedbackService._();

  static final ClipboardFeedbackService i = ClipboardFeedbackService._();

  Future<void> notifyClipboardCopied({
    required bool showToast,
    String? message,
  }) async {
    if (!(Platform.isMacOS || Platform.isWindows)) return;

    if (!showToast) return;

    try {
      await _channel.invokeMethod<void>('showClipboardFeedback', {
        'message': message ?? 'Copied',
        'showToast': showToast,
      });
    } catch (e) {
      logger.e(() => 'Failed to show clipboard toast: $e');
    }
  }
}
