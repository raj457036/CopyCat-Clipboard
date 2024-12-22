import 'package:copycat_base/constants/strings/route_constants.dart';
import 'package:copycat_base/db/clipboard_item/clipboard_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TertiaryActionButton extends StatelessWidget {
  final ClipboardItem item;
  final bool hovered;

  const TertiaryActionButton({
    super.key,
    required this.item,
    required this.hovered,
  });

  Future<void> editClip(BuildContext context) async {
    context.pushNamed(RouteConstants.preview, pathParameters: {
      "id": item.id.toString(),
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!hovered) return SizedBox.shrink();
    return SizedBox.square(
      dimension: 36,
      child: IconButton(
        onPressed: () => editClip(context),
        iconSize: 22,
        icon: Icon(Icons.edit),
      ),
    );
  }
}
