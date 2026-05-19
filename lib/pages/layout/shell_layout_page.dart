import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/network_observer.dart';
import 'package:clipboard/widgets/titlebar.dart';
import 'package:flutter/material.dart';

class ShellPage extends StatelessWidget {
  final Widget child;

  const ShellPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    Widget child_ = NetworkObserver(child: child);

    if (isDesktopPlatform) {
      final hideToggles = context.location == RouteConstants.pasteStack;
      child_ = TitlebarView(
        hidePinToggle: hideToggles,
        hideLayoutToggle: hideToggles,
        hideTabToggle: hideToggles,
        hideViewToggle: hideToggles,
        child: child_,
      );
    }
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        logger.i(() => "[Shell Route] DID POP: $didPop");
      },
      child: FocusScope(autofocus: true, child: child_),
    );
  }
}
