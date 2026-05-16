import 'package:flutter/material.dart';

const _emptyMessage = '';

typedef NotificationContentBuilder =
    NotificationContent Function(BuildContext context);

class NotificationContent {
  final String? title;
  final String body;

  NotificationContent({this.title, required this.body});

  String get render => title != null ? "$title\n$body" : body;
}

/// A model representing a notification message,
/// which can be displayed to the user.
class NotificationMessage extends NotificationContent {
  final String? id;

  final SnackBarAction? action;
  final VoidCallback? onClose;

  NotificationMessage({
    this.id,
    super.title,
    required super.body,
    this.action,
    this.onClose,
  });

  /// A model representing a notification message that is built using a
  /// builder function, allowing for dynamic content generation including localization
  /// based on the context.
  factory NotificationMessage.builder({
    required NotificationContentBuilder builder,
    String? id,
  }) {
    return BuildNotificationMessage(id: id, builder: builder);
  }

  NotificationContent get content =>
      NotificationContent(title: title, body: body);
}

/// A special type of [NotificationMessage] that uses a builder function
/// to generate its content dynamically.

class BuildNotificationMessage extends NotificationMessage {
  final NotificationContentBuilder builder;

  BuildNotificationMessage({super.id, required this.builder})
    : super(body: _emptyMessage);
}
