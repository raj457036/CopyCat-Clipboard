import 'package:clipboard/pages/preview/view/horizontal.dart';
import 'package:clipboard/pages/preview/view/vertical.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/bloc/offline_persistance_cubit/offline_persistance_cubit.dart';
import 'package:clipboard/base/bloc/cloud_persistance_cubit/cloud_persistance_cubit.dart';
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
  bool _isDownloading = false;

  @override
  void initState() {
    item = widget.item;
    super.initState();
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
      child: BlocListener<OfflinePersistenceCubit, OfflinePersistanceState>(
        listener: (context, state) {
          // Listen for item updates (from sync, etc.)
          final items = state.maybeMap(
            initial: (_) => <ClipboardItem>[],
            creatingItems: (s) => s.items,
            updatingItems: (s) => s.items,
            deletingItems: (s) => s.items,
            deletedItems: (s) => s.items,
            saved: (s) => s.items,
            error: (_) => <ClipboardItem>[],
            orElse: () => <ClipboardItem>[],
          );

          final updatedItem = items.cast<ClipboardItem?>().firstWhere(
            (i) => _isSameItem(i),
            orElse: () => null,
          );

          if (updatedItem != null && updatedItem != item) {
            updateItem(updatedItem);
          }
        },
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return constraints.maxWidth > 600
                ? ClipItemPreviewHorizontalView(item: displayItem)
                : ClipItemPreviewVerticalView(item: displayItem);
          },
        ),
      ),
    );
  }
}
