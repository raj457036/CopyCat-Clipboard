import 'dart:async';

import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/offline_persistance_cubit/offline_persistance_cubit.dart';
import 'package:clipboard/base/common/logging.dart';
import 'package:clipboard/base/constants/misc.dart';
import 'package:clipboard/base/constants/numbers/values.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/base/widgets/drag_drop/drop_area.dart';
import 'package:clipboard/base/widgets/subscription/subscription_provider.dart';
import 'package:clipboard/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_clipboard/super_clipboard.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';
import 'package:universal_io/io.dart';

class ClipDropRegionProvider extends StatelessWidget {
  final Widget child;
  final VoidCallback? onDragStart;
  final VoidCallback? onDragStop;

  const ClipDropRegionProvider({
    super.key,
    required this.child,
    this.onDragStart,
    this.onDragStop,
  });

  @override
  Widget build(BuildContext context) {
    // final side = context.mq.size.shortestSide;
    // final isTablet = side > Breakpoints.sm;
    if (Platform.isAndroid) return child;

    return BlocSelector<AppConfigCubit, AppConfigState, bool>(
        selector: (state) {
      switch (state) {
        case AppConfigLoaded(:final config):
          return config.enableDragNDrop;
        default:
          return false;
      }
    }, builder: (context, enabled) {
      if (!enabled) return child;
      return SubscriptionBuilder(builder: (context, subscription) {
        if (subscription == null) return child;
        if (subscription.isActive && subscription.dragNdrop) {
          return ClipDropRegion(
            onDragStart: onDragStart,
            onDragStop: onDragStop,
            child: child,
          );
        }
        return child;
      });
    });
  }
}

class ClipDropRegion extends StatefulWidget {
  final Widget child;
  final VoidCallback? onDragStart;
  final VoidCallback? onDragStop;

  const ClipDropRegion({
    super.key,
    required this.child,
    this.onDragStart,
    this.onDragStop,
  });

  @override
  State<ClipDropRegion> createState() => _ClipDropRegionState();
}

class _ClipDropRegionState extends State<ClipDropRegion> {
  bool dropZoneActive = false;
  bool processing = false;
  bool _dragStarted = false;
  late final OfflinePersistenceCubit cubit;

  void didDragStart(DropSession session) {
    if (widget.onDragStart == null || _dragStarted) return;
    final isLocalItem = session.items.firstOrNull?.localData != null;
    if (isLocalItem) {
      widget.onDragStart!();
      _dragStarted = true;
    }
  }

  void didDragStop(DropSession session) {
    if (widget.onDragStop == null || !_dragStarted) return;
    _dragStarted = false;
    widget.onDragStop!();
  }

  @override
  void initState() {
    super.initState();
    cubit = context.read<OfflinePersistenceCubit>();
  }

  bool dropAllowed(DropItem item) {
    if (item.localData is Map &&
        (item.localData as Map).containsKey("itemId")) {
      // This is a drag within the app and has custom local data set.
      return false;
    }
    return true;
  }

  void onDropEnter(DropEvent event) {
    didDragStart(event.session);
    final item = event.session.items.first;
    final isDropAllowed = dropAllowed(item);
    if (!isDropAllowed) return;
    enableDropZone();
  }

  void onDropEnded(DropEvent event) {
    didDragStop(event.session);
    disableDropZone();
  }

  void onDropLeave(DropEvent event) {
    disableDropZone();
  }

  void enableDropZone() =>
      !dropZoneActive ? setState(() => dropZoneActive = true) : null;

  void disableDropZone() =>
      dropZoneActive ? setState(() => dropZoneActive = false) : null;

  FutureOr<DropOperation> onDropOver(DropOverEvent event) {
    if (processing) return DropOperation.none;
    if (event.session.allowedOperations.contains(DropOperation.copy)) {
      final item = event.session.items.first;
      final isDropAllowed = dropAllowed(item);
      if (isDropAllowed) enableDropZone();
      return DropOperation.copy;
    } else {
      return DropOperation.none;
    }
  }

  Future<void> onPerformDrop(PerformDropEvent event) async {
    if (processing) return;
    setState(() => processing = true);
    try {
      final items = event.session.items;

      final isDropAllowed = dropAllowed(items.first);
      if (!isDropAllowed) return;

      final res = <(DataReader, DataFormat)>[];
      int pastedCount = 0;

      for (final item in items) {
        if (pastedCount >= kMaxDropItemCount) break;
        final reader = item.dataReader;
        if (reader == null) continue;
        DataFormat? selectedFormat;
        final itemFormats = reader.getFormats(allSupportedClipFormats);

        selectedFormat = cubit.clipboard.filterOutByPriority(
          itemFormats,
        );
        if (selectedFormat == null) continue;
        res.add((reader, selectedFormat));
        pastedCount++;
      }

      if (items.length > kMaxDropItemCount) {
        showTextSnackbar(
          context.locale.dnd__ack__error_max_drop_count(
            count: kMaxDropItemCount,
          ),
        );
      }

      final clips = await cubit.clipboard.processMultipleReaderDataFormat(
        res,
        manual: true,
      );
      if (clips != null) {
        cubit.onClips(clips, manualPaste: true);
      }
    } catch (error) {
      logger.e(error);
    } finally {
      setState(() => processing = false);
      disableDropZone();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropRegion(
      formats: allSupportedClipFormats,
      onDropOver: onDropOver,
      onDropEnter: onDropEnter,
      onDropLeave: onDropLeave,
      onDropEnded: onDropEnded,
      onPerformDrop: onPerformDrop,
      child: Stack(
        children: [
          widget.child,
          if (dropZoneActive)
            Positioned.fill(
              child: DropArea(processing: processing),
            ),
        ],
      ),
    );
  }
}
