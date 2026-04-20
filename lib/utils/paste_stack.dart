import 'package:clipboard/base/constants/strings/route_constants.dart'
    show RouteConstants;
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/model/route_payload.dart';
import 'package:clipboard/utils/common_extension.dart'
    show BuildContextExtension;
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart' show GoRouterHelper;

Future<void> togglePasteStack(
  BuildContext context, [
  List<ClipboardItem>? initalItems,
]) async {
  final isActive = context.location == RouteConstants.pasteStack;
  if (context.canPop() && isActive) {
    context.pop();
  } else if (!isActive) {
    await context.pushNamed(
      RouteConstants.pasteStack,
      extra: RoutePayload(data: initalItems),
    );
  } else {
    context.goNamed(RouteConstants.home);
  }
}
