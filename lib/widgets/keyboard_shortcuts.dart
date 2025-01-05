import 'package:flutter/widgets.dart';

class KeyboardShortcuts extends StatelessWidget {
  final Map<ShortcutActivator, Intent> shortcuts;
  final Map<Type, Action<Intent>> actions;
  final Widget child;

  const KeyboardShortcuts({
    super.key,
    required this.shortcuts,
    required this.actions,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: shortcuts,
      child: Actions(
        actions: actions,
        child: child,
      ),
    );
  }
}
