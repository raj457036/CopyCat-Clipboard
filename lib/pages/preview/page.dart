import 'dart:async';

import 'package:clipboard/pages/preview/view/horizontal.dart';
import 'package:clipboard/pages/preview/view/vertical.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/bloc/offline_persistance_cubit/offline_persistance_cubit.dart';
import 'package:clipboard/base/bloc/cloud_persistance_cubit/cloud_persistance_cubit.dart';
import 'package:clipboard/base/domain/services/cross_sync_listener.dart';
import 'package:clipboard/base/domain/services/sync_event_bus.dart';
import 'package:clipboard/di/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClipboardItemPreviewPage extends StatefulWidget {
  final ClipboardItem item;
  const ClipboardItemPreviewPage({super.key, required this.item});

  @override
  State<ClipboardItemPreviewPage> createState() => ClipboardItemPreviewState();

  static ClipboardItemPreviewState of(BuildContext context) {
    return context.findAncestorStateOfType<ClipboardItemPreviewState>()!;
  }
}

class ClipboardItemPreviewState extends State<ClipboardItemPreviewPage> {
  late ClipboardItem item;
  late final OfflinePersistenceCubit offlinePersistenceCubit;
  StreamSubscription<SyncEvent>? _syncSub;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    item = widget.item;
    offlinePersistenceCubit = context.read<OfflinePersistenceCubit>();
    _resolvePreviewItem();
    _syncSub = sl<SyncEventBus>().where<ClipboardItem>().listen(_onSyncEvent);
  }

  void _onSyncEvent(SyncEvent event) {
    final events = switch (event) {
      TypedSyncEvent<ClipboardItem>(:final event) => [event],
      TypedSyncBatchEvent<ClipboardItem>(:final events) => events,
      _ => <CrossSyncEvent<ClipboardItem>>[],
    };
    for (final (type, syncedItem) in events) {
      if (!_isSameItem(syncedItem)) continue;
      if (type == CrossSyncEventType.delete) {
        if (mounted) Navigator.of(context).maybePop();
        return;
      }
      if (syncedItem != item) updateItem(syncedItem);
    }
  }

  @override
  void dispose() {
    _syncSub?.cancel();
    super.dispose();
  }

  Future<void> _resolvePreviewItem() async {
    if (!item.previewOnly || item.id == null) return;
    final targetId = item.id!;
    final fullItem = await offlinePersistenceCubit.getItem(id: targetId);
    if (!mounted || fullItem == null) return;
    if (item.id != targetId) return;

    updateItem(fullItem);
  }

  void updateItem(ClipboardItem newItem) {
    setState(() {
      item = newItem;
    });
  }

  void _setDownloading(bool downloading) {
    setState(() {
      _isDownloading = downloading;
    });
  }

  bool _isSameItem(ClipboardItem? other) {
    if (other == null) return false;
    // Match by local id first, then by server id if available
    if (item.id != null && other.id != null) {
      return item.id == other.id;
    }
    if (item.serverId != null && other.serverId != null) {
      return item.serverId == other.serverId;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final displayItem = _isDownloading
        ? item.copyWith(downloading: true)
        : item;

    return BlocListener<CloudPersistanceCubit, CloudPersistanceState>(
      listener: (context, state) {
        state.maybeMap(
          downloadingFile: (s) {
            if (_isSameItem(s.item)) {
              _setDownloading(true);
            }
          },
          saved: (s) {
            if (_isSameItem(s.item)) {
              _setDownloading(false);
              updateItem(s.item);
            }
          },
          error: (s) {
            if (_isSameItem(s.item)) {
              _setDownloading(false);
            }
          },
          orElse: () {},
        );
      },
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return constraints.maxWidth > 600
              ? ClipItemPreviewHorizontalView(item: displayItem)
              : ClipItemPreviewVerticalView(item: displayItem);
        },
      ),
    );
  }
}
