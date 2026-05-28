import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/offline_persistance_cubit/offline_persistance_cubit.dart';
import 'package:clipboard/base/bloc/selected_clips_cubit/selected_clips_cubit.dart';
import 'package:clipboard/base/constants/font_variations.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/data/services/notification_service.dart'
    show InAppNotificationService;
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/model/notification_message.dart'
    show NotificationMessage;
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/utils/clipboard_actions.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/can_paste_builder.dart';
import 'package:clipboard/widgets/clip_item/clip_card/clip_card_options_header.dart';
import 'package:clipboard/widgets/clip_item/clip_card/hover_state_builder.dart';
import 'package:clipboard/widgets/clip_item/clip_preview.dart';
import 'package:clipboard/widgets/clip_item/clip_sync_status_footer.dart';
import 'package:clipboard/widgets/clip_item/clip_item_scope.dart';
import 'package:clipboard/widgets/clips_provider.dart';
import 'package:clipboard/widgets/drag_drop/drag_item.dart';
import 'package:clipboard/widgets/keyboard_shortcuts/space_enter_listener.dart';
import 'package:clipboard/widgets/local_user.dart';
import 'package:clipboard/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universal_io/io.dart';

class ClipCardBodyContent extends StatelessWidget {
  /// If true, the card will be rendered in a simplified way without
  /// loading other interactives.
  final bool liteMode;

  const ClipCardBodyContent({super.key, this.liteMode = false});

  @override
  Widget build(BuildContext context) {
    final item = ClipItemScope.of(context);
    final textTheme = context.textTheme;
    final child = liteMode
        ? ClipPreview(item: item)
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ClipCardOptionsHeader(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.displayTitle != null && !item.encrypted)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: padding8,
                          right: padding8,
                          top: padding2,
                          bottom: padding8,
                        ),
                        child: Text(
                          item.displayTitle!,
                          style: textTheme.titleSmall?.copyWith(
                            fontVariations: fontVarW700,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    Expanded(child: ClipPreview(item: item)),
                  ],
                ),
              ),
              const _SyncStatusFooter(),
            ],
          );

    // NOTE: drag and drop doesn't work in android for now
    final selected = context.select(
      (SelectedClipsCubit cubit) => cubit.isSelected(item),
    );
    if (!Platform.isAndroid && !selected) {
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
    final selected = context.select(
      (SelectedClipsCubit cubit) => cubit.isSelected(item),
    );
    if (selected) {
      return const SizedBox.shrink();
    }
    return DisableForLocalUser(child: ClipSyncStatusFooter(item: item));
  }
}

class ClipCardBody extends StatefulWidget {
  final ClipboardItem item;
  final bool focused;
  final bool selected;
  final int selectionIndex;
  final bool selectionActive;

  const ClipCardBody({
    super.key,
    required this.item,
    required this.focused,
    required this.selected,
    required this.selectionActive,
    required this.selectionIndex,
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

  Future<void> decryptItem(BuildContext context) async {
    final persitCubit = context.read<OfflinePersistenceCubit>();
    final appConfig = context.read<AppConfigCubit>();
    if (!appConfig.isE2EESetupDone) {
      InAppNotificationService.i.notify(
        NotificationMessage(
          id: "e2ee_no_setup",
          body: context.locale.app__ack__missing_e2e_setup,
        ),
      );
      return;
    }

    try {
      final item_ = await widget.item.decrypt();
      persitCubit.persist([item_]);
    } catch (e) {
      if (!context.mounted) return;
      InAppNotificationService.i.notify(
        NotificationMessage(
          id: "decryption_failed",
          body: Failure.fromException(e).message,
        ),
      );
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

    final selectedShape = RoundedRectangleBorder(
      side: BorderSide(
        color: focused || widget.selected
            ? focused
                  ? colors.primary
                  : colors.secondary
            : colors.outlineVariant,
        width: focused ? gridItemBorderWidth * 2 : gridItemBorderWidth,
        strokeAlign: BorderSide.strokeAlignInside,
      ),
      borderRadius: radius12,
    );

    return SpaceEnterListener(
      onSpace: (context) => widget.selectionActive
          ? toggleSelect(context)
          : preview(context, widget.item),
      onEnter: (context) => widget.selectionActive
          ? toggleSelect(context)
          : performPrimaryActionOnClip(context, widget.item, canPaste),
      onShiftSpace: (context) => toggleSelect(context),
      onShiftSpaceEnter: (context) => onShiftEnter(context),
      onShiftC: (context) => onShiftC(context, widget.item),
      child: Card.outlined(
        elevation: focused ? 2 : 0,
        shape: selectedShape,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          mouseCursor: SystemMouseCursors.click,
          focusColor: colors.surface,
          customBorder: selectedShape,
          onTap: !widget.selectionActive
              ? () => performPrimaryActionOnClip(context, widget.item, canPaste)
              : () => toggleSelect(context),
          // onLongPress: () => menu.openOptionDialog(context),
          onSecondaryTapUp: !widget.selectionActive
              ? (detail) async {
                  final menu = Menu.of(context);
                  if (isMobilePlatform) {
                    menu.openMenu(context);
                    return;
                  }
                  menu.openPopupMenu(context, detail.globalPosition);
                }
              : null,
          onFocusChange: onFocusChange,
          autofocus: widget.focused,
          child: HoverScopeProvider(
            builder: (context, hovered) => const ClipCardBodyContent(),
          ),
        ),
      ),
    );
  }
}
