import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quick_paste_popup/quick_paste_popup_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelQuickPastePopup platform = MethodChannelQuickPastePopup();
  const MethodChannel channel = MethodChannel('quick_paste_popup');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          return '42';
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
