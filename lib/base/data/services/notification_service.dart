import 'dart:async';

import 'package:clipboard/base/domain/model/notification_message.dart';
import 'package:clipboard/common/globals.dart';
import 'package:clipboard/routes/routes.dart' show rootNavigationKey;
import 'package:clipboard/utils/common_extension.dart'
    show BreakpointExtension, ListExtension;
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
  static final List<GlobalKey<ScaffoldMessengerState>> _scaffoldMessengerKeys =
      [];

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  InAppNotificationService._();

  static final InAppNotificationService _instance =
      InAppNotificationService._();

  static InAppNotificationService get i => _instance;

  static GlobalKey<ScaffoldMessengerState> get mintScaffoldMessengerKey {
    final key = GlobalKey<ScaffoldMessengerState>();
    _scaffoldMessengerKeys.add(key);
    return key;
  }

  static void removeScaffoldMessengerKey(
    GlobalKey<ScaffoldMessengerState> key,
  ) {
    _scaffoldMessengerKeys.remove(key);
  }

  ScaffoldMessengerState? _resolveScaffoldMessengerState() {
    for (final key in _scaffoldMessengerKeys.reversed) {
      final currentState = key.currentState;
      if (currentState != null) {
        return currentState;
      }
    }
    return scaffoldMessengerKey.currentState;
  }

  ScaffoldMessengerState get _scaffoldMessenger {
    final messenger = _resolveScaffoldMessengerState();
    if (messenger != null) {
      return messenger;
    }
    throw StateError('No scaffold messenger is currently available');
  }

  BuildContext? get _context {
    for (final key in _scaffoldMessengerKeys.reversed) {
      final context = key.currentContext;
      if (context != null) {
        return context;
      }
    }
    return rootNavigationKey.currentContext;
  }

  /// MARK: - NotificationService Implementation

  void dismissAll() {
    while (_activeNotifications.isNotEmpty) {
      try {
        _activeNotifications.removeLast().controller.close();
      } catch (e) {
        debugPrint('Error dismissing notification: $e');
      }
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
      shape: flat ? null : const StadiumBorder(),
      action: message.action ?? messageContent.action,
      persist: message.persistent,
    );
  }

  Future<void> _notify(NotificationMessage message) async {
    await windowSizeStabilized();

    if (_activeNotifications.any((active) => active.message.id == message.id) ||
        _context == null) {
      dismiss(message.id!);
    }

    final snackbar = _buildSnackBar(message);

    final controller = _scaffoldMessenger.showSnackBar(snackbar);
    final activeNotification = ActiveNotification(message, controller);
    _activeNotifications.add(activeNotification);

    unawaited(
      Future.delayed(snackbar.duration, () {
        if (_activeNotifications.contains(activeNotification)) {
          _activeNotifications.remove(activeNotification);
        }
      }),
    );
    unawaited(
      controller.closed.then((reason) {
        activeNotification.message.onClose?.call();
      }),
    );
  }

  /// Displays a notification message to the user using a SnackBar.
  /// If a notification with the same ID is already active, it will be replaced.
  void notify(NotificationMessage message) {
    unawaited(_notify(message));
  }
}
