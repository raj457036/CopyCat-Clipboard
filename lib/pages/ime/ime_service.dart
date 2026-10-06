import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum ImeActionType {
  none,
  go,
  search,
  send,
  next,
  done,
  previous,
  newline,
}

/// Singleton MethodChannel wrapper for communication with [CopyCatImeService].
class ImeService {
  static const _channel = MethodChannel('copycat/ime');

  ImeService._() {
    _channel.setMethodCallHandler(_handleNativeCall);
  }

  static final ImeService instance = ImeService._();

  final ValueNotifier<List<String>> supportedMimeTypes = ValueNotifier([]);
  final ValueNotifier<ImeActionType> activeAction =
      ValueNotifier(ImeActionType.newline);

  Future<dynamic> _handleNativeCall(MethodCall call) async {
    if (call.method == 'onEditorCapabilitiesChanged') {
      final args = call.arguments as Map<dynamic, dynamic>;
      final types = args['supportedMimeTypes'] as List?;
      if (types != null) {
        supportedMimeTypes.value = List<String>.from(types);
      }
      final actionStr = args['action'] as String?;
      if (actionStr != null) {
        activeAction.value =
            ImeActionType.values.asNameMap()[actionStr] ?? ImeActionType.newline;
      }
    }
  }

  /// Returns `true` when the active editor declared it can receive [mimeType].
  bool supportsContentType(String mimeType) {
    return supportedMimeTypes.value.any(
      (m) =>
          m == '*/*' ||
          m == mimeType ||
          (m.endsWith('*') && mimeType.startsWith(m.replaceAll('*', ''))),
    );
  }

  /// Commits [text] directly into the focused field via [InputConnection.commitText].
  Future<void> commitText(String text) =>
      _channel.invokeMethod<void>('commitText', {'text': text});

  /// Sends a file (image/GIF) to the focused field via the Android Commit Content API.
  ///
  /// The [filePath] must be an absolute path reachable by the app's [FileProvider].
  /// Falls back to [copyToClipboard] if the editor does not support [mimeType].
  Future<void> commitContent({
    required String filePath,
    required String mimeType,
    String label = 'Image',
  }) => _channel.invokeMethod<void>('commitContent', {
    'filePath': filePath,
    'mimeType': mimeType,
    'label': label,
  });

  /// Copies [text] to the Android system clipboard via the IME service.
  Future<void> copyToClipboard(String text, {String label = 'Clip'}) =>
      _channel.invokeMethod<void>('copyToClipboard', {
        'text': text,
        'label': label,
      });

  /// Requests the system to hide the soft keyboard.
  Future<void> hide() => _channel.invokeMethod<void>('hide');

  /// Deletes the character before the cursor, or the currently selected text.
  Future<void> deleteBackward() =>
      _channel.invokeMethod<void>('deleteBackward');

  /// Displays the system Input Method Picker dialog.
  Future<void> showInputMethodPicker() =>
      _channel.invokeMethod<void>('showInputMethodPicker');

  /// Executes the active editor's submit action or falls back to Enter.
  Future<void> performEditorAction() =>
      _channel.invokeMethod<void>('performEditorAction');
}
