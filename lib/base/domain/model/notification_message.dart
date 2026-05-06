import 'package:clipboard/base/enums/notification.dart';

/// A model representing a notification message, which can be displayed to the user.
class NotificationMessage {
  final String? id;
  final String? title;
  final String body;
  final NotificationType type;
  final NotificationPriority priority;

  NotificationMessage({
    this.id,
    this.title,
    required this.body,
    this.type = NotificationType.info,
    this.priority = NotificationPriority.medium,
  });
}
