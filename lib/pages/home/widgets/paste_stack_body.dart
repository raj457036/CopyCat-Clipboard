import 'package:clipboard/base/bloc/paste_stack_cubit/paste_stack_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
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
    const maxHeight = 150.0;
    return BlocBuilder<PasteStackCubit, PasteStackState>(
      builder: (context, state) {
        final items = state.items;
        return ClipsProvider(
          clips: items,
          child: ReorderableListView.builder(
            padding: context.mq.isMobile
                ? const EdgeInsets.all(padding8)
                : inset12,
            itemCount: items.length,
            proxyDecorator: (child, index, animation) {
              return Material(type: MaterialType.transparency, child: child);
            },
            cacheExtent: maxHeight,
            onReorder: (oldIndex, newIndex) {
              context.read<PasteStackCubit>().reorderItem(oldIndex, newIndex);
            },

            itemBuilder: (context, index) {
              final item = items[index];
              return LimitedBox(
                key: ValueKey(
                  "paste-stack-item-${item.created.millisecondsSinceEpoch}",
                ),
                maxHeight: maxHeight,
                child: ClipItemScope(
                  item: item,
                  child: const Card.outlined(
                    clipBehavior: Clip.hardEdge,
                    child: ClipCardBodyContent(liteMode: true),
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
