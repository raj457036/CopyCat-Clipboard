import 'dart:async';

import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/db/app_config/appconfig.dart';
import 'package:clipboard/base/db/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/base/widgets/clip_cards/file_clip_card.dart';
import 'package:clipboard/base/widgets/clip_cards/media_clip_card.dart';
import 'package:clipboard/base/widgets/subscription/subscription_provider.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';
import 'package:universal_io/io.dart';

class DraggableItem extends StatelessWidget {
  final ClipboardItem item;
  final Widget child;

  const DraggableItem({
    super.key,
    required this.item,
    required this.child,
  });

  Widget previewBuilder(BuildContext context, Widget child) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    late Widget content;
    switch (item.type) {
      case ClipItemType.text:
      case ClipItemType.url:
        content = Center(
          child: Padding(
            padding: const EdgeInsets.all(padding12),
            child: Text(
              item.text ?? item.url!,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurface,
              ),
            ),
          ),
        );

      case ClipItemType.media:
        content = ClipRRect(
          borderRadius: radius12,
          child: MediaClipCard(item: item, layout: AppLayout.grid),
        );

      case ClipItemType.file:
        content = FileClipCard(item: item, layout: AppLayout.grid);
    }

    return SizedBox.square(
      dimension: 150,
      child: Card.outlined(child: content),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (item.needDownload) return child;

    // final side = context.mq.size.shortestSide;
    // final isTablet = side > Breakpoints.sm;
    if (Platform.isAndroid) return child;

    return BlocSelector<AppConfigCubit, AppConfigState, bool>(
        selector: (state) {
      switch (state) {
        case AppConfigLoaded(:final config):
          return config.enableDragNDrop;
        default:
          return false;
      }
    }, builder: (context, enabled) {
      if (!enabled) return child;
      return SubscriptionBuilder(
        builder: (context, subscription) {
          if (subscription == null) return child;
          if (subscription.isActive && subscription.dragNdrop) {
            return DragItemWidget(
              canAddItemToExistingSession: true,
              dragItemProvider: dragItemProvider,
              allowedOperations: () => const [
                DropOperation.copy,
                // DropOperation.userCancelled,
              ],
              liftBuilder: previewBuilder,
              dragBuilder: previewBuilder,
              child: DraggableWidget(child: child),
            );
          }
          return child;
        },
      );
    });
  }

  FutureOr<DragItem?> dragItemProvider(request) async {
    final dragItem = DragItem(localData: {"itemId": item.id});

    switch (item.type) {
      case ClipItemType.text:
        dragItem.add(Formats.plainText(item.text!));

      case ClipItemType.url:
        dragItem.add(
          Formats.uri(
            NamedUri(Uri.parse(item.url!), name: item.title),
          ),
        );

      case ClipItemType.media:
      case ClipItemType.file:
        final fileUri = Formats.fileUri(
          Uri.file(
            item.localPath!,
            windows: Platform.isWindows,
          ),
        );
        dragItem.add(fileUri);
    }

    return dragItem;
  }
}
