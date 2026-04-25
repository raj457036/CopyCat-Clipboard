import 'package:clipboard/base/constants/misc.dart';
import 'package:super_clipboard/super_clipboard.dart';

/// Selects the best format from available clipboard formats.
/// Iterates through supported formats in priority order and returns the first match.
class SimpleClipboardReadStrategy {
  const SimpleClipboardReadStrategy();

  DataFormat<Object>? selectFromItemFormats(List<DataFormat> itemFormats) {
    if (itemFormats.isEmpty) return null;

    if (itemFormats.contains(Formats.fileUri)) {
      return Formats.fileUri;
    }

    for (final supportedFormat in allSupportedClipFormats) {
      if (supportedFormat is FileFormat &&
          itemFormats.contains(supportedFormat)) {
        return supportedFormat;
      }
    }

    if (itemFormats.contains(Formats.uri)) {
      return Formats.uri;
    }

    if (itemFormats.contains(Formats.htmlText)) {
      return Formats.htmlText;
    }

    if (itemFormats.contains(Formats.plainText)) {
      return Formats.plainText;
    }

    for (final supportedFormat in allSupportedClipFormats) {
      if (itemFormats.contains(supportedFormat)) {
        return supportedFormat;
      }
    }
    return null;
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
