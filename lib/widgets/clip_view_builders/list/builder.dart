import 'package:clipboard/base/bloc/event_bus_cubit/event_bus_cubit.dart';
import 'package:clipboard/base/constants/numbers/breakpoints.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/clipboard_actions.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/can_paste_builder.dart';
import 'package:clipboard/widgets/clip_item/clip_list_item/clip_list_item.dart';
import 'package:clipboard/widgets/clip_item/clip_menu_provider.dart';
import 'package:clipboard/widgets/clip_item/clip_meta_info.dart';
import 'package:clipboard/widgets/clipcard_loading.dart';
import 'package:clipboard/widgets/empty.dart';
import 'package:clipboard/widgets/on_event.dart';
import 'package:clipboard/widgets/select_clip_builder.dart';
import 'package:flutter/material.dart';

class ClipListBuilder extends StatelessWidget {
  final List<ClipboardItem> items;
  final bool hasMore;
  final bool loading;
  final VoidCallback loadMore;

  const ClipListBuilder({
    super.key,
    required this.items,
    required this.hasMore,
    required this.loading,
    required this.loadMore,
  });

  void onIndexPaste(BuildContext context, EventBusIndexPasteEvent state) {
    final index = state.index - 1;
    if (!index.isNegative && index < items.length) {
      final canPaste = CanPasteScope.of(context);
      performPrimaryActionOnClip(context, items[index], canPaste);
    }
  }

  bool onScrollNotification(
    ScrollNotification notification,
    bool hasMore,
    bool loading,
  ) {
    if (!hasMore || loading) return false;
    if (notification.metrics.extentAfter > 600) return false;
    loadMore();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final width = context.mq.size.width;
    final isMobile = Breakpoints.isMobile(width);
    if (items.isEmpty) {
      if (loading) {
        return const ClipcardLoading();
      }
      return EmptyNote(note: context.locale.app__empty_clipboard);
    }

    return OnEvent<EventBusIndexPasteEvent>(
      trigger: onIndexPaste,
      child: SelectedClipBuilder(
        builder: (context, selectedClips) {
          return NotificationListener<ScrollNotification>(
            onNotification: (notification) =>
                onScrollNotification(notification, hasMore, loading),
            child: ListView.builder(
              padding: isMobile ? const EdgeInsets.all(padding6) : inset12,
              primary: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final selectedItemIndex = selectedClips.indexOf(item);
                final isSelected = selectedItemIndex != -1;
                final totalItems = items.length;
                Widget listItem = ClipMenuProvider(
                  item: item,
                  child: ClipListItem(
                    key: ValueKey("clipboard-item-${item.id}"),
                    item: item,
                    autofocus: !isSelected && index == 0 && isDesktopPlatform,
                    selected: isSelected,
                    selectionIndex: selectedItemIndex,
                    selectionActive: selectedClips.isNotEmpty,
                    isFirst: index == 0,
                    isLast: index == totalItems - 1,
                  ),
                );

                if (isDesktopPlatform && index < 9) {
                  listItem = ClipMetaInfo(index: index + 1, child: listItem);
                }
                return listItem;
              },
            ),
          );
        },
      ),
    );
  }
}
