import 'package:clipboard/utils/clipboard_actions.dart';
import 'package:clipboard/widgets/clip_item/clip_list_item/options_header.dart';
import 'package:clipboard/widgets/clip_item/clip_preview.dart';
import 'package:clipboard/widgets/clip_item/clip_sync_status_footer.dart';
import 'package:clipboard/widgets/clips_provider.dart';
import 'package:clipboard/widgets/local_user.dart';
import 'package:clipboard/widgets/menu.dart';
import 'package:copycat_base/bloc/selected_clips_cubit/selected_clips_cubit.dart';
import 'package:copycat_base/constants/font_variations.dart';
import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/db/app_config/appconfig.dart';
import 'package:copycat_base/db/clipboard_item/clipboard_item.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:copycat_base/utils/utility.dart';
import 'package:copycat_pro/widgets/drag_drop/drag_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universal_io/io.dart';

class ClipListItem extends StatefulWidget {
  final bool autofocus;
  final bool canPaste;
  final bool selected;
  final bool selectionActive;
  final ClipboardItem item;

  const ClipListItem({
    super.key,
    required this.item,
    this.autofocus = false,
    this.canPaste = false,
    this.selected = false,
    this.selectionActive = false,
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

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;

    final selectedShape = RoundedRectangleBorder(
      side: BorderSide(
        color:
            focused || widget.selected ? colors.primary : colors.outlineVariant,
        width: focused || widget.selected ? 2.5 : 1,
        strokeAlign: BorderSide.strokeAlignOutside,
      ),
      borderRadius: radius12,
    );

    final child = Padding(
      padding: const EdgeInsets.only(bottom: padding10),
      child: Material(
        shape: selectedShape,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 60, maxHeight: 220),
          child: InkWell(
            borderRadius: radius12,
            autofocus: widget.autofocus,
            onTap: !widget.selectionActive
                ? () => performPrimaryActionOnClip(
                    context, widget.item, widget.canPaste)
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
                ClipListItemOptionHeader(
                  item: widget.item,
                  hasFocusForPaste: widget.canPaste,
                  hovered: hovered,
                  selected: widget.selected,
                  selectionActive: widget.selectionActive,
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
                  child: ClipPreview(
                    item: widget.item,
                    layout: AppLayout.list,
                  ),
                ),
                if (!widget.selected)
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
