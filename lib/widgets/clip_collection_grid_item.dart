import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/clip_collection/clipcollection.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClipCollectionGridItem extends StatefulWidget {
  final ClipCollection collection;
  final bool autofocus;
  final VoidCallback? onTap;
  final bool isReadOnly;

  const ClipCollectionGridItem({
    super.key,
    this.autofocus = false,
    this.onTap,
    this.isReadOnly = false,
    required this.collection,
  });

  @override
  State<ClipCollectionGridItem> createState() => _ClipCollectionGridItemState();
}

class _ClipCollectionGridItemState extends State<ClipCollectionGridItem> {
  bool isFocused = false;

  void showDetail(BuildContext context) {
    context.goNamed(
      RouteConstants.collectionDetail,
      pathParameters: {"id": widget.collection.id.toString()},
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;
    final selectedShape = RoundedRectangleBorder(
      side: BorderSide(
        color: colors.primary,
        width: 2,
        strokeAlign: BorderSide.strokeAlignOutside,
      ),
      borderRadius: radius8,
    );
    final menuOpen = Menu.maybeIsOpenOf(context) ?? false;
    final highlighted = isFocused || menuOpen;
    return Card.outlined(
      color: highlighted
          ? colors.surfaceContainerHigh
          : widget.isReadOnly
          ? colors.surfaceContainerLowest
          : colors.surface,
      margin: EdgeInsets.zero,
      shape: highlighted ? selectedShape : null,
      elevation: highlighted ? 4 : 0,
      child: InkWell(
        focusColor: context.colors.secondaryContainer.withValues(alpha: 0.5),
        mouseCursor: SystemMouseCursors.click,
        borderRadius: radius8,
        onSecondaryTapUp: (detail) {
          final menu = Menu.of(context);
          if (menu == null) return;
          menu.openPopupMenu(context, detail.globalPosition);
        },
        onFocusChange: (focused) async {
          await Scrollable.ensureVisible(
            context,
            duration: Durations.medium1,
            curve: Curves.easeOutCubic,
            alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
          );
          if (!mounted) return;
          setState(() => isFocused = focused);
        },
        autofocus: widget.autofocus,
        onLongPress: () {
          final menu = Menu.of(context);
          if (menu == null) return;
          menu.openMenu(context);
        },
        onTap: widget.onTap ?? () => showDetail(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: padding12,
            vertical: padding6,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.isReadOnly)
                Icon(
                  Icons.lock_outline_rounded,
                  size: 36,
                  color: colors.outline,
                )
              else
                Text(widget.collection.emoji, style: textTheme.displaySmall),
              width16,
              Expanded(
                child: Column(
                  spacing: 6,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        widget.collection.title,
                        maxLines: 1,
                        style: textTheme.titleMedium,
                      ),
                    ),
                    if (widget.collection.description != null)
                      Flexible(
                        child: Tooltip(
                          message: widget.collection.description!,
                          child: Text(
                            widget.collection.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium?.apply(
                              color: context.colors.outline,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
