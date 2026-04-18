import 'package:clipboard/base/bloc/selected_clips_cubit/selected_clips_cubit.dart';
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/paste_stack_cubit/paste_stack_cubit.dart';
import 'package:clipboard/base/constants/font_variations.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/clipboard_actions.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/select_clip_builder.dart'
    show SelectedClipBuilder;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectionAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget defaultChild;
  const SelectionAppbar({super.key, required this.defaultChild});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void clearSelection(BuildContext context) {
    context.read<SelectedClipsCubit>().clear();
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
                    final ordered = orderedSelectedClips(context, items);
                    clearSelection(context);
                    await context.read<PasteStackCubit>().replaceFromSelection(
                      ordered,
                    );
                  },
                  tooltip: 'Start Paste Stack',
                  icon: const Icon(Icons.vertical_align_top),
                ),
              width6,
              if (isDesktopPlatform && items.length > 1)
                BlocSelector<AppConfigCubit, AppConfigState, bool>(
                  selector: (state) {
                    final config = state.config;
                    return config.smartPaste &&
                        config.lastFocusedWindowId != null;
                  },
                  builder: (context, canPaste) {
                    if (!canPaste) return const SizedBox.shrink();
                    return IconButton(
                      onPressed: () async {
                        final ordered = orderedSelectedClips(context, items);
                        await pasteMultipleOnLastWindow(
                          context,
                          ordered,
                          clearSelection: true,
                        );
                      },
                      tooltip: 'Paste Multiple',
                      icon: const Icon(Icons.content_paste_go_outlined),
                    );
                  },
                ),
              width6,
              IconButton(
                onPressed: () => shareClipboardItems(context, items.toList()),
                tooltip: context.locale.app__share,
                icon: const Icon(Icons.ios_share),
              ),
              width6,
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
              width6,
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
