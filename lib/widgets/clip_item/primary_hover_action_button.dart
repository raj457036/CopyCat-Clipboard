import 'package:clipboard/widgets/clip_item/clip_meta_info.dart';
import 'package:copycat_base/constants/strings/route_constants.dart';
import 'package:copycat_base/db/clipboard_item/clipboard_item.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrimaryHoverAction extends StatelessWidget {
  final ClipboardItem item;
  final bool hovered;

  const PrimaryHoverAction({
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
    final textTheme = context.textTheme;
    Widget child;
    if (!hovered) {
      final meta = ClipMetaInfo.of(context);
      if (meta == null) return const SizedBox.shrink();
      child = Center(
        child: Card.filled(
          margin: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: SizedBox.square(
            dimension: 20,
            child: Center(
              child: Text(
                meta.index.toString(),
                textAlign: TextAlign.center,
                style: textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      child = Focus(
        canRequestFocus: false,
        descendantsAreTraversable: false,
        child: IconButton(
          onPressed: () => editClip(context),
          iconSize: 22,
          icon: const Icon(Icons.edit),
        ),
      );
    }
    return SizedBox.square(
      dimension: 36,
      child: child,
    );
  }
}
