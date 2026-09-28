import 'package:clipboard/base/data/services/clipboard/sensitive_clipboard_writer.dart';

class NoopSensitiveClipboardWriter implements SensitiveClipboardWriter {
  const NoopSensitiveClipboardWriter();

  @override
  Future<bool> writeSensitiveText(String text) async => false;
}
