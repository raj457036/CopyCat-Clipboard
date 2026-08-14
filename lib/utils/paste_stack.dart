import 'dart:async';

import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart'
    show RouteConstants;
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/model/route_payload.dart';
import 'package:clipboard/routes/routes.dart';
import 'package:clipboard/utils/common_extension.dart' show GoRouterExtension;
import 'package:clipboard/utils/common_extension.dart'
    show BuildContextExtension;
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> togglePasteStack(
  BuildContext context, [
  List<ClipboardItem>? initialItems,
]) async {
  final windowAction = context.windowAction;
  final isActive = appRouter.location() == RouteConstants.pasteStack;
  final isPinned = context.read<AppConfigCubit>().state.config.pinned;

  if (isActive) {
    final backgroundMode =
        windowAction?.isPasteStackBackgroundToggleMode ?? false;

    if (backgroundMode) {
      final focused = windowAction?.isFocused ?? false;
      if (focused) {
        await windowAction?.hidePasteStackView(alreadyPinned: isPinned);
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
  } else {
    await windowAction?.show();
    unawaited(
      appRouter.pushNamed(
        RouteConstants.pasteStack,
        extra: RoutePayload(data: initialItems),
      ),
    );
    return;
  }
}
