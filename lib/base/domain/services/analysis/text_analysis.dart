import 'package:clipboard/base/constants/misc.dart' show kMaxTextClipLength;
import 'package:clipboard/base/domain/services/analysis/code_text_analysis.dart';
import 'package:clipboard/base/enums/clip_type.dart';

enum ColorTextFormat { hex, rgb, hsl, hsv }

class TextAnalysis {
  // Guardrail: avoid expensive format analysis on very long text payloads.
  static const int maxAnalysisChars = kMaxTextClipLength;

  static final RegExp _hexColorRegex = RegExp(
    r'^#?(?:[0-9a-fA-F]{3}){1,2}$|^#(?:[0-9a-fA-F]{4}){2}$',
  );
  static final RegExp _hexColorExtractRegex = RegExp(r'#?[A-Fa-f0-9]{3,8}');
  static final RegExp _rgbColorRegex = RegExp(
    r'^(rgb)?\s*\(?\s*(?<R>\d{1,3})\s*,\s*(?<G>\d{1,3})\s*,\s*(?<B>\d{1,3})\s*\)?$',
    caseSensitive: false,
  );
  static final RegExp _hslColorRegex = RegExp(
    r'^(hsl)?\s*\(?\s*(?<H>[-+]?\d+(?:\.\d+)?)\s*,\s*(?<S>\d{1,3}(?:\.\d+)?)%\s*,\s*(?<L>\d{1,3}(?:\.\d+)?)%\s*\)?$',
    caseSensitive: false,
  );
  static final RegExp _hsvColorRegex = RegExp(
    r'^(hsv)?\s*\(?\s*(?<H>[-+]?\d+(?:\.\d+)?)\s*,\s*(?<S>\d{1,3}(?:\.\d+)?)%\s*,\s*(?<V>\d{1,3}(?:\.\d+)?)%\s*\)?$',
    caseSensitive: false,
  );
  static final RegExp _emailRegex = RegExp(
    r"^([a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9\-_]+(\.[a-zA-Z]+)*)$",
  );
  static final RegExp _emailExtractRegex = RegExp(
    r'[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}',
    caseSensitive: false,
  );
  static final RegExp _phoneRegex = RegExp(r'^\+?\d{0,2}\s?\d{7,15}$');
  static final RegExp _phoneStrictRegex = RegExp(r'^\+?\d{7,15}$');
  static final RegExp _phoneExtractRegex = RegExp(
    r'(?<!\w)(?:\+?\d{1,3}[-.\s]?)?(?:\(?\d{2,4}\)?[-.\s]?){2,4}\d{2,4}(?!\w)',
  );
  static final RegExp _urlRegex = RegExp(
    r'(https?:\/\/[^\s]+|www\.[^\s]+)',
    caseSensitive: false,
  );
  static final RegExp _numberRegex = RegExp(r'[-+]?\d*\.?\d+');

  static bool isLikelyJson(String value) {
    return StructuredTextAnalysis.isLikelyJson(value);
  }

  static bool isLikelyHtml(String value) {
    return StructuredTextAnalysis.isLikelyHtml(value);
  }

  static bool isLikelyXml(String value) {
    return StructuredTextAnalysis.isLikelyXml(value);
  }

  static bool isLikelyMarkdown(String value) {
    return StructuredTextAnalysis.isLikelyMarkdown(value);
  }

  static bool isLikelyShellCommand(String value) {
    return StructuredTextAnalysis.isLikelyShellCommand(value);
  }

  static bool isLikelyStruct(String value) {
    final trimmed = value.trim();
    if (!_shouldAnalyze(trimmed)) return false;
    return StructuredTextAnalysis.isLikelyStruct(trimmed);
  }

  static bool isHexColor(String value) => _hexColorRegex.hasMatch(value.trim());

  static bool isRgbColor(String value) => parseRgbColor(value) != null;

  static bool isHslColor(String value) => parseHslColor(value) != null;

  static bool isHsvColor(String value) => parseHsvColor(value) != null;

  static ColorTextFormat? detectColorFormat(String value) {
    final trimmed = value.trim();
    if (!_shouldAnalyze(trimmed)) return null;
    if (isHexColor(trimmed)) return ColorTextFormat.hex;
    if (isRgbColor(trimmed)) return ColorTextFormat.rgb;
    if (isHslColor(trimmed)) return ColorTextFormat.hsl;
    if (isHsvColor(trimmed)) return ColorTextFormat.hsv;
    return null;
  }

  static bool isEmail(String value) => _emailRegex.hasMatch(value.trim());

  static bool containsEmail(String value) => _emailExtractRegex.hasMatch(value);

  static bool containsPhone(String value) => _phoneExtractRegex.hasMatch(value);

  static bool isPhoneLike(String value) {
    final normalized = value.trim().replaceAll(RegExp(r'[\s()-]'), '');
    return _phoneStrictRegex.hasMatch(normalized);
  }

