import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/can_paste_builder.dart';
import 'package:clipboard/widgets/clip_card.dart';
import 'package:clipboard/widgets/empty.dart';
import 'package:clipboard/widgets/load_more_card.dart';
import 'package:copycat_base/bloc/clipboard_cubit/clipboard_cubit.dart';
import 'package:copycat_base/bloc/sync_manager_cubit/sync_manager_cubit.dart';
import 'package:copycat_base/constants/numbers/breakpoints.dart';
import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/db/clipboard_item/clipboard_item.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:copycat_base/widgets/clipcard_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  Future<void> _loadMore(BuildContext context) async {
    await context.read<ClipboardCubit>().fetch();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = Breakpoints.isMobile(width);

    final content = RefreshIndicator(
      onRefresh: () async => await syncChanges(context),
      child: CanPasteBuilder(builder: (context, canPaste) {
        return BlocSelector<ClipboardCubit, ClipboardState,
            (List<ClipboardItem>, bool, bool)>(
          selector: (state) {
            return (state.items, state.hasMore, state.loading);
          },
          builder: (context, state) {
            final (items, hasMore, loading) = state; //Subject;

            if (items.isEmpty) {
              if (loading) {
                return const ClipcardLoading();
              }
              return EmptyNote(note: context.locale.emptyClipboard);
            }

            return GridView.builder(
              padding: isMobile ? insetLR8BT12 : inset12,
              primary: true,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 240,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: items.length + (hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == items.length) {
                  return LoadMoreCard(loadMore: _loadMore);
                }

                final item = items[index];
                return ClipCard(
                  key: ValueKey("clipboard-item-${item.id}"),
                  autoFocus: index == 0 && isDesktopPlatform,
                  item: item,
                  canPaste: canPaste,
                );
              },
            );
          },
        );
      }),
    );

    return content;
  }
}
