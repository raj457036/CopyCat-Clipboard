import 'dart:async';

import 'package:clipboard/base/constants/numbers/breakpoints.dart'
    show Breakpoints;
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/notification_message.dart';
import 'package:clipboard/common/globals.dart';
import 'package:clipboard/routes/routes.dart' show rootNavigationKey;
import 'package:clipboard/utils/common_extension.dart'
    show BreakpointExtension, BuildContextExtension, ListExtension;
import 'package:clipboard/utils/utility.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ActiveNotification extends Equatable {
  final NotificationMessage message;
  final ScaffoldFeatureController<SnackBar, SnackBarClosedReason> controller;

  const ActiveNotification(this.message, this.controller);

  @override
  List<Object?> get props => [message.id];
}

class InAppNotificationService {
  final List<ActiveNotification> _activeNotifications = [];

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  InAppNotificationService._();

  static final InAppNotificationService _instance =
      InAppNotificationService._();

  static InAppNotificationService get i => _instance;

  ScaffoldMessengerState get _scaffoldMessenger =>
      scaffoldMessengerKey.currentState!;
  BuildContext? get _context => rootNavigationKey.currentContext;

  /// MARK: - NotificationService Implementation

  EdgeInsets? _getSnackBarMargin() {
    if (_context == null) return null;
    final mq = _context!.mq;
    const double snackBarWidth = 580.0;
    if (!Breakpoints.isMobile(mq.size.width)) {
      // Desktop
      final double horizontalMargin = (mq.size.width - snackBarWidth) / 2;
      return EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: 16.0);
    }
    return null;
  }

  void dismissAll() {
    while (_activeNotifications.isNotEmpty) {
      _activeNotifications.removeLast().controller.close();
    }
  }

  /// Dismisses the notification with the given ID, if it is currently active.
  void dismiss(String id) {
    try {
      final notification = _activeNotifications.findFirst(
        (active) => active.message.id == id,
      );
      if (notification == null) return;

      notification.controller.close();
    } catch (e) {
      debugPrint('Error dismissing notification: $e');
    }
  }

  SnackBar _buildSnackBar(NotificationMessage message) {
    late final NotificationContent messageContent;
    final flat = isMobilePlatform || _context?.isMobile == true;
    final SnackBarBehavior behavior = flat
        ? SnackBarBehavior.fixed
        : SnackBarBehavior.floating;

    if (message is BuildNotificationMessage) {
      messageContent = message.builder(_context!);
    } else {
      messageContent = message.content;
    }

    final Widget snackbarContent = Text(messageContent.render);

    return SnackBar(
      content: snackbarContent,
      showCloseIcon: isDesktopPlatform,
      behavior: behavior,
      margin: !flat ? _getSnackBarMargin() : null,
      shape: flat ? null : const RoundedRectangleBorder(borderRadius: radius16),
      action: message.action ?? messageContent.action,
      persist: message.persistent,
    );
  }

  Future<void> _notify(NotificationMessage message) async {
    await windowSizeStabilized();

    if (_activeNotifications.any((active) => active.message.id == message.id) ||
        _context == null) {
      return;
    }

    final snackbar = _buildSnackBar(message);

    final controller = _scaffoldMessenger.showSnackBar(snackbar);
    final activeNotification = ActiveNotification(message, controller);
    _activeNotifications.add(activeNotification);

    controller.closed.then((reason) {
      activeNotification.message.onClose?.call();
      _activeNotifications.remove(activeNotification);
    });
  }

  /// Displays a notification message to the user using a SnackBar.
  /// If a notification with the same ID is already active, it will be replaced.
  void notify(NotificationMessage message) {
    unawaited(_notify(message));
  }
}
