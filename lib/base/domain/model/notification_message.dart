import 'package:flutter/material.dart';

const _emptyMessage = '';

typedef NotificationContentBuilder =
    NotificationContent Function(BuildContext context);

class NotificationContent {
  final String? title;
  final String body;
  final SnackBarAction? action;

  NotificationContent({this.title, required this.body, this.action});

  String get render => title != null ? "$title\n$body" : body;
}

/// A model representing a notification message,
/// which can be displayed to the user.
class NotificationMessage extends NotificationContent {
  final String? id;
  final VoidCallback? onClose;
  final bool persistent;

  NotificationMessage({
    this.id,
    super.title,
    required super.body,
    super.action,
    this.onClose,
    this.persistent = false,
  });

  /// A model representing a notification message that is built using a
  /// builder function, allowing for dynamic content generation including localization
  /// based on the context.
  factory NotificationMessage.builder({
    required NotificationContentBuilder builder,
    String? id,
    SnackBarAction? action,
    VoidCallback? onClose,
    bool persistent = false,
  }) {
    return BuildNotificationMessage(
      id: id,
      builder: builder,
      action: action,
      onClose: onClose,
      persistent: persistent,
    );
  }

  NotificationContent get content =>
      NotificationContent(title: title, body: body, action: action);
}

/// A special type of [NotificationMessage] that uses a builder function
/// to generate its content dynamically.

class BuildNotificationMessage extends NotificationMessage {
  final NotificationContentBuilder builder;

  BuildNotificationMessage({
    super.id,
    required this.builder,
    super.action,
    super.onClose,
    super.persistent,
  }) : super(body: _emptyMessage);
}
