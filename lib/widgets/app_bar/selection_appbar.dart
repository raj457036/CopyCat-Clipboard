import 'package:clipboard/base/bloc/paste_stack_cubit/paste_stack_cubit.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/bloc/selected_clips_cubit/selected_clips_cubit.dart';
import 'package:clipboard/base/constants/font_variations.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/db/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/clipboard_actions.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/clips_provider.dart';
import 'package:clipboard/widgets/select_clip_builder.dart'
    show SelectedClipBuilder;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SelectionAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget defaultChild;
  const SelectionAppbar({super.key, required this.defaultChild});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void clearSelection(BuildContext context) {
    context.read<SelectedClipsCubit>().clear();
  }

  List<ClipboardItem> orderedSelection(
    BuildContext context,
    Set<ClipboardItem> items,
  ) {
    final clips = ClipsProvider.of(context)?.clips;
    if (clips == null || clips.isEmpty) {
      return items.toList();
    }

    return clips.where(items.contains).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return SelectedClipBuilder(
      builder: (context, items) {
        if (items.isNotEmpty) {
          return AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => clearSelection(context),
            ),
            centerTitle: false,
            title: Text("${items.length}"),
            scrolledUnderElevation: 0,
            titleSpacing: 0,
            titleTextStyle: textTheme.titleLarge?.copyWith(
              fontVariations: fontVarW700,
            ),
            actions: [
              if (isDesktopPlatform)
                IconButton(
                  onPressed: () async {
                    final orderedItems = orderedSelection(context, items);
                    await context.read<PasteStackCubit>().replaceFromSelection(
                      orderedItems,
                    );
                    if (context.mounted) {
                      clearSelection(context);
                      context.goNamed(RouteConstants.home);
                    }
                  },
                  tooltip: 'Start Paste Stack',
                  icon: const Icon(Icons.vertical_align_top),
                ),
              IconButton(
                onPressed: () => shareClipboardItems(context, items.toList()),
                tooltip: context.locale.app__share,
                icon: const Icon(Icons.ios_share),
              ),
              IconButton(
                onPressed: () async {
                  await changeCollection(context, items.toList());
                  if (context.mounted) {
                    clearSelection(context);
                  }
                },
                tooltip: context.locale.app__change_collection,
                icon: const Icon(Icons.collections_bookmark),
              ),
              IconButton(
                onPressed: () async {
                  final done = await deleteClipboardItem(
                    context,
                    items.toList(),
                  );
                  if (done && context.mounted) {
                    clearSelection(context);
                  }
                },
                tooltip: context.locale.app__delete,
                icon: const Icon(Icons.delete),
              ),
              width12,
            ],
          );
        }
        return defaultChild;
      },
    );
  }
}
