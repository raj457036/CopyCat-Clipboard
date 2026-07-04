import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/event_bus_cubit/event_bus_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/clipboard_actions.dart';
import 'package:clipboard/utils/common_extension.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';

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
      performPrimaryActionOnClip(context, items[index], true);
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

  Widget buildGridView(
    BuildContext context,
    List<ClipboardItem> selectedClips,
    bool dragAndDropEnabled,
  ) {
    return GridView.builder(
      scrollCacheExtent: const ScrollCacheExtent.pixels(300),
      padding: context.isMobile
          ? const EdgeInsets.all(padding10)
          : const EdgeInsets.only(
              left: padding4,
              right: padding4,
              bottom: padding8,
            ),
      scrollDirection: scrollDirection,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: gridMaxExtent,
        childAspectRatio: 1,
      ),
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
          dragAndDropEnabled: dragAndDropEnabled,
        );

        if (isDesktopPlatform && index < 9) {
          card = ClipMetaInfo(index: index + 1, child: card);
        }
        return card;
      },
    );
  }

  Widget buildListView(
    BuildContext context,
    List<ClipboardItem> selectedClips,
    bool dragAndDropEnabled,
  ) {
    return ListView.builder(
      scrollCacheExtent: const ScrollCacheExtent.pixels(300),
      padding: context.isMobile
          ? const EdgeInsets.all(padding10)
          : const EdgeInsets.only(
              left: padding4,
              right: padding4,
              bottom: padding8,
            ),
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
            dragAndDropEnabled: dragAndDropEnabled,
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
                child: BlocSelector<AppConfigCubit, AppConfigState, bool>(
                  selector: (state) {
                    switch (state) {
                      case AppConfigLoaded(:final config):
                        return config.enableDragNDrop;
                      default:
                        return false;
                    }
                  },
                  builder: (context, dragAndDropEnabled) {
                    return layoutView.layout == AppLayout.grid
                        ? buildGridView(
                            context,
                            selectedClips,
                            dragAndDropEnabled,
                          )
                        : buildListView(
                            context,
                            selectedClips,
                            dragAndDropEnabled,
                          );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
