import 'package:flutter/widgets.dart';

class InBackgroundState extends InheritedWidget {
  final bool inBackground;

  const InBackgroundState({
    super.key,
    required super.child,
    required this.inBackground,
  });

  static InBackgroundState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InBackgroundState>();
  }

  @override
  bool updateShouldNotify(InBackgroundState oldWidget) {
    return true;
  }
}
