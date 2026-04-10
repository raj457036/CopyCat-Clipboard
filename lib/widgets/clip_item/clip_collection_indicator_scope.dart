import 'package:flutter/widgets.dart';

class ClipCollectionIndicatorScope extends InheritedWidget {
  final bool enabled;

  const ClipCollectionIndicatorScope({
    super.key,
    required this.enabled,
    required super.child,
  });

  static bool enabledOf(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<ClipCollectionIndicatorScope>();
    return scope?.enabled ?? false;
  }

  @override
  bool updateShouldNotify(ClipCollectionIndicatorScope oldWidget) {
    return enabled != oldWidget.enabled;
  }
}
