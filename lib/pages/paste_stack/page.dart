import 'package:clipboard/base/bloc/paste_stack_cubit/paste_stack_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/pages/home/widgets/paste_stack_body.dart';
import 'package:clipboard/utils/clipboard_actions.dart';
import 'package:clipboard/widgets/can_paste_builder.dart';
import 'package:clipboard/widgets/layout/custom_scaffold.dart';
import 'package:clipboard/widgets/scaffold_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasteStackPage extends StatelessWidget {
  const PasteStackPage({super.key});

  void reverseStack(BuildContext context) {
    context.read<PasteStackCubit>().reverseStack();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      PasteStackCubit,
      PasteStackState,
      (int, List<ClipboardItem>)
    >(
      selector: (state) => (state.count, state.items),
      builder: (context, data) {
        final (count, items) = data;
        return CanPasteBuilder(
          builder: (context, canPaste) {
            return CustomScaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text("Paste Stack • $count"),
                centerTitle: false,
                actions: [
                  if (count > 1 && canPaste)
                    IconButton(
                      onPressed: () async {
                        final cubit = context.read<PasteStackCubit>();
                        await pasteMultipleOnLastWindow(context, items);
                        if (context.mounted) await cubit.deactivateSilent();
                      },
                      tooltip: "Paste All",
                      icon: const Icon(Icons.content_paste_go_outlined),
                    ),
                  IconButton(
                    onPressed: () => reverseStack(context),
                    tooltip: "Reverse Stack",
                    icon: const Icon(Icons.unfold_more_rounded),
                  ),
                  width10,
                ],
              ),
              body: const ScaffoldBody(child: PasteStackBody()),
              activeIndex: -1,
            );
          },
        );
      },
    );
  }
}
