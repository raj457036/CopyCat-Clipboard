import 'package:flutter/material.dart';

class ClipPreviewConfig extends InheritedWidget {
  final ShapeBorder? shape;

  const ClipPreviewConfig({super.key, required super.child, this.shape});

  static ClipPreviewConfig? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ClipPreviewConfig>();
  }

  @override
  bool updateShouldNotify(ClipPreviewConfig oldWidget) {
    return true;
  }
}
