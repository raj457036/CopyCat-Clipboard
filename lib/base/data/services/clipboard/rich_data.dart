import 'dart:convert' show jsonDecode, jsonEncode, utf8;

import 'package:clipboard/base/constants/misc.dart';
import 'package:clipboard/base/data/services/clipboard/clip_models.dart';
import 'package:clipboard/base/data/services/clipboard/format_processor.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/common/logging.dart';
import 'package:super_clipboard/super_clipboard.dart';

// MIME type constants for rich text formats.
// Add or remove entries here to change which formats are captured/restored.
const kMimeHtml = 'text/html';
const kMimeMarkdown = 'text/markdown';
const kMimeMarkdownAlt = 'text/x-markdown';
const kMimeRtf = 'text/rtf';
const kMimeRtfAlt = 'application/rtf';

/// Controls how rich text is written back to the clipboard on paste.
enum TextPasteFormat {
  /// Write HTML when available, plain text as fallback.
  auto,

  /// Always write plain text, ignoring any stored rich format.
  plainText,

  /// Write rich text + plain text, preferring Rich data when available.
  richText,
}

const _markdownFormat = SimpleValueFormat<String>(
  fallback: SimplePlatformCodec<String>(
    formats: [kMimeMarkdown, kMimeMarkdownAlt],
    onDecode: _decodeClipboardTextValue,
  ),
);

const _rtfFormat = SimpleValueFormat<String>(
  fallback: SimplePlatformCodec<String>(
    formats: [kMimeRtf, kMimeRtfAlt],
    onDecode: _decodeClipboardTextValue,
  ),
);

Future<String?> _decodeClipboardTextValue(
  PlatformDataProvider dataProvider,
  PlatformFormat format,
) async {
  final value = await dataProvider.getData(format);
  if (value is String) return value;
  if (value is List<int>) {
    return utf8.decode(value, allowMalformed: true);
  }
  return null;
}

class RichDataPayload {
  RichDataPayload(this.byMime);

  final Map<String, String> byMime;

  bool get isEmpty => byMime.isEmpty;

  bool has(String mime) =>
      byMime.containsKey(mime) && byMime[mime]!.trim().isNotEmpty;

  String? get(String mime) => byMime[mime];

  void put(String mime, String value) {
    if (value.trim().isEmpty) return;
    byMime[mime] = value;
  }

  String toJsonString() => jsonEncode({'v': 1, 'formats': byMime});

  static RichDataPayload fromJsonString(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return RichDataPayload({});
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        final formatsRaw = decoded['formats'];
        if (formatsRaw is Map) {
          final values = <String, String>{};
          for (final entry in formatsRaw.entries) {
            final key = entry.key;
            final value = entry.value;
            if (key is String && value is String && value.trim().isNotEmpty) {
              values[key] = value;
            }
          }
          return RichDataPayload(values);
        }
      }
    } catch (_) {
      // Invalid payload; ignore silently.
    }

    return RichDataPayload({});
  }
}

/// Captures and restores rich text formats into a single JSON payload.
class RichTextDataHandler {
  static const _formatReaders = <(String, ValueFormat<String>)>[
    (kMimeHtml, Formats.htmlText),
    (kMimeMarkdown, _markdownFormat),
    (kMimeRtf, _rtfFormat),
  ];

  bool supportsCapture(ClipItem clip) {
    final text = clip.text;
    return clip.type == ClipItemType.text && text != null && text.isNotEmpty;
  }

  Future<void> capture({
    required DataReader reader,
    required ClipItem clip,
    required ClipboardFormatProcessor processor,
  }) async {
    final plainText = clip.text;
    if (plainText == null || plainText.isEmpty) return;

    final payload = RichDataPayload.fromJsonString(clip.richData);

    for (final (mime, format) in _formatReaders) {
      String? value;
      try {
        value = await processor.readValue(reader, format);
      } catch (_) {
        value = null;
      }

      if (value == null || value.trim().isEmpty) continue;

      final entrySize = utf8.encode(value).length;
      if (entrySize > kRichClipboardDataMaxBytes) {
        logger.d(
          () =>
              "[RichDataPayload] Rich payload for $mime dropped: size $entrySize exceeds "
              "max $kRichClipboardDataMaxBytes bytes",
        );
        continue;
      }

      payload.put(mime, value);
    }

    if (payload.isEmpty) return;

    final encoded = payload.toJsonString();
    final payloadSize = utf8.encode(encoded).length;
    if (payloadSize > kRichClipboardDataMaxBytes) {
      logger.w(
        "Rich payload dropped: size $payloadSize exceeds "
        "max $kRichClipboardDataMaxBytes bytes",
      );
      return;
    }

    clip.richData = encoded;
  }

  bool writeRich({
    required List<DataWriterItem> sink,
    required String text,
    required String? richData,
    required TextPasteFormat mode,
  }) {
    if (mode == TextPasteFormat.plainText) return false;

    final payload = RichDataPayload.fromJsonString(richData);
    if (payload.isEmpty) return false;

    final item = DataWriterItem(suggestedName: 'Text');
    bool addedAny = false;

    if (mode == TextPasteFormat.richText) {
      final html = payload.get(kMimeHtml);
      if (html == null) return false;
      item.add(Formats.htmlText(html));
      addedAny = true;
    } else {
      // Auto mode: write every captured format so the destination app can
      // choose the one it understands best (html, markdown, rtf).
      for (final mime in const [kMimeHtml, kMimeMarkdown, kMimeRtf]) {
        final value = payload.get(mime);
        if (value == null) continue;
        switch (mime) {
          case kMimeHtml:
            item.add(Formats.htmlText(value));
          case kMimeMarkdown:
            item.add(_markdownFormat(value));
          case kMimeRtf:
            item.add(_rtfFormat(value));
        }
        addedAny = true;
      }
    }

    if (!addedAny) return false;

    item.add(Formats.plainText(text));
    sink.add(item);
    return true;
  }
}
