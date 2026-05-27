import 'package:clipboard/base/bloc/event_bus_cubit/event_bus_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/clipboard_actions.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/app_layout_builder.dart';
import 'package:clipboard/widgets/can_paste_builder.dart';
import 'package:clipboard/widgets/clip_item/clip_card/clip_card.dart';
import 'package:clipboard/widgets/clip_item/clip_meta_info.dart';
import 'package:clipboard/widgets/clipcard_loading.dart';
import 'package:clipboard/widgets/empty.dart';
import 'package:clipboard/widgets/on_event.dart';
import 'package:clipboard/widgets/select_clip_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ClipsBuilder extends StatelessWidget {
  final List<ClipboardItem> items;
  final bool hasMore;
  final bool loading;
  final VoidCallback loadMore;
  final AppLayoutView layoutView;

  const ClipsBuilder({
    super.key,
    required this.items,
    required this.hasMore,
    required this.loading,
    required this.loadMore,
    required this.layoutView,
  });

  void onIndexPaste(BuildContext context, EventBusIndexPasteEvent state) {
    final index = state.index - 1;
    if (!index.isNegative && index < items.length) {
      final canPaste = CanPasteScope.of(context);
      performPrimaryActionOnClip(context, items[index], canPaste);
    }
  }

  Axis get scrollDirection {
    switch (layoutView.view) {
      case AppView.bottomDocked || AppView.topDocked:
        return Axis.horizontal;
      case AppView.leftDocked || AppView.rightDocked:
        return Axis.vertical;
      case _:
        return Axis.vertical;
    }
  }

  SliverGridDelegate get delegate {
    switch (layoutView.view) {
      case AppView.bottomDocked || AppView.topDocked:
        return const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 1,
        );
      case AppView.windowed || AppView.leftDocked || AppView.rightDocked:
        return const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: gridMaxExtent,
          childAspectRatio: 1,
        );
    }
  }

  bool onScrollNotification(
    ScrollNotification notification,
    bool hasMore,
    bool loading,
  ) {
    if (!hasMore || loading) return false;
    if (notification.metrics.extentAfter > 800) return false;
    loadMore();
    return false;
  }

  Widget buildGridView(List<ClipboardItem> selectedClips) {
    return GridView.builder(
      scrollCacheExtent: const ScrollCacheExtent.pixels(300),
      padding: const EdgeInsets.only(
        left: padding4,
        right: padding4,
        bottom: padding8,
      ),
      scrollDirection: scrollDirection,
      gridDelegate: delegate,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final selectedItemIndex = selectedClips.indexOf(item);
        final isSelected = selectedItemIndex != -1;
        Widget card = ClipCard(
          key: ValueKey("clipboard-item-${item.id}"),
          autoFocus: !isSelected && index == 0 && isDesktopPlatform,
          item: item,
          selected: isSelected,
          selectionIndex: selectedItemIndex,
          selectionActive: selectedClips.isNotEmpty,
        );

        if (isDesktopPlatform && index < 9) {
          card = ClipMetaInfo(index: index + 1, child: card);
        }
        return card;
      },
    );
  }

  Widget buildListView(List<ClipboardItem> selectedClips) {
    return ListView.builder(
      scrollCacheExtent: const ScrollCacheExtent.pixels(300),
      padding: const EdgeInsets.all(padding4),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final selectedItemIndex = selectedClips.indexOf(item);
        final isSelected = selectedItemIndex != -1;
        Widget card = ConstrainedBox(
          key: ValueKey("clipboard-item-${item.id}"),
          constraints: const BoxConstraints(maxHeight: 120.0),
          child: ClipCard(
            autoFocus: !isSelected && index == 0 && isDesktopPlatform,
            item: item,
            selected: isSelected,
            selectionIndex: selectedItemIndex,
            selectionActive: selectedClips.isNotEmpty,
          ),
        );

        if (isDesktopPlatform && index < 9) {
          card = ClipMetaInfo(
            key: ValueKey("clipboard-item-${item.id}-meta"),
            index: index + 1,
            child: card,
          );
        }
        return card;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      if (loading) {
        return const ClipcardLoading();
      }
      return EmptyNote(note: context.locale.app__empty_clipboard);
    }

    return OnEvent<EventBusIndexPasteEvent>(
      trigger: onIndexPaste,
      child: CanPasteBuilder(
        builder: (context, _) {
          return SelectedClipBuilder(
            builder: (context, selectedClips) {
              return NotificationListener<ScrollNotification>(
                onNotification: (notification) =>
                    onScrollNotification(notification, hasMore, loading),
                child: layoutView.layout == AppLayout.grid
                    ? buildGridView(selectedClips)
                    : buildListView(selectedClips),
              );
            },
          );
        },
      ),
    );
  }
}
