import 'package:clipboard/base/bloc/selected_clips_cubit/selected_clips_cubit.dart';
import 'package:clipboard/base/constants/font_variations.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/utils/clipboard_actions.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/can_paste_builder.dart';
import 'package:clipboard/widgets/clip_item/clip_list_item/options_header.dart';
import 'package:clipboard/widgets/clip_item/clip_preview.dart';
import 'package:clipboard/widgets/clip_item/clip_sync_status_footer.dart';
import 'package:clipboard/widgets/clips_provider.dart';
import 'package:clipboard/widgets/drag_drop/drag_item.dart';
import 'package:clipboard/widgets/keyboard_shortcuts/space_enter_listener.dart';
import 'package:clipboard/widgets/local_user.dart';
import 'package:clipboard/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universal_io/io.dart';

class ClipListItem extends StatefulWidget {
  final bool autofocus;
  final bool selected;
  final int selectionIndex;
  final bool noView;
  final bool selectionActive;
  final ClipboardItem item;

  const ClipListItem({
    super.key,
    required this.item,
    this.autofocus = false,
    this.selected = false,
    this.noView = false,
    this.selectionActive = false,
    required this.selectionIndex,
  });

  @override
  State<ClipListItem> createState() => _ClipListItemState();
}

class _ClipListItemState extends State<ClipListItem> {
  bool hovered = false;
  bool focused = false;

  void onHover(bool isHovered) {
    if (hovered == isHovered) return;
    setState(() {
      hovered = isHovered;
    });
  }

  void focus() => !focused ? setState(() => focused = true) : null;
  void unfocus() => focused ? setState(() => focused = false) : null;

  void onFocusChange(bool value) {
    if (value) {
      Scrollable.ensureVisible(
        context,
        alignment: 0.5,
        duration: Durations.medium1,
        curve: Curves.easeOut,
      );
      focus();
    } else {
      unfocus();
    }
  }

  void toggleSelect(BuildContext context) {
    final cubit = context.read<SelectedClipsCubit>();
    if (widget.selected) {
      cubit.unselect(widget.item);
      return;
    }
    final clips = ClipsProvider.of(context)?.clips;
    cubit.select(widget.item, selectableItems: clips);
  }

  Future<void> onShiftEnter(BuildContext context, bool canPaste) async {
    if (widget.selectionActive && canPaste) {
      await pasteSelectedOnLastWindow(context, clearSelection: true);
      return;
    }
    toggleSelect(context);
  }

  @override
  Widget build(BuildContext context) {
    final canPaste = CanPasteScope.of(context);
    final colors = context.colors;
    final textTheme = context.textTheme;

    final selectedShape = focused || widget.selected
        ? RoundedRectangleBorder(
            side: BorderSide(
              color: colors.primary,
              width: focused ? focusedItemBorderWidth : selectedItemBorderWidth,
              strokeAlign: focused
                  ? BorderSide.strokeAlignOutside
                  : BorderSide.strokeAlignInside,
            ),
            borderRadius: radius12,
          )
        : null;

    final child = SpaceEnterListener(
      onSpace: (context) => widget.selectionActive
          ? toggleSelect(context)
          : preview(context, widget.item),
      onEnter: (context) => widget.selectionActive
          ? toggleSelect(context)
          : performPrimaryActionOnClip(context, widget.item, canPaste),
      onShiftSpace: (context) => toggleSelect(context),
      onShiftSpaceEnter: (context) => onShiftEnter(context, canPaste),
      child: Card.outlined(
        shape: selectedShape,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 60, maxHeight: 220),
          child: InkWell(
            mouseCursor: SystemMouseCursors.click,
            borderRadius: radius12,
            autofocus: widget.autofocus,
            onTap: !widget.selectionActive
                ? () =>
                      performPrimaryActionOnClip(context, widget.item, canPaste)
                : () => toggleSelect(context),
            onSecondaryTapDown: !widget.selectionActive
                ? (detail) async {
                    final menu = Menu.of(context);
                    if (isMobilePlatform) {
                      menu.openOptionBottomSheet(context);
                      return;
                    }
                    final position = detail.globalPosition;
                    menu.openPopupMenu(context, position);
                  }
                : null,
            onFocusChange: onFocusChange,
            onHover: onHover,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!widget.noView)
                  ClipListItemOptionHeader(
                    item: widget.item,
                    hasFocusForPaste: canPaste,
                    hovered: hovered,
                    selected: widget.selected,
                    selectionActive: widget.selectionActive,
                    selectionIndex: widget.selectionIndex,
                  ),
                if (widget.item.displayTitle != null && !widget.item.encrypted)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: padding10,
                      right: padding10,
                      bottom: padding8,
                    ),
                    child: Text(
                      widget.item.displayTitle!,
                      style: textTheme.titleSmall?.copyWith(
                        fontVariations: fontVarW700,
                      ),
                      maxLines: 2,
                    ),
                  ),
                Flexible(
                  child: ClipPreview(item: widget.item, layout: AppLayout.list),
                ),
                if (!widget.selected && !widget.noView)
                  DisableForLocalUser(
                    child: ClipSyncStatusFooter(
                      item: widget.item,
                      radius: const BorderRadius.vertical(
                        bottom: Radius.circular(8),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    if (!Platform.isAndroid) {
      return DraggableItem(item: widget.item, child: child);
    }
    return child;
  }
}
