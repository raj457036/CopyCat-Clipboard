import 'dart:async';
import 'dart:convert' show utf8, base64;

import 'package:app_links/app_links.dart';
import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/bloc/drive_setup_cubit/drive_setup_cubit.dart';
import 'package:clipboard/base/common/logging.dart';
import 'package:clipboard/base/constants/key.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/utils/utility.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/snackbar.dart';
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

    final Map<String, String> payload;
    if (payloadString != null) {
      final query = utf8.decode(base64.decode(payloadString));
      payload = Uri.splitQueryString(query);
    } else {
      payload = uri.queryParameters;
    }

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
    } else if (uri.host == "reset-password") {
      final code = payload["code"];
      if (code != null) {
        final (path, failure) =
            await context.read<AuthCubit>().validateAuthCode(code);
        if (path != null) {
          router.pushNamed(path);
        }
        if (failure != null) {
          logger.e("Failed to validate auth code: $failure");
          showFailureSnackbar(failure);
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
