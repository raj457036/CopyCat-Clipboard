import 'dart:convert';

class StructuredKind {
  static const json = 'JSON';
  static const xml = 'XML';
  static const html = 'HTML';
  static const markdown = 'Markdown';
  static const shell = 'Shell';
}

class StructuredTextAnalysis {
  static final RegExp _jsonLead = RegExp(r'^\s*[\[{]');
  static final RegExp _xmlOpen = RegExp(r'^<\?xml|^<\w+[\s/>]');
  static final RegExp _htmlHint = RegExp(r'<\s*\/?\w+[^>]*>');
  static final RegExp _markdownHint = RegExp(
    r'(^|\n)\s*(#{1,6}\s|[-*+]\s|\d+\.\s|>\s|```|\|.+\|)',
    multiLine: true,
  );

  static bool isLikelyStruct(String value) =>
      detectStructuredKind(value) != null;

  static String? detectStructuredKind(String value) {
    final text = value.trim();
    if (text.isEmpty) return null;

    if (isLikelyJson(text)) return StructuredKind.json;
    if (isLikelyXml(text)) return StructuredKind.xml;
    if (isLikelyHtml(text)) return StructuredKind.html;
    if (isLikelyMarkdown(text)) return StructuredKind.markdown;
    if (isLikelyShellCommand(text)) return StructuredKind.shell;

    return null;
  }

  static bool isLikelyJson(String value) {
    final text = value.trim();
    if (text.isEmpty || !_jsonLead.hasMatch(text)) return false;
    try {
      jsonDecode(text);
      return true;
    } catch (_) {
      return false;
    }
  }

  static bool isLikelyXml(String value) {
    final text = value.trim();
    if (text.isEmpty || !text.startsWith('<')) return false;
    // Must have XML declaration or valid root element
    if (!_xmlOpen.hasMatch(text)) return false;
    // Must end with closing tag
    if (!RegExp(r'>\s*$').hasMatch(text)) return false;
    // Must have matching opening/closing tags
    if (!RegExp(r'<\w+[^>]*>.*</\w+\s*>').hasMatch(text)) return false;
    return true;
  }

  static bool isLikelyHtml(String value) {
    final text = value.trim();
    if (text.length < 6) return false;
    return _htmlHint.hasMatch(text);
  }

  static bool isLikelyMarkdown(String value) {
    final text = value.trim();
    if (text.isEmpty) return false;
    return _markdownHint.hasMatch(text);
  }

  static bool isLikelyShellCommand(String value) {
    final text = value.trim();
    if (text.isEmpty) return false;
    return _scoreTerminalCmd(text) >= 3;
  }

  static int _scoreTerminalCmd(String s) {
    var score = 0;
    // Shebang is a strong indicator
    if (s.startsWith('#!/bin/bash') || s.startsWith('#!/bin/sh')) score += 3;
    if (s.startsWith('#!/usr/bin/env')) score += 2;
    // Common shell commands with proper spacing
    if (RegExp(
      r'(^|\n)\s*(echo|export|grep|awk|sed|chmod|ls|cat|rm|cp|mv|mkdir|cd|pwd|git|npm|yarn|dart|flutter|brew|apt|apt-get|docker|python|node)\s+',
    ).hasMatch(s)) {
      score += 2;
    }
    // Pipes, redirects, and logic operators
    if ((s.contains('|') || s.contains('&&') || s.contains('||')) &&
        (s.contains('\n') || s.contains(' '))) {
      score += 1;
    }
    // Variable expansion only counts with other indicators
    if ((s.contains(r'$(') || s.contains(r'${')) && score > 0) score += 1;
    return score;
  }
}
