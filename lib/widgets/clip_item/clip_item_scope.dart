import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:flutter/material.dart';

class ClipItemScope extends InheritedWidget {
  final ClipboardItem item;
  final Color? collectionColor;

  const ClipItemScope({
    super.key,
    required this.item,
    required super.child,
    this.collectionColor,
  });

  static ClipItemScope _scopeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ClipItemScope>()!;
  }

  static ClipboardItem of(BuildContext context) => _scopeOf(context).item;

  static Color? collectionColorOf(BuildContext context) =>
      _scopeOf(context).collectionColor;

  @override
  bool updateShouldNotify(ClipItemScope oldWidget) =>
      oldWidget.item != item || oldWidget.collectionColor != collectionColor;
}
