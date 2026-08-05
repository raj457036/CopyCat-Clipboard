import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:flutter/material.dart';
import 'package:thumbnailer/thumbnailer.dart';
import 'dart:convert' show utf8;

Future<Widget> _plainTextThumbnail(
  String? name,
  String mimeType,
  int? dataSize,
  DataResolvingFunction getData,
  double widgetSize,
  WidgetDecoration? widgetDecoration,
) async {
  final text = utf8.decode(await getData(), allowMalformed: true);
  if (name?.endsWith("full_view") ?? false) {
    return SelectableText(text);
  }
  return Padding(
    padding: const EdgeInsets.only(
      left: padding8,
      right: padding8,
      top: padding44,
    ),
    child: Text(
      text,
      maxLines: 14,
      style: const TextStyle(
        overflow: TextOverflow.ellipsis,
        fontVariations: [FontVariation.weight(400)],
        fontSize: 12,
      ),
    ),
  );
}

final Map<String, GenerationStrategyFunction> customGenerationStrategies = {
  "text/plain": _plainTextThumbnail,
};
