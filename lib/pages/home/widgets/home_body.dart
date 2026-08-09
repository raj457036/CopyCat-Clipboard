import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/sync_status_cubit/sync_status_cubit.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/pages/home/widgets/collection_filter_chips.dart';
import 'package:clipboard/pages/home/widgets/compact_search_bar.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/app_layout_builder.dart';
import 'package:clipboard/widgets/appconfig_flag.dart';
import 'package:clipboard/widgets/clip_view_builders/builder.dart';
import 'package:clipboard/widgets/clips_provider.dart';
import 'package:clipboard/widgets/indexing_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  Future<void> refresh(BuildContext context) async {
    final cubit = context.read<SyncStatusCubit>();
    await cubit.syncAll(const SyncAllParams(force: true));
  }

  @override
  Widget build(BuildContext context) {
    final view = context.select(
      (AppConfigCubit cubit) => cubit.state.config.view,
    );

    return Column(
      children: [
        AppConfigBuilder(
          when: (config) => !config.searchIndexReady,
          builder: (context) {
            return const IndexingProgress();
          },
        ),
        if (!context.isMobile)
          view == AppView.windowed
              ? const CollectionFilterChips()
              : const CompactSearchBar(child: CollectionFilterChips()),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => await refresh(context),
            child: AppLayoutBuilder(
              builder: (context, layout, _) {
                return ClipsProviderWithBuilder(
                  builder: (context, clips, hasMore, loading, loadMore) {
                    return ClipsBuilder(
                      items: clips,
                      hasMore: hasMore,
                      loading: loading,
                      loadMore: loadMore,
                      layoutView: layout,
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
