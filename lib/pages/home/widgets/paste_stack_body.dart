import 'package:clipboard/base/bloc/paste_stack_cubit/paste_stack_cubit.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/widgets/can_paste_builder.dart';
import 'package:clipboard/widgets/clip_view_builders/list/builder.dart';
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
          builder: (context) {
            return ClipsProvider(
              clips: items,
              child: ClipListBuilder(
                items: items,
                hasMore: false,
                loading: false,
                loadMore: () {},
                pasteStackMode: true,
              ),
            );
          },
        );
      },
    );
  }
}
