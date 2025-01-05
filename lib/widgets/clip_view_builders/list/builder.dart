import 'package:clipboard/utils/clipboard_actions.dart';
import 'package:clipboard/widgets/clip_item/clip_list_item/clip_list_item.dart';
import 'package:clipboard/widgets/clip_item/clip_menu_provider.dart';
import 'package:clipboard/widgets/clip_item/clip_meta_info.dart';
import 'package:clipboard/widgets/clip_view_builders/selected_clip_provider.dart';
import 'package:clipboard/widgets/empty.dart';
import 'package:clipboard/widgets/load_more_card.dart';
import 'package:copycat_base/bloc/event_bus_cubit/event_bus_cubit.dart';
import 'package:copycat_base/constants/numbers/breakpoints.dart';
import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/db/clipboard_item/clipboard_item.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:copycat_base/utils/utility.dart';
import 'package:copycat_base/widgets/clipcard_loading.dart';
import 'package:copycat_base/widgets/on_event.dart';
import 'package:flutter/material.dart';

class ClipListBuilder extends StatelessWidget {
  final List<ClipboardItem> items;
  final bool hasMore;
  final bool loading;
  final VoidCallback loadMore;
  final bool canPaste;

  const ClipListBuilder({
    super.key,
    required this.items,
    required this.hasMore,
    required this.loading,
    required this.loadMore,
    required this.canPaste,
  });

  void onIndexPaste(BuildContext context, EventBusIndexPasteEvent state) {
    final index = state.index - 1;
    if (!index.isNegative && index < items.length) {
      performPrimaryActionOnClip(context, items[index], canPaste);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = context.mq.size.width;
    final isMobile = Breakpoints.isMobile(width);
    if (items.isEmpty) {
      if (loading) {
        return const ClipcardLoading();
      }
      return EmptyNote(note: context.locale.emptyClipboard);
    }

    return OnEvent<EventBusIndexPasteEvent>(
      trigger: onIndexPaste,
      child: SelectedClipProvider(builder: (context, selectedClips) {
        return ListView.builder(
          padding: isMobile ? const EdgeInsets.all(padding8) : inset12,
          primary: true,
          itemCount: items.length + (hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == items.length) {
              return LoadMoreCard(
                key: const ValueKey("clipboard-items-load-more"),
                loadMore: loadMore,
              );
            }

            final item = items[index];
            final isSelected = selectedClips.contains(item);
            Widget listItem = ClipMenuProvider(
              item: item,
              child: ClipListItem(
                key: ValueKey("clipboard-item-${item.id}"),
                item: item,
                autofocus: !isSelected && index == 0 && isDesktopPlatform,
                canPaste: canPaste,
                selected: isSelected,
                selectionActive: selectedClips.isNotEmpty,
              ),
            );

            if (isDesktopPlatform && index < 9) {
              listItem = ClipMetaInfo(index: index + 1, child: listItem);
            }
            return listItem;
          },
        );
      }),
    );
  }
}
