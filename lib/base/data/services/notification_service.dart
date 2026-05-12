import 'package:clipboard/base/constants/numbers/breakpoints.dart'
    show Breakpoints;
import 'package:clipboard/base/domain/model/notification_message.dart';
import 'package:clipboard/routes/routes.dart' show rootNavigationKey;
import 'package:clipboard/utils/common_extension.dart'
    show BuildContextExtension, ListExtension;
import 'package:clipboard/utils/utility.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ActiveNotification with EquatableMixin {
  final NotificationMessage message;
  final ScaffoldFeatureController<SnackBar, SnackBarClosedReason> controller;

  ActiveNotification(this.message, this.controller);

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
  BuildContext get _context => rootNavigationKey.currentContext!;

  /// MARK: - NotificationService Implementation

  EdgeInsets? _getSnackBarMargin() {
    final mq = _context.mq;
    const double snackBarWidth = 480.0;
    final double horizontalMargin = (mq.size.width - snackBarWidth) / 2;
    if (!Breakpoints.isMobile(mq.size.width)) {
      return EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: 8.0);
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
    final notification = _activeNotifications.findFirst(
      (active) => active.message.id == id,
    );
    if (notification == null) return;

    notification.controller.close();
  }

  /// Displays a notification message to the user using a SnackBar.
  /// If a notification with the same ID is already active, it will be replaced.
  void notify(NotificationMessage message) {
    if (_activeNotifications.any((active) => active.message.id == message.id)) {
      return;
    }

    late final NotificationContent content;

    if (message is BuildNotificationMessage) {
      content = message.builder(_context);
    } else {
      content = message.content;
    }

    final colors = _context.colors;

    final snackbar = SnackBar(
      content: Text(content.body),
      backgroundColor: colors.primary,
      behavior: isMobilePlatform
          ? SnackBarBehavior.fixed
          : SnackBarBehavior.floating,
      margin: _getSnackBarMargin(),
    );

    final controller = _scaffoldMessenger.showSnackBar(snackbar);
    final activeNotification = ActiveNotification(message, controller);
    _activeNotifications.add(activeNotification);

    controller.closed.then((reason) {
      _activeNotifications.remove(activeNotification);
    });
  }
}
