import 'package:clipboard/base/bloc/collection_sync_manager_cubit/collection_sync_manager_cubit.dart';
import 'package:clipboard/base/bloc/paste_stack_cubit/paste_stack_cubit.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/pages/home/widgets/paste_stack_body.dart';
import 'package:clipboard/widgets/app_layout_builder.dart';
import 'package:clipboard/widgets/can_paste_builder.dart';
import 'package:clipboard/widgets/clip_item/clip_collection_indicator_scope.dart';
import 'package:clipboard/widgets/clip_view_builders/grid/builder.dart';
import 'package:clipboard/widgets/clip_view_builders/grid/view.dart';
import 'package:clipboard/widgets/clip_view_builders/list/builder.dart';
import 'package:clipboard/widgets/clips_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key});

  Future<void> refresh(BuildContext context) async {
    final cubit = context.read<CollectionSyncManagerCubit>();
    await cubit.syncCollections(manual: true);
  }

  @override
  Widget build(BuildContext context) {
    return ClipCollectionIndicatorScope(
      enabled: true,
      child: BlocSelector<PasteStackCubit, PasteStackState, bool>(
        selector: (state) => state.active,
        builder: (context, active) {
          if (active) {
            return const PasteStackBody();
          }

          return RefreshIndicator(
            onRefresh: () async => await refresh(context),
            child: AppLayoutBuilder(
              builder: (context, layout, _) {
                return switch (layout) {
                  AppLayout.grid => ClipGrid(
                    builder: (delegate, scrollDirection) {
                      return ClipsProviderWithBuilder(
                        builder: (context, clips, hasMore, loading, loadMore) {
                          return ClipGridBuilder(
                            items: clips,
                            hasMore: hasMore,
                            loading: loading,
                            loadMore: loadMore,
                            delegate: delegate,
                            scrollDirection: scrollDirection,
                          );
                        },
                      );
                    },
                  ),
                  AppLayout.list => CanPasteBuilder(
                    builder: (context) {
                      return ClipsProviderWithBuilder(
                        builder: (context, clips, hasMore, loading, loadMore) {
                          return ClipListBuilder(
                            items: clips,
                            hasMore: hasMore,
                            loading: loading,
                            loadMore: loadMore,
                          );
                        },
                      );
                    },
                  ),
                };
              },
            ),
          );
        },
      ),
    );
  }
}
