import 'package:clipboard/base/constants/misc.dart';
import 'package:super_clipboard/super_clipboard.dart';

/// Simple format selector used by clipboard capture and drag-drop.
///
/// Behavior:
/// - Prefer common stable formats first.
/// - If none match, still accept the first available supported format.
///
/// This keeps capture deterministic without hard-filtering unknown formats.
class SimpleClipboardReadStrategy {
  const SimpleClipboardReadStrategy();

  static final List<DataFormat> _preferredOrder = <DataFormat>[
    Formats.fileUri,
    Formats.uri,
    Formats.plainText,
    Formats.plainTextFile,
    avif,
    Formats.png,
    Formats.jpeg,
    Formats.gif,
    Formats.tiff,
    Formats.webp,
    Formats.heic,
    Formats.bmp,
    svg,
  ];

  DataFormat<Object>? selectFromItemFormats(List<DataFormat> itemFormats) {
    if (itemFormats.isEmpty) return null;

    for (final preferred in _preferredOrder) {
      if (itemFormats.contains(preferred)) {
        return preferred;
      }
    }

    return itemFormats.first;
  }

  List<(DataReader, DataFormat<Object>)> selectReaders({
    required ClipboardReader reader,
    required List<DataFormat> supportedFormats,
  }) {
    final records = <(DataReader, DataFormat<Object>)>[];
    for (final item in reader.items) {
      final itemFormats = item.getFormats(supportedFormats);
      final selected = selectFromItemFormats(itemFormats);
      if (selected != null) {
        records.add((item, selected));
      }
    }
    return records;
  }
}
