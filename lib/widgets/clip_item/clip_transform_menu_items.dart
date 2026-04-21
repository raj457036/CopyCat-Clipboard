import 'dart:convert';

import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/offline_persistance_cubit/offline_persistance_cubit.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/services/analysis/code_text_analysis.dart';
import 'package:clipboard/base/domain/services/analysis/text_analysis.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/utils/clipboard_actions.dart';
import 'package:clipboard/utils/snackbar.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _TransformContext {
  final ClipboardItem item;
  final String text;
  final String trimmed;
  final bool isUrl;
  final bool isEmail;
  final bool isPhone;
  final bool isHexColor;
  final bool isRgbColor;
  final bool isStruct;
  final String? structuredKind;

  const _TransformContext({
    required this.item,
    required this.text,
    required this.trimmed,
    required this.isUrl,
    required this.isEmail,
    required this.isPhone,
    required this.isHexColor,
    required this.isRgbColor,
    required this.isStruct,
    required this.structuredKind,
  });

  bool get isUrlCategory => item.type == ClipItemType.url;
  bool get isColorCategory => item.textCategory == TextCategory.color;
  bool get isEmailCategory => item.textCategory == TextCategory.email;
  bool get isPhoneCategory => item.textCategory == TextCategory.phone;
  bool get isStructCategory => item.textCategory == TextCategory.struct;
  bool get isUncategorizedText =>
      item.type == ClipItemType.text && item.textCategory == null;

  static _TransformContext? fromItem(ClipboardItem item) {
    final raw = item.type == ClipItemType.url ? item.url : item.text;
    if (raw == null || raw.trim().isEmpty) return null;

    final trimmed = raw.trim();
    final isUrl = TextAnalysis.looksLikeUrl(trimmed);
    final isEmail = TextAnalysis.isEmail(trimmed);
    final isPhone = TextAnalysis.isPhoneLike(trimmed);
    final isHexColor = TextAnalysis.isHexColor(trimmed);
    final isRgbColor = TextAnalysis.isRgbColor(trimmed);
    final structuredKind = TextAnalysis.detectStructuredKind(trimmed);
    final isStruct =
        item.textCategory == TextCategory.struct || structuredKind != null;

    return _TransformContext(
      item: item,
      text: raw,
      trimmed: trimmed,
      isUrl: isUrl,
      isEmail: isEmail,
      isPhone: isPhone,
      isHexColor: isHexColor,
      isRgbColor: isRgbColor,
      isStruct: isStruct,
      structuredKind: structuredKind,
    );
  }
}

class _TransformAction {
  final String label;
  final String section;
  final IconData icon;
  final int priority;
  final bool Function(_TransformContext) when;
  final Future<void> Function(BuildContext, _TransformContext) run;

  const _TransformAction({
    required this.label,
    required this.section,
    required this.icon,
    required this.priority,
    required this.when,
    required this.run,
  });
}

String _titleCase(String input) {
  final words = input.split(RegExp(r'\s+'));
  return words
      .map(
        (w) => w.isEmpty
            ? w
            : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}',
      )
      .join(' ');
}

/// Replaces multiple spaces with a single space and trims
/// leading/trailing spaces.
String _normalizeSpaces(String input) =>
    input.replaceAll(RegExp(r'\s+'), ' ').trim();

/// Replaces line breaks with spaces.
String _removeLineBreaks(String input) =>
    input.replaceAll(RegExp(r'\r?\n+'), ' ');

/// Removes duplicate lines. If [sort] is true, also sorts
/// lines alphabetically.
String _dedupLines(String input, {bool sort = false}) {
  final seen = <String>{};
  final lines = input.split(RegExp(r'\r?\n'));
  final deduped = <String>[];
  for (final line in lines) {
    if (line.isEmpty) continue;
    if (seen.add(line)) deduped.add(line);
  }
  if (sort) deduped.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  return deduped.join('\n');
}

/// Strips common tracking parameters (e.g. utm_*) from URLs.
String _stripTrackingParams(String input) {
  final url = input.startsWith('http://') || input.startsWith('https://')
      ? input
      : 'https://$input';
  final uri = Uri.tryParse(url);
  if (uri == null) return input;
  final filtered = Map.of(uri.queryParameters)
    ..removeWhere((k, _) => k.toLowerCase().startsWith('utm_'));
  return uri
      .replace(queryParameters: filtered.isEmpty ? null : filtered)
      .toString();
}

