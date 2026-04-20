import 'package:clipboard/base/bloc/collection_clips_cubit/collection_clips_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/domain/model/clip_collection/clipcollection.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/widgets/app_bar/selection_appbar.dart';
import 'package:clipboard/widgets/app_layout_builder.dart';
import 'package:clipboard/widgets/can_paste_builder.dart';
import 'package:clipboard/widgets/clip_view_builders/grid/builder.dart';
import 'package:clipboard/widgets/clip_view_builders/grid/view.dart';
import 'package:clipboard/widgets/clip_view_builders/list/builder.dart';
import 'package:clipboard/widgets/clip_item/clip_collection_indicator_scope.dart';
import 'package:clipboard/widgets/clips_provider.dart';
import 'package:clipboard/widgets/keyboard_shortcuts/seq_selection_listener.dart';
import 'package:clipboard/widgets/scaffold_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CollectionDetailPage extends StatelessWidget {
  final ClipCollection collection;
  const CollectionDetailPage({super.key, required this.collection});

  void loadMore(BuildContext context) {
    context.read<CollectionClipsCubit>().search(null);
  }

  @override
  Widget build(BuildContext context) {
    final title = "${collection.emoji} • ${collection.title}";

    void editCollection() {
      GoRouter.of(context).pushNamed(
        RouteConstants.createEditCollection,
        pathParameters: {"id": collection.id.toString()},
      );
    }

    return ClipCollectionIndicatorScope(
      enabled: false,
      child: SeqSelectionListener(
        child: Scaffold(
          appBar: SelectionAppbar(
            defaultChild: AppBar(
              title: Text(title),
              centerTitle: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: context.locale.app__edit,
                  onPressed: editCollection,
                ),
              ],
            ),
          ),
          body: ScaffoldBody(
            margin: const EdgeInsets.only(right: padding12, left: padding12),
            child: AppLayoutBuilder(
              builder: (context, layout, _) {
                return switch (layout) {
                  AppLayout.grid => ClipGrid(
                    builder: (delegate, scrollDirection) {
                      return ClipsProviderWithBuilder(
                        isCollectionClips: true,
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
                    builder: (context, canPaste) {
                      return ClipsProviderWithBuilder(
                        isCollectionClips: true,
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
          ),
        ),
      ),
    );
  }
}
