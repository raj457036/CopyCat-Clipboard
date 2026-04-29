import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'quick_paste_popup_method_channel.dart';
import 'models/models.dart';

abstract class QuickPastePopupPlatform extends PlatformInterface {
  /// Constructs a QuickPastePopupPlatform.
  QuickPastePopupPlatform() : super(token: _token);

  static final Object _token = Object();

  static QuickPastePopupPlatform _instance = MethodChannelQuickPastePopup();

  /// The default instance of [QuickPastePopupPlatform] to use.
  ///
  /// Defaults to [MethodChannelQuickPastePopup].
  static QuickPastePopupPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [QuickPastePopupPlatform] when
  /// they register themselves.
  static set instance(QuickPastePopupPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// Show the quick paste popup with the given clipboard items.
  ///
  /// Returns the result of the user interaction (which item was selected or if dismissed).
  Future<QuickPasteResult> showQuickPastePopup({
    required List<ClipboardItemDto> items,
  }) {
    throw UnimplementedError('showQuickPastePopup() has not been implemented.');
  }

  Future<bool> setTheme({int? selectionColor}) {
    throw UnimplementedError('setTheme() has not been implemented.');
  }

  /// Get the current cursor position on the screen.
  ///
  /// Returns a map with 'x' and 'y' coordinates, or null if not available.
  Future<Map<String, double>?> getCursorPosition() {
    throw UnimplementedError('getCursorPosition() has not been implemented.');
  }

  /// Get the currently focused application information.
  ///
  /// Returns a map with app name and bundle identifier.
  Future<Map<String, String>?> getFocusedApp() {
    throw UnimplementedError('getFocusedApp() has not been implemented.');
  }

  /// Attempt direct text insertion into the currently focused editable element.
  Future<bool> insertTextDirect(String text) {
    throw UnimplementedError('insertTextDirect() has not been implemented.');
  }

  /// Capture the caret position and focused element context immediately.
  ///
  /// Must be called while the target application still has focus (before
  /// CopyCat activates). The native side caches the result so that the
  /// subsequent [showQuickPastePopup] call can position itself at the caret.
  Future<bool> captureCaretContext() {
    throw UnimplementedError('captureCaretContext() has not been implemented.');
  }
}