/// Extracts the domain from a URL.
String _extractDomain(String input) {
  final url = input.startsWith('http://') || input.startsWith('https://')
      ? input
      : 'https://$input';
  final uri = Uri.tryParse(url);
  return uri?.host ?? input;
}

/// Converts a HEX color (e.g. #FF0000) to
/// RGB format (e.g. rgb(255, 0, 0)).
String _hexToRgb(String hex) {
  var v = hex.trim().replaceFirst('#', '');
  if (v.length == 3) {
    v = '${v[0]}${v[0]}${v[1]}${v[1]}${v[2]}${v[2]}';
  }
  final r = int.parse(v.substring(0, 2), radix: 16);
  final g = int.parse(v.substring(2, 4), radix: 16);
  final b = int.parse(v.substring(4, 6), radix: 16);
  return 'rgb($r, $g, $b)';
}

/// Converts an RGB color (e.g. rgb(255, 0, 0)) to
/// HEX format (e.g. #FF0000).
String _rgbToHex(String rgb) {
  final parsed = TextAnalysis.parseRgbColor(rgb);
  if (parsed == null) return rgb;
  final r = parsed.r;
  final g = parsed.g;
  final b = parsed.b;
  String toHex(int n) =>
      n.clamp(0, 255).toRadixString(16).padLeft(2, '0').toUpperCase();
  return '#${toHex(r)}${toHex(g)}${toHex(b)}';
}

/// Converts a HEX color to HSL format (e.g. hsl(0, 100%, 50%)).
String _hexToHsl(String hex) {
  var v = hex.trim().replaceFirst('#', '');
  if (v.length == 3) {
    v = '${v[0]}${v[0]}${v[1]}${v[1]}${v[2]}${v[2]}';
  }
  final r = int.parse(v.substring(0, 2), radix: 16) / 255.0;
  final g = int.parse(v.substring(2, 4), radix: 16) / 255.0;
  final b = int.parse(v.substring(4, 6), radix: 16) / 255.0;

  final maxVal = [r, g, b].reduce((a, b) => a > b ? a : b);
  final minVal = [r, g, b].reduce((a, b) => a < b ? a : b);
  final l = (maxVal + minVal) / 2;

  if (maxVal == minVal) {
    return 'hsl(0, 0%, ${(l * 100).round()}%)';
  }

  final d = maxVal - minVal;
  final s = l > 0.5 ? d / (2 - maxVal - minVal) : d / (maxVal + minVal);
  double h;
  if (maxVal == r) {
    h = ((g - b) / d + (g < b ? 6 : 0));
  } else if (maxVal == g) {
    h = ((b - r) / d + 2);
  } else {
    h = ((r - g) / d + 4);
  }
  h /= 6;
  return 'hsl(${(h * 360).round()}, ${(s * 100).round()}%, ${(l * 100).round()}%)';
}

/// Cleans an email or phone number by removing spaces,
/// dashes, and parentheses.
String _cleanEmailPhone(String input) =>
    input.replaceAll(RegExp(r'[\s\-()]'), '');

/// Handles copying or pasting the transformed result based on
Future<void> _copyOrPasteResult(
  BuildContext context,
  _TransformContext tx,
  String text,
  String label, {
  TextCategory? categoryOverride,
}) async {
  if (text.trim().isEmpty) {
    showTextSnackbar('No result for $label.', failure: true);
    return;
  }

  final transformed = ClipboardItem.fromText(
    text,
    sourceApp: tx.item.sourceApp,
    sourceUrl: tx.item.sourceUrl,
    category: categoryOverride ?? tx.item.textCategory,
  );

  final appConfig = context.read<AppConfigCubit>().state.config;
  final saveAsNewClip = appConfig.transformAsNewClip;

  if (saveAsNewClip) {
    await context.read<OfflinePersistenceCubit>().persist([transformed]);
    showTextSnackbar('Saved transformed clip as a new item.');
    return;
  }

  final canPaste = isDesktopPlatform
      ? appConfig.lastFocusedWindowId != null && appConfig.smartPaste
      : false;

  if (canPaste) {
    await pasteOnLastWindow(context, transformed);
    return;
  }
  await copyToClipboard(context, transformed, noAck: false);
}

