import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';

class TipTile extends StatelessWidget {
  final String? title;
  final String tip;
  final Color? bg;
  final Widget? icon;
  final Widget? trailing;

  const TipTile({
    super.key,
    this.title,
    required this.tip,
    this.bg,
    this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ListTile(
      leading: icon ?? const Icon(Icons.lightbulb, color: Colors.amber),
      title: Text(title ?? context.locale.app__pro_tip),
      subtitle: Text(tip),
      tileColor: bg ?? colors.secondaryContainer,
      trailing: trailing,
    );
  }
}
