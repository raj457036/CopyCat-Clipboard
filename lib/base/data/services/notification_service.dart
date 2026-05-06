import 'dart:async' show StreamController;

import 'package:clipboard/base/domain/model/notification_message.dart';
import 'package:clipboard/base/domain/services/notification_service.dart'
    show NotificationService;
import 'package:injectable/injectable.dart';

@LazySingleton(as: NotificationService)
class StreamNotificationService implements NotificationService {
  final StreamController<NotificationMessage> _controller =
      StreamController<NotificationMessage>.broadcast();

  @disposeMethod
  void dispose() {
    _controller.close();
  }

  @override
  void dismiss(String id) {
    // TODO: implement dismiss
  }

  @override
  void dismissAll() {
    // TODO: implement dismissAll
  }

  @override
  Stream<NotificationMessage> get notifications => _controller.stream;

  @override
  void notify(NotificationMessage message) {
    _controller.add(message);
  }
}
