import 'package:clipboard/base/bloc/paste_stack_cubit/paste_stack_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/pages/home/widgets/paste_stack_body.dart';
import 'package:clipboard/utils/common_extension.dart'
    show BuildContextExtension;
import 'package:clipboard/widgets/can_paste_builder.dart';
import 'package:clipboard/widgets/layout/custom_scaffold.dart';
import 'package:clipboard/widgets/scaffold_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasteStackPage extends StatelessWidget {
  final int count;

  const PasteStackPage({super.key, required this.count});

  void reverseStack(BuildContext context) {
    context.read<PasteStackCubit>().reverseStack();
  }

  @override
  Widget build(BuildContext context) {
    return CanPasteBuilder(
      builder: (context, canPaste) {
        return CustomScaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0,
            backgroundColor: context.colors.surface,
            title: Text(context.locale.paste_stack__title(count: count)),
            centerTitle: false,
            titleTextStyle: context.textTheme.titleMedium,
            toolbarHeight: 38,
            actions: [
              IconButton(
                onPressed: () => reverseStack(context),
                tooltip: context.locale.paste_stack__reverse_tooltip,
                icon: const Icon(Icons.unfold_more_rounded),
                iconSize: 20,
                style: IconButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                ),
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
