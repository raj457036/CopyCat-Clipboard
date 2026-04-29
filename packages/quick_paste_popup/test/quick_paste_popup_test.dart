import 'package:flutter_test/flutter_test.dart';
import 'package:quick_paste_popup/quick_paste_popup.dart';
import 'package:quick_paste_popup/quick_paste_popup_platform_interface.dart';
import 'package:quick_paste_popup/quick_paste_popup_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockQuickPastePopupPlatform
    with MockPlatformInterfaceMixin
    implements QuickPastePopupPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<QuickPasteResult> showQuickPastePopup({
    required List<ClipboardItemDto> items,
  }) => Future.value(QuickPasteResult(dismissed: true));

  @override
  Future<bool> setTheme({int? selectionColor}) => Future.value(true);

  @override
  Future<Map<String, double>?> getCursorPosition() =>
      Future.value({'x': 0.0, 'y': 0.0});

  @override
  Future<Map<String, String>?> getFocusedApp() =>
      Future.value({'name': 'TestApp', 'bundleId': 'com.test.app'});

  @override
  Future<bool> insertTextDirect(String text) => Future.value(true);

  @override
  Future<bool> captureCaretContext() => Future.value(true);
}

void main() {
  final QuickPastePopupPlatform initialPlatform =
      QuickPastePopupPlatform.instance;

  test('$MethodChannelQuickPastePopup is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelQuickPastePopup>());
  });

  test('getPlatformVersion', () async {
    QuickPastePopup quickPastePopupPlugin = QuickPastePopup();
    MockQuickPastePopupPlatform fakePlatform = MockQuickPastePopupPlatform();
    QuickPastePopupPlatform.instance = fakePlatform;

    expect(await quickPastePopupPlugin.getPlatformVersion(), '42');
  });
}