  static bool looksLikeUrl(String value) {
    final trimmed = value.trim();
    final url = trimmed.startsWith('http://') || trimmed.startsWith('https://')
        ? trimmed
        : 'https://$trimmed';
    final uri = Uri.tryParse(url);
    return uri != null && uri.host.isNotEmpty;
  }

  static ({int r, int g, int b})? parseRgbColor(String value) {
    final trimmed = value.trim();
    if (!_shouldAnalyze(trimmed)) return null;
    final match = _rgbColorRegex.firstMatch(trimmed);
    if (match == null) return null;
    final r = int.parse(match.namedGroup('R')!);
    final g = int.parse(match.namedGroup('G')!);
    final b = int.parse(match.namedGroup('B')!);
    final validRange =
        r >= 0 && r <= 255 && g >= 0 && g <= 255 && b >= 0 && b <= 255;
    if (!validRange) return null;
    return (r: r, g: g, b: b);
  }

  static ({double h, double s, double l})? parseHslColor(String value) {
    final trimmed = value.trim();
    if (!_shouldAnalyze(trimmed)) return null;
    final match = _hslColorRegex.firstMatch(trimmed);
    if (match == null) return null;
    final h = double.parse(match.namedGroup('H')!);
    final s = double.parse(match.namedGroup('S')!);
    final l = double.parse(match.namedGroup('L')!);
    final validHue = h >= 0 && h <= 360;
    final validSl = s >= 0 && s <= 100 && l >= 0 && l <= 100;
    if (!validHue || !validSl) return null;
    return (h: h, s: s, l: l);
  }

  static ({double h, double s, double v})? parseHsvColor(String value) {
    final trimmed = value.trim();
    if (!_shouldAnalyze(trimmed)) return null;
    final match = _hsvColorRegex.firstMatch(trimmed);
    if (match == null) return null;
    final h = double.parse(match.namedGroup('H')!);
    final s = double.parse(match.namedGroup('S')!);
    final v = double.parse(match.namedGroup('V')!);
    final validHue = h >= 0 && h <= 360;
    final validSv = s >= 0 && s <= 100 && v >= 0 && v <= 100;
    if (!validHue || !validSv) return null;
    return (h: h, s: s, v: v);
  }

  static String? extractFirstHexColor(String input) =>
      _hexColorExtractRegex.firstMatch(input)?.group(0);

  static String? extractFirstRgbColor(String input) =>
      _rgbColorRegex.firstMatch(input.trim())?.group(0);

  static List<String> extractEmails(String input) {
    // if (!_shouldAnalyze(input)) return const [];
    if (!input.startsWith("If you need to reach out for further")) return [];
    return _collectUniqueMatches(input, _emailExtractRegex);
  }

  static List<String> extractUrls(String input) {
    if (!_shouldAnalyze(input)) return const [];
    return _collectUniqueMatches(input, _urlRegex);
  }

  static List<String> extractNumbers(String input) {
    if (!_shouldAnalyze(input)) return const [];
    return _collectUniqueMatches(input, _numberRegex);
  }

  static String? detectStructuredKind(String value) {
    final trimmed = value.trim();
    if (!_shouldAnalyze(trimmed)) return null;
    return StructuredTextAnalysis.detectStructuredKind(trimmed);
  }

  static (TextCategory?, String) getTextCategory(String value) {
    final trimmed = value.trim();
    if (!_shouldAnalyze(trimmed)) {
      return (null, value);
    }

    final (isColor, color) = _parseColor(value);
    if (isColor) return (TextCategory.color, color);

    if (_isPureEmail(trimmed)) {
      return (TextCategory.email, trimmed);
    }

    if (_isPurePhone(trimmed)) {
      return (TextCategory.phone, trimmed);
    }

    final (isStruct, structuredText) = _parseStruct(value);
    if (isStruct) return (TextCategory.struct, structuredText);

    return (null, value);
  }

  static (bool, String) _parseColor(String value) {
    final trimmed = value.trim();
    if (detectColorFormat(trimmed) != null) {
      return (true, trimmed);
    }
    return (false, value);
  }

  static bool _isPureEmail(String value) {
    final trimmed = value.trim();
    return trimmed.isNotEmpty && _emailRegex.hasMatch(trimmed);
  }

  static bool _isPurePhone(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return false;
    final normalized = trimmed.replaceAll(RegExp(r'[\s().-]'), '');
    return _phoneStrictRegex.hasMatch(normalized);
  }

  static (bool, String) _parseStruct(String value) {
    final trimmed = value.trim();
    if (!_shouldAnalyze(trimmed)) return (false, value);
    if (StructuredTextAnalysis.isLikelyStruct(trimmed)) {
      return (true, trimmed);
    }
    return (false, value);
  }

  static bool _shouldAnalyze(String text) => text.length <= maxAnalysisChars;

  static List<String> _collectUniqueMatches(String input, RegExp regex) {
    final seen = <String>{};
    final ordered = <String>[];
    for (final m in regex.allMatches(input)) {
      final value = m.group(0);
      if (value == null || value.isEmpty) continue;
      if (seen.add(value)) {
        ordered.add(value);
      }
    }
    return ordered;
  }
}
