import 'package:clipboard/base/bloc/paste_stack_cubit/paste_stack_cubit.dart';
import 'package:clipboard/base/constants/numbers/breakpoints.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/can_paste_builder.dart';
import 'package:clipboard/widgets/clip_item/clip_list_item/clip_list_item.dart';
import 'package:clipboard/widgets/clips_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasteStackBody extends StatelessWidget {
  const PasteStackBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PasteStackCubit, PasteStackState, List<ClipboardItem>>(
      selector: (state) => state.items,
      builder: (context, items) {
        return CanPasteBuilder(
          builder: (context, canPaste) {
            final isMobile = Breakpoints.isMobile(context.mq.size.width);
            return ClipsProvider(
              clips: items,
              child: ReorderableListView.builder(
                padding: isMobile ? const EdgeInsets.all(padding8) : inset12,
                itemCount: items.length,
                proxyDecorator: (child, index, animation) {
                  return Material(
                    type: MaterialType.transparency,
                    child: child,
                  );
                },
                onReorder: (oldIndex, newIndex) {
                  context.read<PasteStackCubit>().reorderItem(
                    oldIndex,
                    newIndex,
                  );
                },
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ClipListItem(
                    key: ValueKey(
                      "paste-stack-item-${item.created.millisecondsSinceEpoch}",
                    ),
                    item: item,
                    autofocus: false,
                    selected: false,
                    noView: true,
                    selectionActive: false,
                    selectionIndex: -1,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
