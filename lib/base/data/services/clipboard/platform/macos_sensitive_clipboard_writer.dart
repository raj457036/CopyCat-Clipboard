import 'package:flutter/services.dart';
import 'package:clipboard/base/data/services/clipboard/sensitive_clipboard_writer.dart';
import 'package:clipboard/common/logging.dart';

class MacosSensitiveClipboardWriter implements SensitiveClipboardWriter {
  static const MethodChannel _channel = MethodChannel(
    'copycat_sensitive_clipboard',
  );

  @override
  Future<bool> writeSensitiveText(String text) async {
    try {
      final result = await _channel.invokeMethod<bool>('writeSensitiveText', {
        'content': text,
      });
      return result ?? true;
    } catch (e) {
      logger.e(
        () => '[MacosSensitiveClipboardWriter] Failed to write sensitive text: $e',
      );
      return false;
    }
  }
}
