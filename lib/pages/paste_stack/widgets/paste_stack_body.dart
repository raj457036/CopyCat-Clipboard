import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/paste_stack_cubit/paste_stack_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/datetime_extension.dart';
import 'package:clipboard/widgets/clip_item/clip_card/clip_card_body.dart'
    show ClipCardBodyContent;
import 'package:clipboard/widgets/clip_item/clip_item_scope.dart';
import 'package:clipboard/widgets/clips_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasteStackBody extends StatelessWidget {
  const PasteStackBody({super.key});

  @override
  Widget build(BuildContext context) {
    const maxHeight = 250.0;
    return BlocSelector<AppConfigCubit, AppConfigState, DateTime?>(
      selector: (state) {
        switch (state) {
          case AppConfigLoaded(:final config):
            return config.pausedTill;
          default:
            return null;
        }
      },
      builder: (context, pausedTill) {
        final inActive = pausedTill != null;
        if (inActive) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(padding16),
              child: Text(
                context.locale.tray__tooltip__paused_till(
                  time: dateTimeFormatter().format(pausedTill),
                ),
                style: context.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return BlocBuilder<PasteStackCubit, PasteStackState>(
          builder: (context, state) {
            final items = state.items;
            return ClipsProvider(
              clips: items,
              child: ReorderableListView.builder(
                scrollCacheExtent: const ScrollCacheExtent.pixels(maxHeight),
                padding: context.isMobile
                    ? const EdgeInsets.all(padding8)
                    : inset12,
                itemCount: items.length,
                proxyDecorator: (child, index, animation) {
                  return Material(
                    type: MaterialType.transparency,
                    child: child,
                  );
                },
                onReorderItem: (oldIndex, newIndex) {
                  context.read<PasteStackCubit>().reorderItem(
                    oldIndex,
                    newIndex,
                  );
                },
                itemBuilder: (context, index) {
                  final item = items[index];
                  late final ShapeBorder shape;

                  switch (index) {
                    case 0 when items.length == 1:
                      shape = const RoundedRectangleBorder(
                        borderRadius: radius8,
                      );
                    case 0:
                      shape = const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                          bottom: Radius.circular(4),
                        ),
                      );
                    case _ when index == items.length - 1:
                      shape = const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(4),
                          bottom: Radius.circular(12),
                        ),
                      );
                    default:
                      shape = const RoundedRectangleBorder(
                        borderRadius: radius4,
                      );
                  }

                  return LimitedBox(
                    key: ValueKey(
                      "paste-stack-item-${item.created.millisecondsSinceEpoch}",
                    ),
                    maxHeight: maxHeight,
                    child: ClipItemScope(
                      item: item,
                      child: Card.filled(
                        color: context.colors.secondaryContainer,
                        clipBehavior: Clip.hardEdge,
                        elevation: 0,
                        shape: shape,
                        margin: const EdgeInsets.symmetric(vertical: padding2),
                        child: const ClipCardBodyContent(liteMode: true),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
