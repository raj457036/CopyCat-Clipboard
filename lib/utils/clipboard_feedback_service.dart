import 'package:clipboard/common/logging.dart';
import 'package:clipboard/utils/utility.dart'
    show isDesktopPlatform, isMobilePlatform;
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
    required bool playHaptic,
    String? message,
  }) async {
    if (playHaptic && isMobilePlatform) {
      await HapticFeedback.selectionClick();
    }

    if (!showToast && !playHaptic) return;

    if (!isDesktopPlatform || !Platform.isMacOS) return;

    try {
      await _channel.invokeMethod<void>('showClipboardFeedback', {
        'message': message ?? 'Copied',
        'showToast': showToast,
        'playHaptic': playHaptic,
      });
    } catch (e) {
      logger.e(() => 'Failed to show clipboard toast: $e');
    }
  }
}
