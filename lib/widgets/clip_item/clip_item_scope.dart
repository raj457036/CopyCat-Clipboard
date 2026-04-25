import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:flutter/material.dart';

/// Provides ClipboardItem context-wide to avoid prop drilling
class ClipItemScope extends InheritedWidget {
  final ClipboardItem item;

  const ClipItemScope({super.key, required this.item, required super.child});

  static ClipboardItem of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ClipItemScope>()!.item;
  }

  @override
  bool updateShouldNotify(ClipItemScope oldWidget) => oldWidget.item != item;
}
