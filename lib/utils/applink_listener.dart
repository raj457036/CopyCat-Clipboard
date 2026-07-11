import 'dart:async';
import 'dart:convert' show utf8, base64;

import 'package:app_links/app_links.dart';
import 'package:clipboard/base/bloc/auth_cubit/auth_cubit.dart';
import 'package:clipboard/base/bloc/drive_setup_cubit/drive_setup_cubit.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/data/services/notification_service.dart'
    show InAppNotificationService;
import 'package:clipboard/base/domain/model/notification_message.dart'
    show NotificationMessage;
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/routes/routes.dart' show appRouter, rootNavigationKey;
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApplinkListener {
  late final StreamSubscription sub;
  final appLink = AppLinks();
  String? _lastProcessedUri;

  BuildContext? get context => rootNavigationKey.currentContext;

  Map<String, String> _parsePayload(Uri uri) {
    final payloadString = uri.pathSegments.firstOrNull;
    if (payloadString == null) return uri.queryParameters;

    try {
      final normalized = base64.normalize(payloadString);
      final query = utf8.decode(base64.decode(normalized));
      return Uri.splitQueryString(query);
    } catch (e) {
      logger.w(
        "Failed to parse app link payload. Falling back to query params: $e",
      );
      return uri.queryParameters;
    }
  }

  Future<void> onUri(Uri uri) async {
    if (_lastProcessedUri == uri.toString()) return;
    _lastProcessedUri = uri.toString();

    logger.d("🔗 NEW APP LINK: $uri");
    final currentContext = context;
    if (currentContext == null) return;

    if (isDesktopPlatform) {
      await currentContext.windowAction?.show();
    }

    await wait(Durations.medium1.inMilliseconds);

    final payload = _parsePayload(uri);

    if (!currentContext.mounted) return;
    // clipboard://drive-connect?code=4/0AeaYSHB-QUSzN0WX8F-R7Y-64KkUUgAgT5lrHXVmrgFPr7mJIM9p_aHJJpKg0XXBuytu1Q&scope=https://www.googleapis.com/auth/drive.appdata%20https://www.googleapis.com/auth/drive.file
    if (uri.host == "drive-connect") {
      final code = payload["code"];
      final scope = payload["scope"] ?? payload["scopes"];

      if (code != null && scope != null && scope.trim().isNotEmpty) {
        appRouter.goNamed(
          RouteConstants.driveConnect,
          pathParameters: {"code": code},
          queryParameters: {"scopes": scope},
        );
        return;
      }
      final error = payload["error"];
      if (error != null) {
        currentContext.read<DriveSetupCubit>().setupError(error);
      }
    } else if (uri.host == "reset-password") {
      final code = payload["code"];
      if (code != null) {
        final (path, failure) = await currentContext
            .read<AuthCubit>()
            .validateAuthCode(code);
        if (path != null) {
          appRouter.pushNamed(path);
        }
        if (failure == null) return;
        logger.e("Failed to validate auth code: $failure");
        InAppNotificationService.i.notify(
          NotificationMessage(
            id: "auth_code_validation_error",
            body: failure.message,
          ),
        );
      }
    }
  }

  void init() {
    unawaited(
      appLink
          .getInitialLink()
          .then((initialUri) {
            if (initialUri != null) {
              return onUri(initialUri);
            }
          })
          .catchError((e) {
            logger.w("Failed to read initial app link: $e");
          }),
    );
    sub = appLink.uriLinkStream.listen(onUri);
  }

  void dispose() {
    sub.cancel();
  }
}
