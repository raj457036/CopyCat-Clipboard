import 'package:clipboard/base/enums/notification.dart';
import 'package:flutter/widgets.dart';

const _emptyMessage = '';

typedef NotificationContentBuilder =
    NotificationContent Function(BuildContext context);

class NotificationContent {
  final String? title;
  final String body;

  NotificationContent({this.title, required this.body});
}

/// A model representing a notification message,
/// which can be displayed to the user.
class NotificationMessage extends NotificationContent {
  final String? id;

  final NotificationType type;
  final NotificationPriority priority;

  NotificationMessage({
    this.id,
    super.title,
    required super.body,
    this.type = NotificationType.info,
    this.priority = NotificationPriority.medium,
  });

  /// A model representing a notification message that is built using a
  /// builder function, allowing for dynamic content generation including localization
  /// based on the context.
  factory NotificationMessage.builder({
    required NotificationContentBuilder builder,
    String? id,
    NotificationType type = NotificationType.info,
    NotificationPriority priority = NotificationPriority.medium,
  }) {
    return BuildNotificationMessage(
      id: id,
      builder: builder,
      type: type,
      priority: priority,
    );
  }

  NotificationContent get content =>
      NotificationContent(title: title, body: body);
}

/// A special type of [NotificationMessage] that uses a builder function
/// to generate its content dynamically.

class BuildNotificationMessage extends NotificationMessage {
  final NotificationContentBuilder builder;

  BuildNotificationMessage({
    super.id,
    required this.builder,
    super.type,
    super.priority,
  }) : super(body: _emptyMessage);
}
