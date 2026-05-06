import 'dart:async';

import 'package:clipboard/base/domain/model/notification_message.dart';
import 'package:clipboard/base/domain/services/notification_service.dart'
    show NotificationService;
import 'package:clipboard/di/di.dart';
import 'package:flutter/widgets.dart';

class NotificationListener extends StatefulWidget {
  final Widget child;

  const NotificationListener({super.key, required this.child});

  @override
  State<NotificationListener> createState() => _NotificationListenerState();
}

class _NotificationListenerState extends State<NotificationListener> {
  final _service = sl<NotificationService>();
  late final StreamSubscription<NotificationMessage> _subscription;

  @override
  void initState() {
    _subscription = _service.notifications.listen(_onNotification);
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    sl.resetLazySingleton<NotificationService>();
    super.dispose();
  }

  void _onNotification(NotificationMessage message) {
    // TODO: implement notification handling
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
