import 'package:clipboard/base/constants/strings/route_constants.dart'
    show RouteConstants;
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/model/route_payload.dart';
import 'package:clipboard/routes/routes.dart';
import 'package:clipboard/utils/common_extension.dart' show GoRouterExtension;
import 'package:clipboard/utils/common_extension.dart'
    show BuildContextExtension;
import 'package:flutter/widgets.dart';

Future<void> togglePasteStack(
  BuildContext context, [
  List<ClipboardItem>? initalItems,
]) async {
  final windowAction = context.windowAction;
  final isActive = appRouter.location() == RouteConstants.pasteStack;

  if (isActive) {
    final backgroundMode =
        windowAction?.isPasteStackBackgroundToggleMode ?? false;

    if (backgroundMode) {
      final focused = windowAction?.isFocused ?? false;
      if (focused) {
        await windowAction?.hidePasteStackView();
      } else {
        await windowAction?.showPasteStackView();
      }
      return;
    }

    if (appRouter.canPop()) {
      appRouter.pop();
      return;
    }

    appRouter.goNamed(RouteConstants.home);
    return;
  }

  if (!isActive) {
    await appRouter.pushNamed(
      RouteConstants.pasteStack,
      extra: RoutePayload(data: initalItems),
    );
    return;
  }
}
