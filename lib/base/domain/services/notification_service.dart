import 'package:clipboard/base/domain/model/notification_message.dart';

/// Service for managing notifications within the app.
abstract class NotificationService {
  /// Sends a notification with the given [message].
  void notify(NotificationMessage message);

  /// Dismisses a notification with the given [id].
  void dismiss(String id);

  /// Dismisses all notifications.
  void dismissAll();

  /// Stream of incoming notifications.
  Stream<NotificationMessage> get notifications;
}