List<_TransformAction> _definitions(ClipboardItem item) => [
  _TransformAction(
    label: 'Uppercase',
    section: 'Text Core',
    icon: Icons.keyboard_capslock_rounded,
    priority: 11,
    when: (_) => true,
    run: (context, tx) =>
        _copyOrPasteResult(context, tx, tx.text.toUpperCase(), 'Uppercase'),
  ),
  _TransformAction(
    label: 'Lowercase',
    section: 'Text Core',
    icon: Icons.text_fields_rounded,
    priority: 12,
    when: (_) => true,
    run: (context, tx) =>
        _copyOrPasteResult(context, tx, tx.text.toLowerCase(), 'Lowercase'),
  ),
  _TransformAction(
    label: 'Capitalize',
    section: 'Text Core',
    icon: Icons.title_rounded,
    priority: 13,
    when: (_) => true,
    run: (context, tx) =>
        _copyOrPasteResult(context, tx, _titleCase(tx.text), 'Title case'),
  ),
  _TransformAction(
    label: 'Trim whitespace',
    section: 'Text Core',
    icon: Icons.format_clear_rounded,
    priority: 14,
    when: (_) => true,
    run: (context, tx) =>
        _copyOrPasteResult(context, tx, tx.text.trim(), 'Trimmed text'),
  ),

  _TransformAction(
    label: 'Remove line breaks',
    section: 'Text Utilities',
    icon: Icons.wrap_text_rounded,
    priority: 20,
    when: (tx) => tx.text.contains('\n'),
    run: (context, tx) => _copyOrPasteResult(
      context,
      tx,
      _removeLineBreaks(tx.text),
      'Line breaks removed',
    ),
  ),
  _TransformAction(
    label: 'Normalize spaces',
    section: 'Text Utilities',
    icon: Icons.horizontal_distribute_rounded,
    priority: 21,
    when: (_) => true,
    run: (context, tx) => _copyOrPasteResult(
      context,
      tx,
      _normalizeSpaces(tx.text),
      'Normalized spaces',
    ),
  ),
  _TransformAction(
    label: 'Reverse text',
    section: 'Text Utilities',
    icon: Icons.swap_horiz_rounded,
    priority: 22,
    when: (_) => true,
    run: (context, tx) => _copyOrPasteResult(
      context,
      tx,
      tx.text.split('').reversed.join(),
      'Reversed text',
    ),
  ),
  _TransformAction(
    label: 'Deduplicate lines',
    section: 'Text Utilities',
    icon: Icons.content_copy_rounded,
    priority: 24,
    when: (tx) => tx.text.contains('\n'),
    run: (context, tx) => _copyOrPasteResult(
      context,
      tx,
      _dedupLines(tx.text),
      'Deduplicated lines',
    ),
  ),

  _TransformAction(
    label: 'JSON → prettify',
    section: 'Struct',
    icon: Icons.data_object_rounded,
    priority: 30,
    when: (tx) => tx.isStruct && tx.structuredKind == StructuredKind.json,
    run: (context, tx) async {
      final pretty = const JsonEncoder.withIndent(
        '  ',
      ).convert(jsonDecode(tx.text));
      await _copyOrPasteResult(context, tx, pretty, 'Prettified JSON');
    },
  ),
  _TransformAction(
    label: 'JSON → minify',
    section: 'Struct',
    icon: Icons.compress_rounded,
    priority: 31,
    when: (tx) => tx.isStruct && tx.structuredKind == StructuredKind.json,
    run: (context, tx) async {
      final min = jsonEncode(jsonDecode(tx.text));
      await _copyOrPasteResult(context, tx, min, 'Minified JSON');
    },
  ),
  _TransformAction(
    label: 'URL encode',
    section: 'Struct',
    icon: Icons.link_rounded,
    priority: 32,
    when: (_) => true,
    run: (context, tx) => _copyOrPasteResult(
      context,
      tx,
      Uri.encodeComponent(tx.text),
      'URL encoded',
    ),
  ),
  _TransformAction(
    label: 'URL decode',
    section: 'Struct',
    icon: Icons.link_off_rounded,
    priority: 33,
    when: (tx) => tx.text.contains('%'),
    run: (context, tx) => _copyOrPasteResult(
      context,
      tx,
      Uri.decodeComponent(tx.text),
      'URL decoded',
    ),
  ),
  _TransformAction(
    label: 'Base64 encode',
    section: 'Struct',
    icon: Icons.key_rounded,
    priority: 34,
    when: (_) => true,
    run: (context, tx) => _copyOrPasteResult(
      context,
      tx,
      base64Encode(utf8.encode(tx.text)),
      'Base64 encoded',
    ),
  ),
  _TransformAction(
    label: 'Base64 decode',
    section: 'Struct',
    icon: Icons.key_off_rounded,
    priority: 35,
    when: (tx) => RegExp(r'^[A-Za-z0-9+/\r\n=]+$').hasMatch(tx.trimmed),
    run: (context, tx) async {
      final decoded = utf8.decode(base64Decode(tx.trimmed));
      await _copyOrPasteResult(context, tx, decoded, 'Base64 decoded');
    },
  ),
  _TransformAction(
    label: 'Remove tracking params',
    section: 'URLs',
    icon: Icons.cleaning_services_rounded,
    priority: 41,
    when: (tx) => tx.isUrlCategory,
    run: (context, tx) => _copyOrPasteResult(
      context,
      tx,
      _stripTrackingParams(tx.trimmed),
      'URL without tracking params',
    ),
  ),
  _TransformAction(
    label: 'Extract domain',
    section: 'URLs',
    icon: Icons.domain_rounded,
    priority: 42,
    when: (tx) => tx.isUrlCategory,
    run: (context, tx) =>
        _copyOrPasteResult(context, tx, _extractDomain(tx.trimmed), 'Domain'),
  ),

  _TransformAction(
    label: 'HEX → RGB',
    section: 'Colors',
    icon: Icons.palette_outlined,
    priority: 50,
    when: (tx) => tx.isColorCategory && tx.isHexColor,
    run: (context, tx) =>
        _copyOrPasteResult(context, tx, _hexToRgb(tx.trimmed), 'RGB color'),
  ),
  _TransformAction(
    label: 'RGB → HEX',
    section: 'Colors',
    icon: Icons.palette_rounded,
    priority: 51,
    when: (tx) => tx.isColorCategory && tx.isRgbColor,
    run: (context, tx) =>
        _copyOrPasteResult(context, tx, _rgbToHex(tx.trimmed), 'HEX color'),
  ),
  _TransformAction(
    label: 'HEX → HSL',
    section: 'Colors',
    icon: Icons.format_paint_rounded,
    priority: 52,
    when: (tx) => tx.isColorCategory && tx.isHexColor,
    run: (context, tx) =>
        _copyOrPasteResult(context, tx, _hexToHsl(tx.trimmed), 'HSL color'),
  ),

  _TransformAction(
    label: 'Copy cleaned',
    section: 'Emails / Phones',
    icon: Icons.cleaning_services_outlined,
    priority: 60,
    when: (tx) => tx.isEmailCategory || tx.isPhoneCategory,
    run: (context, tx) => _copyOrPasteResult(
      context,
      tx,
      _cleanEmailPhone(tx.trimmed),
      'Cleaned value',
    ),
  ),

  _TransformAction(
    label: 'Extract emails',
    section: 'Structured Text',
    icon: Icons.email_rounded,
    priority: 70,
    when: (tx) {
      return tx.isUncategorizedText &&
          TextAnalysis.extractEmails(tx.text).isNotEmpty;
    },
    run: (context, tx) => _copyOrPasteResult(
      context,
      tx,
      TextAnalysis.extractEmails(tx.text).join('\n'),
      'Extracted emails',
      categoryOverride: TextCategory.email,
    ),
  ),
  _TransformAction(
    label: 'Extract URLs',
    section: 'Structured Text',
    icon: Icons.link_rounded,
    priority: 71,
    when: (tx) =>
        tx.isUncategorizedText && TextAnalysis.extractUrls(tx.text).isNotEmpty,
    run: (context, tx) => _copyOrPasteResult(
      context,
      tx,
      TextAnalysis.extractUrls(tx.text).join('\n'),
      'Extracted URLs',
    ),
  ),
  _TransformAction(
    label: 'Extract numbers',
    section: 'Structured Text',
    icon: Icons.pin_rounded,
    priority: 72,
    when: (tx) =>
        tx.isUncategorizedText &&
        TextAnalysis.extractNumbers(tx.text).isNotEmpty,
    run: (context, tx) => _copyOrPasteResult(
      context,
      tx,
      TextAnalysis.extractNumbers(tx.text).join('\n'),
      'Extracted numbers',
    ),
  ),
];

List<MenuItem> buildSmartTransformMenuItems(
  BuildContext context,
  ClipboardItem item,
) {
  final tx = _TransformContext.fromItem(item);
  if (tx == null) return const [];

  final definitions = _definitions(item).where((d) => d.when(tx)).toList()
    ..sort((a, b) => a.priority.compareTo(b.priority));

  return [
    for (final def in definitions)
      MenuItem(
        icon: def.icon,
        text: def.label,
        section: def.section,
        onPressed: () => def.run(context, tx),
      ),
  ];
}
