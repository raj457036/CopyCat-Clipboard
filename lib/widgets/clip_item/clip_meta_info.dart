import 'package:flutter/widgets.dart';

class ClipMetaInfo extends InheritedWidget {
  final int index;

  const ClipMetaInfo({
    super.key,
    required super.child,
    required this.index,
  });

  static ClipMetaInfo? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ClipMetaInfo>();
  }

  @override
  bool updateShouldNotify(ClipMetaInfo oldWidget) {
    return true;
  }
}
