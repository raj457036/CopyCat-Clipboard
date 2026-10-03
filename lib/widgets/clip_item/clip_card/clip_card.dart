import 'package:clipboard/base/bloc/clip_collection_cubit/clip_collection_cubit.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/widgets/clip_item/clip_card/clip_card_body.dart';
import 'package:clipboard/widgets/clip_item/clip_item_scope.dart';
import 'package:clipboard/widgets/clip_item/clip_menu_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClipCard extends StatelessWidget {
  final bool autoFocus;
  final bool selected;
  final int selectionIndex;
  final bool selectionActive;
  final ClipboardItem item;
  final bool dragAndDropEnabled;

  const ClipCard({
    super.key,
    required this.item,
    this.autoFocus = true,
    this.selected = false,
    this.selectionActive = false,
    required this.selectionIndex,
    required this.dragAndDropEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final collectionColor = item.hasCollection
        ? context.select(
            (ClipCollectionCubit cubit) => cubit
                .findInState(
                  id: item.collectionId,
                  serverId: item.serverCollectionId,
                )
                ?.collectionColor,
          )
        : null;

    return ClipMenuProvider(
      item: item,
      child: ClipItemScope(
        item: item,
        collectionColor: collectionColor,
        child: ClipCardBody(
          item: item,
          focused: autoFocus,
          selected: selected,
          selectionActive: selectionActive,
          selectionIndex: selectionIndex,
          dragAndDropEnabled: dragAndDropEnabled,
        ),
      ),
    );
  }
}
