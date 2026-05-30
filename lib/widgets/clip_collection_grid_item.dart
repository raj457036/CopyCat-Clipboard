import 'package:clipboard/base/bloc/clip_collection_cubit/clip_collection_cubit.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/clip_collection/clipcollection.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/dialogs/confirm_dialog.dart';
import 'package:clipboard/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ClipCollectionGridItem extends StatefulWidget {
  final ClipCollection collection;
  final bool autoFocus;
  final VoidCallback? onTap;
  final bool selectionOnly;
  final bool isReadOnly;

  const ClipCollectionGridItem({
    super.key,
    this.autoFocus = false,
    this.onTap,
    this.selectionOnly = false,
    this.isReadOnly = false,
    required this.collection,
  });

  @override
  State<ClipCollectionGridItem> createState() => _ClipCollectionGridItemState();
}

class _ClipCollectionGridItemState extends State<ClipCollectionGridItem> {
  bool isFocused = false;

  void edit(BuildContext context) {
    context.pushNamed(
      RouteConstants.createEditCollection,
      pathParameters: {"id": widget.collection.id.toString()},
    );
  }

  Future<void> deleteCollection(BuildContext context) async {
    final cubit = context.read<ClipCollectionCubit>();
    final confirm = await ConfirmDialog(
      title: context.locale.dialog__delete_collection__title(
        collectionName: widget.collection.title,
      ),
      message: context.locale.dialog__delete_collection__subtitle,
    ).show(context);
    if (!confirm) return;
    cubit.delete(widget.collection);
  }

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
    final collectionTile = Builder(
      builder: (context) {
        return Card.outlined(
          color: widget.isReadOnly
              ? colors.surfaceContainerLowest
              : colors.surface,
          margin: EdgeInsets.zero,
          shape: isFocused ? selectedShape : null,
          elevation: isFocused ? 4 : 0,
          child: InkWell(
            focusColor: context.colors.secondaryContainer.withValues(
              alpha: 0.5,
            ),
            mouseCursor: SystemMouseCursors.click,
            borderRadius: radius8,
            onSecondaryTapUp: widget.selectionOnly
                ? null
                : (detail) {
                    Menu.of(
                      context,
                    ).openPopupMenu(context, detail.globalPosition);
                  },
            onFocusChange: (focused) {
              // setState(() => isFocused = focused);
              Scrollable.ensureVisible(
                context,
                duration: Durations.medium1,
                curve: Curves.easeOutCubic,
                alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
              );
            },
            autofocus: widget.autoFocus,
            onLongPress: widget.selectionOnly
                ? null
                : () => Menu.of(context).openMenu(context),
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
                    Text(
                      widget.collection.emoji,
                      style: textTheme.displaySmall,
                    ),
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
      },
    );

    if (widget.selectionOnly) return collectionTile;

    return Menu(
      items: [
        if (!widget.isReadOnly)
          MenuItem(
            icon: Icons.edit,
            text: context.locale.app__edit,
            onPressed: () => edit(context),
          ),
        MenuItem(
          icon: Icons.delete,
          text: context.locale.app__delete,
          onPressed: () => deleteCollection(context),
        ),
      ],
      child: collectionTile,
    );
  }
}
