import 'package:clipboard/base/bloc/paste_stack_cubit/paste_stack_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/clip_item/clip_card/clip_card_body.dart'
    show ClipCardBodyContent;
import 'package:clipboard/widgets/clip_item/clip_item_scope.dart';
import 'package:clipboard/widgets/clips_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasteStackBody extends StatelessWidget {
  const PasteStackBody({super.key});

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
            header: items.length > 1
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: padding4),
                    child: ListTile(
                      dense: true,
                      tileColor: context.colors.surfaceContainerHigh,
                      leading: const Icon(Icons.drag_handle),
                      title: const Text("You can drag item to reorder."),
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
                  shape = const RoundedRectangleBorder(borderRadius: radius2);
                case 0:
                  shape = const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(8),
                      bottom: Radius.circular(2),
                    ),
                  );
                case _ when index == items.length - 1:
                  shape = const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(2),
                      bottom: Radius.circular(8),
                    ),
                  );
                default:
                  shape = const RoundedRectangleBorder(borderRadius: radius2);
              }

              return LimitedBox(
                maxHeight: 150,
                key: ValueKey(
                  "paste-stack-item-${item.created.millisecondsSinceEpoch}",
                ),
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
                    child: const ClipCardBodyContent(liteMode: true),
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
