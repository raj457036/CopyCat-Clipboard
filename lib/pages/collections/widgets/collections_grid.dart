import 'package:clipboard/base/bloc/clip_collection_cubit/clip_collection_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/clip_collection_grid_item.dart';
import 'package:clipboard/widgets/no_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollectionsGrid extends StatelessWidget {
  final String searchQuery;
  final int crossAxisCount;
  final bool isMobile;

  const CollectionsGrid({
    super.key,
    required this.searchQuery,
    required this.crossAxisCount,
    required this.isMobile,
  });

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

                final filtered = searchQuery.isEmpty
                    ? collections
                    : collections.where((c) {
                        return c.title.toLowerCase().contains(searchQuery) ||
                            (c.description?.toLowerCase().contains(
                                  searchQuery,
                                ) ??
                                false);
                      }).toList();

                if (filtered.isEmpty && searchQuery.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 48),
                        const SizedBox(height: 16),
                        Text(context.locale.app__no_results),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  cacheExtent: 300,
                  padding: isMobile ? const EdgeInsets.all(padding10) : inset12,
                  itemCount: filtered.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 16 / 7,
                    mainAxisExtent: 100,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final collection = filtered[index];
                    final originalIdx = collections.indexWhere(
                      (c) => c.id == collection.id,
                    );
                    final isReadOnly =
                        originalIdx >= 0 && originalIdx >= activeLimit;
                    return ClipCollectionGridItem(
                      autoFocus: isDesktopPlatform && index == 0,
                      collection: collection,
                      isReadOnly: isReadOnly,
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
