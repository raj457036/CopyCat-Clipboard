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
  const CollectionFilterChips({super.key});

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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: padding8),
                      child: Row(
                        spacing: padding4,
                        children: [
                          if (!dense)
                            _CreateCollectionChip(canCreate: canCreate),
                          if (!dense)
                            const VerticalDivider(
                              indent: padding14,
                              endIndent: padding14,
                            ),
                          Expanded(
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                vertical: padding8,
                              ),
                              itemCount: itemLength,
                              separatorBuilder: (_, _) => width8,
                              itemBuilder: (context, index) {
                                if (dense && index == 0) {
                                  return _CreateCollectionChip(
                                    canCreate: canCreate,
                                  );
                                }
                                final i = dense ? index - 1 : index;
                                final collection = collections[i];
                                final isReadOnly = loaded.isReadOnly(
                                  collection,
                                );
                                return _CollectionChip(
                                  collection: collection,
                                  isSelected: activeId == collection.id,
                                  isReadOnly: isReadOnly,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
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

class _CreateCollectionChip extends StatelessWidget {
  final bool canCreate;

  const _CreateCollectionChip({required this.canCreate});

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
      child: ActionChip.elevated(
        avatar: const Icon(Icons.add_rounded),
        color: canCreate ? context.colors.onPrimary.msp : null,
        backgroundColor: canCreate ? context.colors.primary : null,
        shape: const StadiumBorder(),
        label: Text(context.locale.app__create),
        onPressed: () => _onCreate(context),
        mouseCursor: SystemMouseCursors.click,
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
        shape: isSelected ? const StadiumBorder() : null,
        showCheckmark: false,
        mouseCursor: SystemMouseCursors.click,
      ),
    );
  }
}
