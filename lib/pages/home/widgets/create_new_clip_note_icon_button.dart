import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_io/io.dart';

class CreateNewClipNoteIconButton extends StatelessWidget {
  final bool compact;

  const CreateNewClipNoteIconButton({super.key, this.compact = false});

  Future<void> _navigateToCreateClipNotePage(BuildContext context) async {
    await context.pushNamed(RouteConstants.createClipNote);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const size = Size.square(32);

    if (compact) {
      return IconButton(
        onPressed: () async => await _navigateToCreateClipNotePage(context),
        icon: const Icon(Icons.add),
        style: IconButton.styleFrom(
          foregroundColor: context.colors.onSecondaryContainer,
          backgroundColor: context.colors.secondaryContainer,
          enabledMouseCursor: SystemMouseCursors.click,
          disabledMouseCursor: SystemMouseCursors.forbidden,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: size,
          maximumSize: size,
          padding: const EdgeInsets.all(padding2),
        ),
        iconSize: 18,
        tooltip: isDesktopPlatform
            ? "${context.locale.create_clip__appbar__title__new} • "
                  "${keyboardShortcut(key: "N", meta: Platform.isMacOS, ctrl: !Platform.isMacOS)}"
            : context.locale.create_clip__appbar__title__new,
      );
    }

    return IconButton(
      onPressed: () async => await _navigateToCreateClipNotePage(context),
      icon: const Icon(Icons.add),
      style: IconButton.styleFrom(
        backgroundColor: colors.surfaceContainerHighest,
        maximumSize: const Size.square(kToolbarHeight),
        padding: const EdgeInsets.all(padding10),
      ),
      tooltip: isDesktopPlatform
          ? "${context.locale.create_clip__appbar__title__new} • "
                "${keyboardShortcut(key: "N", meta: Platform.isMacOS, ctrl: !Platform.isMacOS)}"
          : context.locale.create_clip__appbar__title__new,
    );
  }
}
