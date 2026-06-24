import 'package:clipboard/base/bloc/clip_collection_cubit/clip_collection_cubit.dart';
import 'package:clipboard/base/bloc/clipboard_cubit/clipboard_cubit.dart';
import 'package:clipboard/base/constants/numbers/values.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/clip_collection/clipcollection.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/subscription_actions.dart';
import 'package:clipboard/widgets/subscription/subscription_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CollectionFilterChips extends StatelessWidget {
  final bool placedInBottomNavBar;

  const CollectionFilterChips({super.key, this.placedInBottomNavBar = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClipCollectionCubit, ClipCollectionState>(
      builder: (context, collectionState) {
        final loaded = collectionState.mapOrNull(loaded: (s) => s);
        if (loaded == null || loaded.collections.isEmpty) {
          return const SizedBox.shrink();
        }

        final collections = loaded.collections;

        return BlocBuilder<ClipboardCubit, ClipboardState>(
          buildWhen: (prev, next) =>
              prev.filterState.collectionId != next.filterState.collectionId,
          builder: (context, clipboardState) {
            final activeId = clipboardState.filterState.collectionId;
            final colorScheme = context.colors;

            return SubscriptionBuilder(
              builder: (context, subscription) {
                final limit =
                    subscription?.collections ?? defaultCollectionCount;
                final canCreate = limit > collections.length;
                final dense = context.isMobile;
                final itemLength = dense
                    ? collections.length + 1
                    : collections.length;

                final row = Row(
                  spacing: padding4,
                  children: [
                    if (!dense) _CreateCollectionButton(canCreate: canCreate),
                    if (!dense)
                      const VerticalDivider(
                        indent: padding14,
                        endIndent: padding14,
                      ),
                    Expanded(
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: placedInBottomNavBar
                            ? const EdgeInsets.symmetric(
                                horizontal: padding16,
                                vertical: padding2,
                              )
                            : const EdgeInsets.symmetric(vertical: padding8),
                        itemCount: itemLength,
                        separatorBuilder: (_, _) => width8,
                        itemBuilder: (context, index) {
                          if (dense && index == 0) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: _CreateCollectionButton(
                                canCreate: canCreate,
                              ),
                            );
                          }
                          final i = dense ? index - 1 : index;
                          final collection = collections[i];
                          final isReadOnly = loaded.isReadOnly(collection);
                          return _CollectionChip(
                            collection: collection,
                            isSelected: activeId == collection.id,
                            isReadOnly: isReadOnly,
                          );
                        },
                      ),
                    ),
                  ],
                );

                final SingleChildRenderObjectWidget childWithPadding;
                if (placedInBottomNavBar) {
                  childWithPadding = DecoratedBox(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      border: Border(
                        top: BorderSide(color: colorScheme.outlineVariant),
                      ),
                    ),
                    child: row,
                  );
                } else {
                  childWithPadding = Padding(
                    padding: const EdgeInsets.symmetric(horizontal: padding8),
                    child: row,
                  );
                }

                return SizedBox(
                  height: 64,
                  child: ChipTheme(
                    data: ChipThemeData(
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      selectedColor: colorScheme.primaryContainer,
                      disabledColor: colorScheme.surfaceContainerLow,
                      side: BorderSide.none,
                      shape: const RoundedRectangleBorder(
                        borderRadius: radius4,
                      ),
                    ),
                    child: childWithPadding,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _CreateCollectionButton extends StatelessWidget {
  final bool canCreate;

  const _CreateCollectionButton({required this.canCreate});

  void _onCreate(BuildContext context) {
    if (!canCreate) {
      showUpgradePlanDialog();
      return;
    }
    context.pushNamed(
      RouteConstants.createEditCollection,
      pathParameters: {"id": "new"},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Badge(
      label: Text(context.locale.badges__label__pro),
      alignment: Alignment.topLeft,
      isLabelVisible: !canCreate,
      child: TextButton.icon(
        icon: const Icon(Icons.add_rounded),
        onPressed: () => _onCreate(context),
        style: TextButton.styleFrom(
          foregroundColor: context.colors.onSecondaryContainer,
          backgroundColor: context.colors.secondaryContainer,
          shape: const StadiumBorder(),
          enabledMouseCursor: SystemMouseCursors.click,
          disabledMouseCursor: SystemMouseCursors.forbidden,
        ),
        label: Text(context.locale.app__create),
      ),
    );
  }
}

class _CollectionChip extends StatelessWidget {
  final ClipCollection collection;
  final bool isSelected;
  final bool isReadOnly;

  const _CollectionChip({
    required this.collection,
    required this.isSelected,
    required this.isReadOnly,
  });

  void _onSelected(BuildContext context, bool selected) {
    final newId = selected ? collection.id : null;
    context.read<ClipboardCubit>().filterByCollection(newId);
  }

  @override
  Widget build(BuildContext context) {
    return TooltipTheme(
      data: const TooltipThemeData(constraints: BoxConstraints(maxWidth: 200)),
      child: ChoiceChip(
        avatar: isReadOnly
            ? const Icon(Icons.lock_outline_rounded, size: 16)
            : Text(collection.emoji),
        label: Text(collection.title),
        selected: isSelected,
        tooltip: collection.description,
        onSelected: (selected) => _onSelected(context, selected),
        shape: isSelected
            ? const StadiumBorder()
            : const RoundedRectangleBorder(borderRadius: radius8),
        showCheckmark: false,
        mouseCursor: SystemMouseCursors.click,
      ),
    );
  }
}
