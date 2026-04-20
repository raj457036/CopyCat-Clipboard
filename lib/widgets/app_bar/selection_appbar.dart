import 'package:clipboard/base/bloc/selected_clips_cubit/selected_clips_cubit.dart';
import 'package:clipboard/base/constants/font_variations.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/route_payload.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/clipboard_actions.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/multi_paste/multi_paste_button.dart';
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
                  onPressed: () {
                    clearSelection(context);
                    context.pushNamed(
                      RouteConstants.pasteStack,
                      extra: RoutePayload(data: items.toList()),
                    );
                  },
                  tooltip:
                      'Move to Paste Stack • ${keyboardShortcut(meta: true, shift: true, key: "C")}',
                  icon: const Icon(Icons.line_weight_rounded),
                ),
              width6,
              if (items.length > 1)
                IconButton(
                  onPressed: () async {
                    clearSelection(context);
                    await multiCopyToClipboard(context, items.toList());
                  },
                  tooltip:
                      "${context.mlocale.copyButtonLabel} • ${keyboardShortcut(meta: false, shift: true, key: "C")}",
                  icon: const Icon(Icons.copy_all_outlined),
                ),
              if (items.length > 1) width6,
              if (isDesktopPlatform && items.length > 1)
                MultiPasteButton(
                  items: items.toList(),
                  onPasteComplete: () => clearSelection(context),
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
