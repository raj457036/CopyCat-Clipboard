import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:flutter/material.dart';

/// A widget that shows a paste chip sliding in from the bottom when [showPasteChip] is true.
class PasteChipSlideIn extends StatelessWidget {
  final Widget child;
  final bool showPasteChip;
  final bool isCentered;

  const PasteChipSlideIn({
    super.key,
    required this.child,
    required this.showPasteChip,
    this.isCentered = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!isDesktopPlatform) return child;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        child,
        Positioned(
          bottom: isCentered ? 0 : padding10,
          left: 0,
          right: 0,
          top: isCentered ? 0 : null,
          child: IgnorePointer(
            ignoring: !showPasteChip,
            child: AnimatedOpacity(
              duration: Durations.short3,
              curve: Curves.easeOut,
              opacity: showPasteChip ? 1 : 0,
              child: AnimatedSlide(
                duration: Durations.short3,
                curve: Curves.easeOut,
                offset: showPasteChip ? Offset.zero : const Offset(0, 0.1),
                child: Chip(
                  avatar: const Icon(Icons.paste, size: 16),
                  label: Text(context.mlocale.pasteButtonLabel),
                  visualDensity: VisualDensity.compact,
                  shape: const StadiumBorder(),
                  mouseCursor: SystemMouseCursors.click,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
