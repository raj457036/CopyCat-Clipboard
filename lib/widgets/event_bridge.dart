import 'package:clipboard/base/bloc/cloud_persistance_cubit/cloud_persistance_cubit.dart';
import 'package:clipboard/base/bloc/event_bus_cubit/event_bus_cubit.dart';
import 'package:clipboard/base/bloc/offline_persistance_cubit/offline_persistance_cubit.dart';
import 'package:clipboard/base/data/services/notification_service.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/model/notification_message.dart'
    show NotificationMessage, NotificationType;
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:clipboard/base/domain/services/sync_event_bus.dart';
import 'package:clipboard/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventBridge extends StatelessWidget {
  final EventBusCubit eventBus;
  final Widget child;

  const EventBridge({super.key, required this.eventBus, required this.child});

  void broadcastEvent(CrossSyncEventType eventType, ClipboardItem item) {
    sl<SyncEventBus>().emit<ClipboardItem>((eventType, item));
  }

  void broadcastBatchEvent(
    CrossSyncEventType eventType,
    List<ClipboardItem> items,
  ) {
    if (items.isEmpty) return;
    if (items.length == 1) {
      broadcastEvent(eventType, items.first);
      return;
    }
    final payload = items.map((item) => (eventType, item)).toList();
    sl<SyncEventBus>().emitBatch<ClipboardItem>(payload);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CloudPersistanceCubit, CloudPersistanceState>(
          listener: (context, state) async {
            final offlineCubit = context.read<OfflinePersistenceCubit>();
            switch (state) {
              case CloudPersistanceSaved(:final item):
                offlineCubit.persist([item], synced: true);
              case CloudPersistanceDeleted(:final items):
                offlineCubit.delete(items);
              case CloudPersistanceError(:final failure, :final item):
                InAppNotificationService.i.notify(
                  NotificationMessage(
                    id: "cloud_persistance_error",
                    body: failure.message,
                    type: NotificationType.error,
                  ),
                );
                if (item != null) {
                  broadcastEvent(CrossSyncEventType.update, item);
                }
              case CloudPersistanceCreating(:final item) ||
                  CloudPersistanceUpdating(:final item):
              case CloudPersistanceUploadingFile(:final item) ||
                  CloudPersistanceDownloadingFile(:final item):
                broadcastEvent(CrossSyncEventType.update, item);
              case _:
            }
          },
        ),
      ],
      child: child,
    );
  }
}
