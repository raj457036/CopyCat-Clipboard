import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GlobalKeyboardListener extends StatefulWidget {
  final Widget child;

  const GlobalKeyboardListener({super.key, required this.child});

  @override
  State<GlobalKeyboardListener> createState() => _GlobalKeyboardListenerState();
}

class _GlobalKeyboardListenerState extends State<GlobalKeyboardListener> {
  final focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void onKeyEvent(KeyEvent value) {
    if (value is! KeyUpEvent) return;
    print(value);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: focusNode,
      onKeyEvent: onKeyEvent,
      child: widget.child,
    );
  }
}
