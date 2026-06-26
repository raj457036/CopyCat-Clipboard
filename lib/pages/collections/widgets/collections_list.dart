import 'package:clipboard/base/bloc/clip_collection_cubit/clip_collection_cubit.dart';
import 'package:clipboard/base/domain/model/clip_collection/clipcollection.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/utils/collection_actions.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/clip_collection_list_item.dart';
import 'package:clipboard/widgets/menu.dart';
import 'package:clipboard/widgets/no_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollectionsListView extends StatelessWidget {
  final String searchQuery;
  final int crossAxisCount;
  final bool isMobile;

  const CollectionsListView({
    super.key,
    required this.searchQuery,
    required this.crossAxisCount,
    required this.isMobile,
  });

  List<ClipCollection> _filterCollections(List<ClipCollection> collections) {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) return collections;

    return collections
        .where((collection) {
          return collection.title.toLowerCase().contains(query) ||
              (collection.description?.toLowerCase().contains(query) ??
                  false) ||
              collection.emoji.contains(query);
        })
        .toList(growable: false);
  }

  int _getPosition(int index, int length) {
    if (index == 0) return -1; // first
    if (index == length - 1) return 1; // last
    return 0; // middle
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<ClipCollectionCubit>().fetch(fromTop: true),
      child: BlocBuilder<ClipCollectionCubit, ClipCollectionState>(
        builder: (context, state) {
          switch (state) {
            case ClipCollectionLoaded(loading: true):
              return const Center(child: CircularProgressIndicator());
            case ClipCollectionLoaded(
              :final failure,
              :final collections,
              :final activeLimit,
            ):
              {
                if (failure != null) {
                  return Center(child: Text(failure.message));
                }
                if (collections.isEmpty) {
                  return const Center(child: NoCollectionAvailable());
                }

                final filteredCollections = _filterCollections(collections);
                if (filteredCollections.isEmpty) {
                  return Center(child: Text(context.locale.app__no_results));
                }

                final readOnlyIds = collections
                    .skip(activeLimit)
                    .map((collection) => collection.id)
                    .whereType<int>()
                    .toSet();

                return ListView.separated(
                  scrollCacheExtent: const ScrollCacheExtent.pixels(300),
                  padding: isMobile ? const EdgeInsets.all(padding10) : inset12,
                  itemCount: filteredCollections.length,
                  separatorBuilder: (context, index) => height2,
                  itemBuilder: (context, index) {
                    final collection = filteredCollections[index];
                    final isReadOnly =
                        collection.id != null &&
                        readOnlyIds.contains(collection.id);
                    return Menu(
                      key: ValueKey('collection-menu-${collection.id}'),
                      items: [
                        if (!isReadOnly)
                          MenuItem(
                            icon: Icons.edit,
                            text: context.locale.app__edit,
                            onPressed: () => editClipCollection(
                              context,
                              collectionId: collection.id.toString(),
                            ),
                          ),
                        MenuItem(
                          icon: Icons.delete,
                          text: context.locale.app__delete,
                          onPressed: () => deleteClipCollection(
                            context,
                            collection: collection,
                          ),
                        ),
                      ],
                      child: ClipCollectionListItem(
                        autofocus: isDesktopPlatform && index == 0,
                        collection: collection,
                        isReadOnly: isReadOnly,
                        position: _getPosition(
                          index,
                          filteredCollections.length,
                        ),
                      ),
                    );
                  },
                );
              }
          }
        },
      ),
    );
  }
}
