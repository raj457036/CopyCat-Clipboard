import 'package:clipboard/base/constants/strings/route_constants.dart'
    show RouteConstants;
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/model/route_payload.dart';
import 'package:clipboard/routes/routes.dart';
import 'package:clipboard/utils/common_extension.dart' show GoRouterExtension;
import 'package:flutter/widgets.dart';

Future<void> togglePasteStack(
  BuildContext context, [
  List<ClipboardItem>? initalItems,
]) async {
  final isActive = appRouter.location() == RouteConstants.pasteStack;
  if (isActive && appRouter.canPop()) {
    appRouter.pop();
    return;
  }
  if (!isActive) {
    await appRouter.pushNamed(
      RouteConstants.pasteStack,
      extra: RoutePayload(data: initalItems),
    );
    return;
  }
  appRouter.goNamed(RouteConstants.home);
}
