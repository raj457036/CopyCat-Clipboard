import 'package:clipboard/base/bloc/selected_clips_cubit/selected_clips_cubit.dart';
import 'package:clipboard/base/constants/font_variations.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/model/route_payload.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/clipboard_actions.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/multi_paste/multi_paste_button.dart';
import 'package:clipboard/widgets/responsive_action_bar.dart';
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

  // Define all possible actions
  List<ActionItem> _buildAllActions(
    BuildContext context,
    Iterable<ClipboardItem> items,
  ) {
    return [
      if (isDesktopPlatform)
        ActionItem(
          key: 'pasteStack',
          label:
              'Move to Paste Stack • ${keyboardShortcut(meta: true, shift: true, key: 'C')}',
          icon: Icons.line_weight_rounded,
          action: () {
            clearSelection(context);
            context.pushNamed(
              RouteConstants.pasteStack,
              extra: RoutePayload(data: items.toList()),
            );
          },
        ),
      if (items.length > 1)
        ActionItem(
          key: 'copyAll',
          label: context.mlocale.copyButtonLabel,
          icon: Icons.copy_all_outlined,
          action: () async {
            clearSelection(context);
            await multiCopyToClipboard(context, items.toList());
          },
        ),
      if (isDesktopPlatform && items.length > 1)
        ActionItem(
          key: 'multiPaste',
          label: 'Multi-Paste',
          icon: Icons.paste,
          isCustomButton: true,
          customButton: MultiPasteButton(
            items: items.toList(),
            onPasteComplete: () => clearSelection(context),
          ),
          action: () {},
        ),
      ActionItem(
        key: 'share',
        label: context.locale.app__share,
        icon: Icons.ios_share,
        action: () => shareClipboardItems(context, items.toList()),
      ),
      ActionItem(
        key: 'changeCollection',
        label: context.locale.app__change_collection,
        icon: Icons.collections_bookmark,
        action: () async {
          await changeCollection(context, items.toList());
          if (context.mounted) {
            clearSelection(context);
          }
        },
      ),
      ActionItem(
        key: 'delete',
        label: context.locale.app__delete,
        icon: Icons.delete,
        action: () async {
          final done = await deleteClipboardItem(context, items.toList());
          if (done && context.mounted) {
            clearSelection(context);
          }
        },
      ),
    ];
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
            title: Row(
              children: [
                Text("${items.length}"),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ResponsiveActionBar(
                      actions: _buildAllActions(context, items),
                    ),
                  ),
                ),
              ],
            ),
            scrolledUnderElevation: 0,
            titleSpacing: 0,
            titleTextStyle: textTheme.titleLarge?.copyWith(
              fontVariations: fontVarW700,
            ),
          );
        }
        return defaultChild;
      },
    );
  }
}
