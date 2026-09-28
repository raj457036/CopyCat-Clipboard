import 'package:universal_io/io.dart';
import 'package:clipboard/base/data/services/clipboard/platform/macos_sensitive_clipboard_writer.dart';
import 'package:clipboard/base/data/services/clipboard/platform/noop_sensitive_clipboard_writer.dart';
import 'package:clipboard/base/data/services/clipboard/platform/windows_sensitive_clipboard_writer.dart';

abstract interface class SensitiveClipboardWriter {
  Future<bool> writeSensitiveText(String text);

  static final SensitiveClipboardWriter instance = _createWriter();

  static SensitiveClipboardWriter _createWriter() {
    if (Platform.isMacOS) {
      return MacosSensitiveClipboardWriter();
    }
    if (Platform.isWindows) {
      return WindowsSensitiveClipboardWriter();
    }
    return const NoopSensitiveClipboardWriter();
  }
}
