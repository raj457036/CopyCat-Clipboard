import 'dart:async';
import 'dart:convert' show utf8, base64;

import 'package:app_links/app_links.dart';
import 'package:copycat_base/bloc/auth_cubit/auth_cubit.dart';
import 'package:copycat_base/bloc/drive_setup_cubit/drive_setup_cubit.dart';
import 'package:copycat_base/common/logging.dart';
import 'package:copycat_base/constants/key.dart';
import 'package:copycat_base/constants/strings/route_constants.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:copycat_base/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ApplinkListener {
  late final StreamSubscription sub;
  final appLink = AppLinks();

  BuildContext get context => rootNavKey.currentContext!;

  Future<void> onUri(Uri uri) async {
    logger.w("🔗 NEW APP LINK: $uri");
    // return;
    final router = GoRouter.of(context);
    if (isDesktopPlatform) {
      await context.windowAction?.show();
    }

    await Future.delayed(Durations.medium1);

    final payloadString = uri.pathSegments.firstOrNull;

    if (payloadString == null) return;

    final query = utf8.decode(base64.decode(payloadString));
    final payload = Uri.splitQueryString(query);

    if (!context.mounted) return;
    // clipboard://drive-connect?code=4/0AeaYSHB-QUSzN0WX8F-R7Y-64KkUUgAgT5lrHXVmrgFPr7mJIM9p_aHJJpKg0XXBuytu1Q&scope=https://www.googleapis.com/auth/drive.appdata%20https://www.googleapis.com/auth/drive.file
    if (uri.host == "drive-connect") {
      final code = payload["code"];
      final scope = payload["scope"];

      if (code != null && scope != null) {
        router.goNamed(
          RouteConstants.driveConnect,
          pathParameters: {"code": code},
          queryParameters: {"scopes": scope},
        );
        return;
      }
      final error = payload["error"];
      if (error != null) {
        context.read<DriveSetupCubit>().setupError(error);
      }
    } else if (uri.host == "auth") {
      final code = payload["code"];
      if (code != null) {
        final path = await context.read<AuthCubit>().validateAuthCode(code);
        if (path != null) {
          router.pushNamed(path);
        }
      }
    }
  }

  void init() {
    sub = appLink.uriLinkStream.listen(onUri);
  }

  void dispose() {
    sub.cancel();
  }
}
