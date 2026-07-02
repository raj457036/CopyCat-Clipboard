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
  return Text(text, maxLines: 8);
}

final Map<String, GenerationStrategyFunction> customGenerationStrategies = {
  "text/plain": _plainTextThumbnail,
};
