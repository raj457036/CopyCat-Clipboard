import 'package:clipboard/widgets/clip_item/clip_create_time.dart';
import 'package:clipboard/base/bloc/selected_clips_cubit/selected_clips_cubit.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeadingClipboardOption extends StatelessWidget {
  final ClipboardItem item;
  final DateTime created;
  final bool hovered;
  final EdgeInsets? createdPadding;
  final EdgeInsets? padding;
  final bool selected;
  final int selectionIndex;

  const LeadingClipboardOption({
    super.key,
    required this.item,
    this.hovered = false,
    this.createdPadding,
    this.padding,
    this.selected = false,
    required this.selectionIndex,
    required this.created,
  });

  void toggleSelect(BuildContext context) {
    final cubit = context.read<SelectedClipsCubit>();
    if (selected) {
      cubit.unselect(item);
      return;
    }
    cubit.select(item);
  }

  String selectedOrderLabel() {
    final order = selectionIndex + 1;
    if (order <= 0) return "";
    if (order > 99) return "99+";
    return "$order";
  }

  @override
  Widget build(BuildContext context) {
    const iconSize = 24.0;
    final colors = context.colors;
    final order = selectionIndex + 1;
    final orderLabel = selectedOrderLabel();
    if (hovered || selected) {
      return SizedBox.square(
        dimension: iconSize * 1.44,
        child: Focus(
          canRequestFocus: false,
          descendantsAreTraversable: false,
          child: IconButton(
            isSelected: selected,
            style: IconButton.styleFrom(padding: EdgeInsets.zero),
            iconSize: iconSize,
            tooltip: selected
                ? "${context.locale.app__select} #$order"
                : context.locale.app__select,
            onPressed: () => toggleSelect(context),
            selectedIcon: _SelectionOrderBadge(
              label: orderLabel,
              compact: order > 99,
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
            ),
            icon: const Icon(Icons.circle_outlined),
          ),
        ),
      );
    }

    final createTime = ClipCreateTime(
      created: created,
      padding: createdPadding,
    );

    return createTime;
  }
}

class _SelectionOrderBadge extends StatelessWidget {
  final String label;
  final bool compact;
  final Color backgroundColor;
  final Color foregroundColor;

  const _SelectionOrderBadge({
    required this.label,
    required this.compact,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 12,
      backgroundColor: backgroundColor,
      child: Text(
        label,
        style: TextStyle(
          color: foregroundColor,
          fontSize: compact ? 8.5 : 10,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}
