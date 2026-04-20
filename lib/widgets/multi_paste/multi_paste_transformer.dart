import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';

class MultiPasteTransformer {
  static List<ClipboardItem> mergeConsecutiveTextClips(
    List<ClipboardItem> items, {
    String? separator,
  }) {
    if (separator == null) return items;

    final merged = <ClipboardItem>[];
    final pendingText = <ClipboardItem>[];

    void flushPendingText() {
      if (pendingText.isEmpty) return;
      if (pendingText.length == 1) {
        merged.add(pendingText.first);
      } else {
        final text = pendingText
            .map(_getTextPayload)
            .whereType<String>()
            .join(separator);
        final first = pendingText.first;
        merged.add(
          ClipboardItem.fromText(
            text,
            sourceApp: first.sourceApp,
            sourceUrl: first.sourceUrl,
            category: first.textCategory,
          ),
        );
      }
      pendingText.clear();
    }

    for (final item in items) {
      if (_isTextLike(item)) {
        pendingText.add(item);
      } else {
        flushPendingText();
        merged.add(item);
      }
    }

    flushPendingText();
    return merged;
  }

  static bool _isTextLike(ClipboardItem item) {
    if (!item.isTextType) return false;
    final text = _getTextPayload(item);
    return text != null;
  }

  static String? _getTextPayload(ClipboardItem item) {
    final value = (item.text ?? item.url)?.trim();
    if (value == null || value.isEmpty) return null;
    return value;
  }
}
