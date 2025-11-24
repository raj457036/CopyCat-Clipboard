import 'package:clipboard/base/bloc/clip_collection_cubit/clip_collection_cubit.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/db/clip_collection/clipcollection.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/dialogs/confirm_dialog.dart';
import 'package:clipboard/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ClipCollectionGridItem extends StatelessWidget {
  final ClipCollection collection;
  final bool autoFocus;
  final VoidCallback? onTap;
  final bool selectionOnly;

  const ClipCollectionGridItem({
    super.key,
    this.autoFocus = false,
    this.onTap,
    this.selectionOnly = false,
    required this.collection,
  });

  void edit(BuildContext context) {
    context.pushNamed(
      RouteConstants.createEditCollection,
      pathParameters: {
        "id": collection.id.toString(),
      },
    );
  }

  Future<void> deleteCollection(BuildContext context) async {
    final cubit = context.read<ClipCollectionCubit>();
    final confirm = await ConfirmDialog(
      title: context.locale.dialog__delete_collection__title(
        collectionName: collection.title,
      ),
      message: context.locale.dialog__delete_collection__subtitle,
    ).show(context);
    if (!confirm) return;
    cubit.delete(collection);
  }

  void showDetail(BuildContext context) {
    context.goNamed(
      RouteConstants.collectionDetail,
      pathParameters: {
        "id": collection.id.toString(),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;
    var selected = false;
    final selectedShape = RoundedRectangleBorder(
      side: BorderSide(
        color: colors.primary,
        width: 2.5,
        strokeAlign: BorderSide.strokeAlignOutside,
      ),
      borderRadius: radius12,
    );
    final collectionTile = StatefulBuilder(builder: (context, setState) {
      return Card.outlined(
        color: colors.surface,
        margin: EdgeInsets.zero,
        shape: selected ? selectedShape : null,
        child: InkWell(
          borderRadius: radius12,
          onSecondaryTapDown: selectionOnly
              ? null
              : (detail) {
                  final position = detail.globalPosition;
                  Menu.of(context).openPopupMenu(context, position);
                },
          onFocusChange: (isFocused) {
            setState(() => selected = isFocused);
            Scrollable.ensureVisible(
              context,
              alignment: 0.5,
              duration: Durations.medium1,
              curve: Curves.easeOut,
            );
          },
          autofocus: autoFocus,
          onLongPress: selectionOnly
              ? null
              : () => Menu.of(context).openOptionBottomSheet(context),
          onTap: onTap ?? () => showDetail(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: padding12,
              vertical: padding6,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  collection.emoji,
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
                          collection.title,
                          maxLines: 1,
                          style: textTheme.titleMedium,
                        ),
                      ),
                      if (collection.description != null)
                        Flexible(
                          child: Text(
                            collection.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium?.apply(
                              color: context.colors.outline,
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
    });

    if (selectionOnly) return collectionTile;
    return Menu(
      items: [
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
