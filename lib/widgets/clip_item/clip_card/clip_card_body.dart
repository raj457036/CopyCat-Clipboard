import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/selected_clips_cubit/selected_clips_cubit.dart';
import 'package:clipboard/base/constants/font_variations.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/utils/clipboard_actions.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/can_paste_builder.dart';
import 'package:clipboard/widgets/clip_item/clip_card/clip_card_options_header.dart';
import 'package:clipboard/widgets/clip_item/clip_card/hover_state_builder.dart';
import 'package:clipboard/widgets/clip_item/clip_item_scope.dart';
import 'package:clipboard/widgets/clip_item/clip_preview.dart';
import 'package:clipboard/widgets/clip_item/clip_sync_status_footer.dart';
import 'package:clipboard/widgets/clips_provider.dart';
import 'package:clipboard/widgets/drag_drop/drag_item.dart';
import 'package:clipboard/widgets/keyboard_shortcuts/space_enter_listener.dart';
import 'package:clipboard/widgets/local_user.dart';
import 'package:clipboard/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClipCardBodyContent extends StatelessWidget {
  /// If true, the card will be rendered in a simplified way without
  /// loading other interactives.
  final bool liteMode;
  final bool dragAndDropEnabled;

  const ClipCardBodyContent({
    super.key,
    this.liteMode = false,
    this.dragAndDropEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final item = ClipItemScope.of(context);
    final selected = context.select(
      (SelectedClipsCubit cubit) => cubit.isSelected(item),
    );
    final syncActive = context.select(
      (AppConfigCubit cubit) => cubit.state.config.enableSync,
    );
    if (liteMode) return ClipPreview(item: item);

    final child = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(child: ClipPreview(item: item)),
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: padding44,
                child: ClipCardOptionsHeader(),
              ),
            ],
          ),
        ),
        if (!selected && syncActive) const _SyncStatusFooter(),
      ],
    );

    if (!selected && dragAndDropEnabled) {
      return DraggableItem(item: item, child: child);
    }
    return child;
  }
}

class _SyncStatusFooter extends StatelessWidget {
  const _SyncStatusFooter();

  @override
  Widget build(BuildContext context) {
    final item = ClipItemScope.of(context);
    return DisableForLocalUser(child: ClipSyncStatusFooter(item: item));
  }
}

class ClipCardBody extends StatefulWidget {
  final ClipboardItem item;
  final bool focused;
  final bool selected;
  final int selectionIndex;
  final bool selectionActive;
  final bool dragAndDropEnabled;

  const ClipCardBody({
    super.key,
    required this.item,
    required this.focused,
    required this.selected,
    required this.selectionActive,
    required this.selectionIndex,
    required this.dragAndDropEnabled,
  });

  @override
  State<ClipCardBody> createState() => _ClipCardBodyState();
}

class _ClipCardBodyState extends State<ClipCardBody> {
  bool focused = false;
  void onFocusChange(bool hasFocus) {
    if (hasFocus) {
      Scrollable.ensureVisible(
        context,
        duration: Durations.medium1,
        curve: Curves.easeOutCubic,
        alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
      );
    }

    if (focused != hasFocus) {
      setState(() {
        focused = hasFocus;
      });
    }
  }

  bool get canPaste => CanPasteScope.of(context);

  void toggleSelect(BuildContext context) {
    final cubit = context.read<SelectedClipsCubit>();
    if (widget.selected) {
      cubit.unselect(widget.item);
      return;
    }
    final clips = ClipsProvider.of(context)?.clips;
    cubit.select(widget.item, selectableItems: clips);
  }

  Future<void> onShiftEnter(BuildContext context) async {
    if (widget.selectionActive && isDesktopPlatform && canPaste) {
      await pasteSelectedOnLastWindow(context, clearSelection: true);
      return;
    }
    toggleSelect(context);
  }

  Future<void> onShiftC(BuildContext context, ClipboardItem item) async {
    if (widget.selectionActive && isDesktopPlatform && canPaste) {
      await copySelectedItems(context, clearSelection: true);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final menuOpen = Menu.maybeIsOpenOf(context) ?? false;
    final highlighted = focused || menuOpen;
    final selectedShape = RoundedRectangleBorder(
      side: BorderSide(
        color: widget.selected
            ? colors.secondary
            : highlighted
            ? colors.primary
            : colors.outlineVariant,
        width: highlighted ? gridItemBorderWidth * 2 : gridItemBorderWidth,
        strokeAlign: BorderSide.strokeAlignInside,
      ),
      borderRadius: radius12,
    );
    final content = HoverScopeProvider(
      child: ClipCardBodyContent(dragAndDropEnabled: widget.dragAndDropEnabled),
    );
    final bgColor = widget.item.locked
        ? colors.primaryContainer
        : colors.surfaceContainerLowest;

    return SpaceEnterListener(
      onSpace: (context) => widget.selectionActive
          ? toggleSelect(context)
          : openClipPreview(context, widget.item),
      onEnter: (context) => widget.selectionActive
          ? toggleSelect(context)
          : performPrimaryActionOnClip(context, widget.item, canPaste),
      onShiftSpace: (context) => toggleSelect(context),
      onShiftSpaceEnter: (context) => onShiftEnter(context),
      onShiftC: (context) => onShiftC(context, widget.item),
      child: Card(
        color: bgColor,
        elevation: highlighted ? 3 : 0,
        shape: selectedShape,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onLongPress: isMobilePlatform && !widget.dragAndDropEnabled
              ? () => Menu.of(context)?.openMenu(context)
              : null,
          focusColor: Colors.transparent,
          mouseCursor: SystemMouseCursors.click,
          customBorder: selectedShape,
          onTap: !widget.selectionActive
              ? () => performPrimaryActionOnClip(context, widget.item, canPaste)
              : () => toggleSelect(context),
          onSecondaryTapUp: !widget.selectionActive
              ? (detail) async {
                  final menu = Menu.of(context);
                  if (menu == null) return;
                  if (isMobilePlatform) {
                    menu.openMenu(context);
                    return;
                  }
                  menu.openPopupMenu(context, detail.globalPosition);
                }
              : null,
          onFocusChange: onFocusChange,
          autofocus: widget.focused,
          child: content,
        ),
      ),
    );
  }
}
