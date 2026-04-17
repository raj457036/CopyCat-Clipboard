import 'package:clipboard/base/bloc/paste_stack_cubit/paste_stack_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/pages/home/widgets/paste_stack_body.dart';
import 'package:clipboard/widgets/layout/custom_scaffold.dart';
import 'package:clipboard/widgets/scaffold_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasteStackPage extends StatelessWidget {
  const PasteStackPage({super.key});

  void reverseStack(BuildContext context) {
    context.read<PasteStackCubit>().reverseStack();
  }

  void closeStack(BuildContext context) {
    context.read<PasteStackCubit>().deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PasteStackCubit, PasteStackState, int>(
      selector: (state) => state.count,
      builder: (context, count) {
        return CustomScaffold(
          // We don't want the navigation bar in Paste Stack mode
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("Paste Stack • $count"),
            centerTitle: false,
            actions: [
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
  }
}
