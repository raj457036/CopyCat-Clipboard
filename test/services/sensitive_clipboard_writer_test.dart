import 'package:clipboard/base/data/services/clipboard/sensitive_clipboard_writer.dart';
import 'package:clipboard/base/data/services/clipboard/platform/macos_sensitive_clipboard_writer.dart';
import 'package:clipboard/base/data/services/clipboard/platform/windows_sensitive_clipboard_writer.dart';
import 'package:clipboard/base/data/services/clipboard/platform/noop_sensitive_clipboard_writer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:universal_io/io.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SensitiveClipboardWriter', () {
    test('instance resolves correct platform implementation', () {
      final writer = SensitiveClipboardWriter.instance;

      if (Platform.isMacOS) {
        expect(writer, isA<MacosSensitiveClipboardWriter>());
      } else if (Platform.isWindows) {
        expect(writer, isA<WindowsSensitiveClipboardWriter>());
      } else {
        expect(writer, isA<NoopSensitiveClipboardWriter>());
      }
    });

    test('NoopSensitiveClipboardWriter returns false', () async {
      const noop = NoopSensitiveClipboardWriter();
      final result = await noop.writeSensitiveText('test');
      expect(result, isFalse);
    });

    if (Platform.isMacOS) {
      test('MacosSensitiveClipboardWriter writes sensitive text via channel', () async {
        const channel = MethodChannel('copycat_sensitive_clipboard');
        String? receivedContent;

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall call) async {
          if (call.method == 'writeSensitiveText') {
            receivedContent = (call.arguments as Map)['content'] as String;
            return true;
          }
          return null;
        });

        addTearDown(() {
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(channel, null);
        });

        final writer = MacosSensitiveClipboardWriter();
        final result = await writer.writeSensitiveText('UnitTestSourceSecret123');

        expect(result, isTrue);
        expect(receivedContent, 'UnitTestSourceSecret123');
      });
    }
  });
}
