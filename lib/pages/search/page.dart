import 'package:clipboard/bloc/cloud_persistance_cubit/cloud_persistance_cubit.dart';
import 'package:clipboard/bloc/offline_persistance_cubit/offline_persistance_cubit.dart';
import 'package:clipboard/bloc/search_cubit/search_cubit.dart';
import 'package:clipboard/constants/numbers/breakpoints.dart';
import 'package:clipboard/constants/strings/asset_constants.dart';
import 'package:clipboard/constants/widget_styles.dart';
import 'package:clipboard/l10n/l10n.dart';
import 'package:clipboard/pages/search/widgets/search_bar.dart';
import 'package:clipboard/routes/utils.dart';
import 'package:clipboard/widgets/clip_card.dart';
import 'package:clipboard/widgets/nav_rail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  void loadMore(BuildContext context) {
    context.read<SearchCubit>().search(null);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = Breakpoints.isMobile(width);
    final floatingActionButton =
        getFloatingActionButton(context, 1, isMobile: isMobile);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight + (isMobile ? 45 : 30),
        centerTitle: true,
        title: const SearchInputBar(),
      ),
      body: LeftNavRail(
        floatingActionButton: floatingActionButton,
        navbarActiveIndex: 1,
        child: MultiBlocListener(
          listeners: [
            BlocListener<OfflinePersistanceCubit, OfflinePersistanceState>(
              listenWhen: (previous, current) {
                switch (current) {
                  case OfflinePersistanceDeleted() || OfflinePersistanceSaved():
                    return true;
                  case _:
                    return false;
                }
              },
              listener: (context, state) {
                switch (state) {
                  case OfflinePersistanceDeleted(:final item):
                    context.read<SearchCubit>().deleteItem(item);
                  case OfflinePersistanceSaved(:final item):
                    context.read<SearchCubit>().put(item);
                  case _:
                }
              },
            ),
            BlocListener<CloudPersistanceCubit, CloudPersistanceState>(
                listener: (context, state) {
              switch (state) {
                case CloudPersistanceUploadingFile(:final item) ||
                      CloudPersistanceDownloadingFile(:final item):
                  context.read<SearchCubit>().put(item);
                  break;
              }
            }),
          ],
          child: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              switch (state) {
                case InitialSearchState():
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          AssetConstants.search,
                          width: 250,
                        ),
                        height16,
                        Text(context.locale.findWhateverYouLooking),
                      ],
                    ),
                  );
                case SearchingState():
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case SearchErrorState(:final failure):
                  return Center(
                    child: Text(failure.message),
                  );
                case SearchResultState(:final results, :final hasMore):
                  {
                    if (results.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              AssetConstants.noData,
                              width: 200,
                            ),
                            height16,
                            Text(
                              context.locale.noResultsWereFound,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    final hasMoreResult = hasMore ? 1 : 0;

                    return GridView.builder(
                      padding: isMobile ? insetLTR16 : insetAll16,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 250,
                        crossAxisSpacing: padding8,
                        mainAxisSpacing: padding8,
                        childAspectRatio: isMobile ? 2 / 3 : 1,
                      ),
                      itemCount: results.length + hasMoreResult,
                      itemBuilder: (context, index) {
                        if (index == results.length) {
                          return Card.outlined(
                            child: Center(
                              child: TextButton.icon(
                                onPressed: () => loadMore(context),
                                label: Text(
                                  context.locale.loadMore,
                                ),
                                icon: const Icon(Icons.read_more),
                              ),
                            ),
                          );
                        }

                        final item = results[index];
                        return ClipCard(
                          key: ValueKey("clipboard-item-//${item.id}"),
                          item: item,
                          // deleteAllowed: false,
                        );
                      },
                    );
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
