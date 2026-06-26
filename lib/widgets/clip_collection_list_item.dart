import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/clip_collection/clipcollection.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClipCollectionListItem extends StatefulWidget {
  final ClipCollection collection;
  final bool autofocus;
  final VoidCallback? onTap;
  final bool isReadOnly;

  /// -1 = first
  /// 0 = middle
  /// 1 = last
  final int position;

  const ClipCollectionListItem({
    super.key,
    this.autofocus = false,
    this.onTap,
    this.isReadOnly = false,
    this.position = 0,
    required this.collection,
  });

  @override
  State<ClipCollectionListItem> createState() => _ClipCollectionListItemState();
}

class _ClipCollectionListItemState extends State<ClipCollectionListItem> {
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
    final menuOpen = Menu.maybeIsOpenOf(context) ?? false;
    final highlighted = isFocused || menuOpen;

    final selectedBorderSide = highlighted
        ? BorderSide(
            color: colors.primary,
            width: 2,
            strokeAlign: BorderSide.strokeAlignOutside,
          )
        : BorderSide.none;

    final RoundedRectangleBorder? shape;

    if (widget.position == -1) {
      shape = RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(12),
          bottom: Radius.circular(4),
        ),
        side: selectedBorderSide,
      );
    } else if (widget.position == 1) {
      shape = RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(4),
          bottom: Radius.circular(12),
        ),
        side: selectedBorderSide,
      );
    } else {
      shape = RoundedRectangleBorder(
        borderRadius: radius4,
        side: selectedBorderSide,
      );
    }

    return InkWell(
      onSecondaryTapUp: (detail) {
        final menu = Menu.of(context);
        if (menu == null) return;
        menu.openPopupMenu(context, detail.globalPosition);
      },
      onTap: widget.onTap ?? () => showDetail(context),
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
      mouseCursor: SystemMouseCursors.click,
      borderRadius: (shape.borderRadius as BorderRadius?) ?? BorderRadius.zero,
      autofocus: widget.autofocus,
      focusColor: context.colors.secondaryContainer.withValues(alpha: 0.5),
      child: ListTile(
        tileColor: colors.surfaceContainerLowest,
        shape: shape,
        enabled: false,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: padding12,
          vertical: padding6,
        ),

        leading: widget.isReadOnly
            ? Icon(Icons.lock_outline_rounded, size: 36, color: colors.outline)
            : Text(widget.collection.emoji, style: textTheme.displaySmall),
        title: Text(
          widget.collection.title,
          maxLines: 1,
          style: textTheme.titleMedium,
        ),
        mouseCursor: SystemMouseCursors.click,
        subtitle: widget.collection.description != null
            ? Text(
                widget.collection.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.apply(
                  color: context.colors.outline,
                ),
              )
            : null,
      ),
    );
  }
}
