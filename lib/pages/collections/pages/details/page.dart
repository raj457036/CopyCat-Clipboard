import 'package:clipboard/base/bloc/clip_collection_cubit/clip_collection_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/clip_collection/clipcollection.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/pages/collections/pages/details/widgets/detail_clips_view.dart';
import 'package:clipboard/widgets/app_bar/selection_appbar.dart';
import 'package:clipboard/widgets/clip_item/clip_collection_indicator_scope.dart';
import 'package:clipboard/widgets/collection_upgrade_action.dart';
import 'package:clipboard/widgets/keyboard_shortcuts/seq_selection_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CollectionDetailPage extends StatelessWidget {
  final ClipCollection collection;
  const CollectionDetailPage({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    final title = "${collection.emoji} • ${collection.title}";

    void editCollection() {
      GoRouter.of(context).pushNamed(
        RouteConstants.createEditCollection,
        pathParameters: {"id": collection.id.toString()},
      );
    }

    return BlocSelector<ClipCollectionCubit, ClipCollectionState, bool>(
      selector: (state) =>
          state.mapOrNull(loaded: (s) => s.isReadOnly(collection)) ?? false,
      builder: (context, isReadOnly) {
        return ClipCollectionIndicatorScope(
          enabled: false,
          child: SeqSelectionListener(
            child: Scaffold(
              appBar: SelectionAppbar(
                defaultChild: AppBar(
                  title: Text(title),
                  centerTitle: false,
                  actions: [
                    if (!isReadOnly)
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: context.locale.app__edit,
                        onPressed: editCollection,
                      ),
                    width10,
                  ],
                ),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isReadOnly)
                    MaterialBanner(
                      padding: const EdgeInsets.symmetric(
                        horizontal: padding16,
                        vertical: 8,
                      ),
                      margin: const EdgeInsets.only(bottom: padding10),
                      leading: const Icon(Icons.lock_outline_rounded),
                      content: Text(
                        context.locale.collections__read_only__banner,
                      ),
                      actions: const [CollectionUpgradeAction()],
                    ),
                  const Expanded(child: CollectionDetailClipsView()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
