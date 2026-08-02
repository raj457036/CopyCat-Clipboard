import 'package:clipboard/base/bloc/clip_collection_cubit/clip_collection_cubit.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/data/services/notification_service.dart';
import 'package:clipboard/base/domain/model/notification_message.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/clip_collection_grid_item.dart';
import 'package:clipboard/widgets/no_collection.dart';
import 'package:clipboard/widgets/yarn_ball_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CollectionSelectionGrid extends StatelessWidget {
  final int? selectedCollectionId;

  /// When true, a "Create new collection" card is prepended as the first grid
  /// item so users can create a collection without leaving the sheet.
  final bool showCreateItem;

  const CollectionSelectionGrid({
    super.key,
    this.selectedCollectionId,
    this.showCreateItem = false,
  });

  void _notifyReadOnly(BuildContext context, int? collectionId) {
    InAppNotificationService.i.notify(
      NotificationMessage.builder(
        builder: (context) => NotificationContent(
          body: context.locale.collections__read_only__toast,
        ),
        id: 'upgrade-collection-$collectionId',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClipCollectionCubit, ClipCollectionState>(
      builder: (context, state) {
        switch (state) {
          case ClipCollectionLoaded(loading: true):
            return const Center(child: YarnBallLoading());
          case ClipCollectionLoaded(
            :final failure,
            :final collections,
            :final activeLimit,
          ):
            {
              if (failure != null) {
                return Center(child: Text(failure.message));
              }
              if (collections.isEmpty && !showCreateItem) {
                return const NoCollectionAvailable();
              }

              final extraCount = showCreateItem ? 1 : 0;

              return GridView.builder(
                scrollCacheExtent: const ScrollCacheExtent.pixels(300),
                padding: const EdgeInsets.all(padding10),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 380,
                  childAspectRatio: 16 / 9,
                  mainAxisExtent: 100,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: collections.length + extraCount,
                itemBuilder: (context, index) {
                  if (showCreateItem && index == 0) {
                    return const _CreateNewCollectionItem();
                  }

                  final collectionIndex = index - extraCount;
                  final collection = collections[collectionIndex];
                  final isReadOnly = collectionIndex >= activeLimit;

                  return ClipCollectionGridItem(
                    collection: collection,
                    autofocus:
                        collection.id == selectedCollectionId ||
                        (!showCreateItem &&
                            collectionIndex == 0 &&
                            isDesktopPlatform),
                    isReadOnly: isReadOnly,
                    onTap: isReadOnly
                        ? () => _notifyReadOnly(context, collection.id)
                        : () => context.pop(collection),
                  );
                },
              );
            }
        }
      },
    );
  }
}

class _CreateNewCollectionItem extends StatelessWidget {
  const _CreateNewCollectionItem();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    final focusedShape = RoundedRectangleBorder(
      side: BorderSide(
        color: colors.primary,
        width: 2.5,
        strokeAlign: BorderSide.strokeAlignOutside,
      ),
      borderRadius: radius12,
    );

    var focused = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return Card.outlined(
          margin: EdgeInsets.zero,
          shape: focused ? focusedShape : null,
          child: InkWell(
            mouseCursor: SystemMouseCursors.click,
            borderRadius: radius12,
            onFocusChange: (isFocused) {
              setState(() => focused = isFocused);
              if (isFocused) {
                Scrollable.ensureVisible(
                  context,
                  duration: Durations.medium1,
                  curve: Curves.easeOutCubic,
                  alignmentPolicy:
                      ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
                );
              }
            },
            onTap: () => context.pushNamed(
              RouteConstants.createEditCollection,
              pathParameters: {"id": "new"},
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_circle_outline_rounded,
                  size: 28,
                  color: colors.primary,
                ),
                height6,
                Text(
                  context.locale.collections__appbar__title__create,
                  style: textTheme.labelMedium?.copyWith(color: colors.primary),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
