import 'package:clipboard/base/bloc/paste_stack_cubit/paste_stack_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/clip_item/clip_card/clip_card_body.dart'
    show ClipCardBodyContent;
import 'package:clipboard/widgets/clip_item/clip_card/hover_state_builder.dart';
import 'package:clipboard/widgets/clip_item/clip_item_scope.dart';
import 'package:clipboard/widgets/clips_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasteStackBody extends StatelessWidget {
  const PasteStackBody({super.key});

  static const _singleShape = RoundedRectangleBorder(borderRadius: radius2);
  static const _topShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(8),
      bottom: Radius.circular(2),
    ),
  );
  static const _bottomShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(2),
      bottom: Radius.circular(8),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasteStackCubit, PasteStackState>(
      builder: (context, state) {
        final items = state.items;

        if (items.isEmpty) {
          return Center(
            child: Icon(
              Icons.inbox_rounded,
              size: 64,
              color: context.colors.surfaceContainerHighest,
            ),
          );
        }

        return ClipsProvider(
          clips: items,
          child: ReorderableListView.builder(
            buildDefaultDragHandles: false,
            header: items.length > 1
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: padding4),
                    child: ListTile(
                      dense: true,
                      tileColor: context.colors.surfaceContainerHigh,
                      leading: const Icon(Icons.drag_handle),
                      title: Text(context.locale.paste_stack__reorder_hint),
                    ),
                  )
                : null,
            itemCount: items.length,
            proxyDecorator: (child, index, animation) {
              return Material(type: MaterialType.transparency, child: child);
            },
            onReorderItem: (oldIndex, newIndex) {
              context.read<PasteStackCubit>().reorderItem(oldIndex, newIndex);
            },
            itemBuilder: (context, index) {
              final item = items[index];
              late final ShapeBorder shape;

              switch (index) {
                case 0 when items.length == 1:
                  shape = _singleShape;
                case 0:
                  shape = _topShape;
                case _ when index == items.length - 1:
                  shape = _bottomShape;
                default:
                  shape = _singleShape;
              }

              return LimitedBox(
                maxHeight: 150,
                key: ValueKey(item.id ?? item.created.millisecondsSinceEpoch),
                child: HoverScopeProvider(
                  child: ClipItemScope(
                    item: item,
                    child: Card.filled(
                      color: context.colors.secondaryContainer,
                      clipBehavior: Clip.hardEdge,
                      shape: shape,
                      margin: const EdgeInsets.symmetric(
                        vertical: padding4,
                        horizontal: padding8,
                      ),
                      child: Stack(
                        children: [
                          const Positioned.fill(
                            child: ClipCardBodyContent(liteMode: true),
                          ),
                          Positioned(
                            top: padding6,
                            right: padding6,
                            child: _PasteStackCardActions(
                              index: index,
                              item: item,
                              canReorder: items.length > 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _PasteStackCardActions extends StatelessWidget {
  final int index;
  final ClipboardItem item;
  final bool canReorder;

  const _PasteStackCardActions({
    required this.index,
    required this.item,
    required this.canReorder,
  });

  @override
  Widget build(BuildContext context) {
    final hovered = HoverScope.of(context);
    final colors = context.colors;

    if (!hovered && !canReorder) {
      return const SizedBox.shrink();
    }

    return Material(
      color: colors.surface.withValues(alpha: 0.85),
      borderRadius: radius4,
      elevation: hovered ? 1 : 0,
      clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: const EdgeInsets.all(padding2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hovered)
              Tooltip(
                message: context.locale.app__delete,
                child: InkWell(
                  mouseCursor: SystemMouseCursors.click,
                  borderRadius: radius4,
                  onTap: () => context.read<PasteStackCubit>().removeItem(item),
                  child: Padding(
                    padding: const EdgeInsets.all(padding4),
                    child: Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: colors.error,
                    ),
                  ),
                ),
              ),
            if (canReorder && hovered) width4,
            if (canReorder)
              ReorderableDragStartListener(
                index: index,
                child: Tooltip(
                  message: context.locale.paste_stack__reorder_hint,
                  child: InkWell(
                    mouseCursor: SystemMouseCursors.grab,
                    borderRadius: radius4,
                    child: Padding(
                      padding: const EdgeInsets.all(padding4),
                      child: Icon(
                        Icons.drag_indicator_rounded,
                        size: 16,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
