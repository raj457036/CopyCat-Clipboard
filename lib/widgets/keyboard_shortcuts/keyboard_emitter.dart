import 'package:flutter/material.dart';

class KeyboardEmitter extends StatefulWidget {
  final Widget child;
  const KeyboardEmitter({super.key, required this.child});

  @override
  State<KeyboardEmitter> createState() => _KeyboardEmitterState();
}

class _KeyboardEmitterState extends State<KeyboardEmitter> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
