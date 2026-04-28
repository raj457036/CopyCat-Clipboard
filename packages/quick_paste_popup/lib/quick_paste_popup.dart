import 'quick_paste_popup_platform_interface.dart';
import 'models/models.dart';

export 'models/models.dart';

class QuickPastePopup {
  Future<String?> getPlatformVersion() {
    return QuickPastePopupPlatform.instance.getPlatformVersion();
  }

  /// Show the quick paste popup with the given clipboard items.
  ///
  /// The popup will appear at the cursor position (or center screen if unavailable)
  /// and allow the user to navigate and select an item to paste.
  ///
  /// Returns the result of the user interaction.
  Future<QuickPasteResult> showQuickPastePopup({
    required List<ClipboardItemDto> items,
  }) {
    return QuickPastePopupPlatform.instance.showQuickPastePopup(items: items);
  }

  Future<bool> setTheme({int? selectionColor}) {
    return QuickPastePopupPlatform.instance.setTheme(
      selectionColor: selectionColor,
    );
  }

  /// Get the current cursor position on the screen.
  ///
  /// Returns a map with 'x' and 'y' coordinates, or null if not available.
  Future<Map<String, double>?> getCursorPosition() {
    return QuickPastePopupPlatform.instance.getCursorPosition();
  }

  /// Get the currently focused application information.
  ///
  /// Returns a map with app name and bundle identifier.
  Future<Map<String, String>?> getFocusedApp() {
    return QuickPastePopupPlatform.instance.getFocusedApp();
  }

  /// Attempt direct text insertion into the focused editable element.
  Future<bool> insertTextDirect(String text) {
    return QuickPastePopupPlatform.instance.insertTextDirect(text);
  }
}
