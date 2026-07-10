import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/data/services/notification_service.dart';
import 'package:clipboard/base/domain/model/notification_message.dart';
import 'package:clipboard/base/domain/repositories/clipboard.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/di/di.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IndexingProgress extends StatefulWidget {
  const IndexingProgress({super.key});

  @override
  State<IndexingProgress> createState() => _IndexingProgressState();
}

class _IndexingProgressState extends State<IndexingProgress> {
  late final AppConfigCubit _appConfigCubit;
  late final ClipboardRepository _clipboardRepository;
  int progress = 0;
  int total = 0;
  bool isIndexing = false;

  @override
  void initState() {
    super.initState();
    _appConfigCubit = context.read<AppConfigCubit>();
    _clipboardRepository = sl(instanceName: "local");

    if (!_appConfigCubit.state.config.searchIndexReady) {
      _fetchTotalCount();
    }
  }

  Future<void> _fetchTotalCount() async {
    final result = await _clipboardRepository.getClipCounts();
    result.fold(
      (failure) {
        logger.e('Failed to fetch total count: $failure');
        InAppNotificationService.i.notify(
          NotificationMessage(body: failure.message),
        );
      },
      (count) {
        setState(() {
          total = count;
        });
      },
    );
  }

  Future<void> _startIndexing() async {
    setState(() => isIndexing = true);

    bool hasMore = true;
    int offset = 0;
    bool completedSuccessfully = true;

    while (hasMore && isIndexing) {
      final items = await _clipboardRepository.getList(offset: offset);
      items.fold(
        (f) {
          logger.e("Failed to read clip while indexing");
          hasMore = false;
          InAppNotificationService.i.notify(
            NotificationMessage(body: f.message),
          );
          completedSuccessfully = false;
        },
        (result) async {
          hasMore = result.hasMore;
          offset += result.results.length;
          await _clipboardRepository.updateAll(result.results);
          setState(() {
            progress += result.results.length;
          });
        },
      );
    }
    setState(() => isIndexing = false);
    if (completedSuccessfully) {
      logger.d("✅ Indexing Completed");
      await _appConfigCubit.setSearchIndexingStatus(true);
      InAppNotificationService.i.notify(
        NotificationMessage.builder(
          builder: (context) =>
              NotificationContent(body: context.locale.app__indexing_completed),
        ),
      );
    }
  }

  void _stopIndexing() async {
    setState(() => isIndexing = false);
  }

  @override
  Widget build(BuildContext context) {
    if (total == 0) return const SizedBox.shrink();
    if (!isIndexing) {
      return MaterialBanner(
        content: Text(context.locale.app__index_pending(total: total)),
        actions: [
          ElevatedButton.icon(
            icon: const Icon(Icons.play_arrow),
            onPressed: _startIndexing,
            label: Text(context.locale.app__start_indexing),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.primary,
              foregroundColor: context.colors.onPrimary,
            ),
          ),
        ],
      );
    }

    return MaterialBanner(
      content: LinearProgressIndicator(value: progress / total),
      actions: [
        TextButton.icon(
          onPressed: _stopIndexing,
          icon: const Icon(Icons.stop),
          label: Text(context.locale.app__stop_indexing),
        ),
      ],
    );
  }
}
