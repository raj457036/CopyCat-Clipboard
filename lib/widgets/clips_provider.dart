import 'package:clipboard/base/bloc/clipboard_cubit/clipboard_cubit.dart';
import 'package:clipboard/base/bloc/collection_clips_cubit/collection_clips_cubit.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/widgets/clipcard_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A provider for clips that are being displayed in the UI.
/// This is used to avoid passing the clips down the widget tree manually.
class ClipsProvider extends InheritedWidget {
  final List<ClipboardItem> clips;

  const ClipsProvider({super.key, required super.child, required this.clips});

  static ClipsProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ClipsProvider>();
  }

  @override
  bool updateShouldNotify(covariant ClipsProvider oldWidget) {
    return oldWidget.clips != clips;
  }
}

typedef ClipProviderBuilder =
    Widget Function(
      BuildContext context,
      List<ClipboardItem> clips,
      bool hasMore,
      bool loading,
      VoidCallback loadMore,
    );

class ClipsProviderWithBuilder extends StatelessWidget {
  final ClipProviderBuilder builder;
  final bool isCollectionClips;

  const ClipsProviderWithBuilder({
    super.key,
    required this.builder,
    this.isCollectionClips = false,
  });

  Future<void> loadMoreCollectionClips(BuildContext context) async {
    await context.read<CollectionClipsCubit>().fetch();
  }

  Future<void> loadMore(BuildContext context) async {
    await context.read<ClipboardCubit>().fetch();
  }

  Widget buildRoot(BuildContext context) {
    return BlocSelector<ClipboardCubit, ClipboardState, (int, bool, bool)>(
      selector: (state) {
        return (state.revision, state.hasMore, state.loading);
      },
      builder: (context, state) {
        final (_, hasMore, loading) = state;
        final items = context.read<ClipboardCubit>().items;
        return ClipsProvider(
          clips: items,
          child: builder(
            context,
            items,
            hasMore,
            loading,
            () => loadMore(context),
          ),
        );
      },
    );
  }

  Widget buildCollectionClips(BuildContext context) {
    return BlocBuilder<CollectionClipsCubit, CollectionClipsState>(
      builder: (context, state) {
        switch (state) {
          case InitialCollectionClipsState() || SearchingCollectionClipsState():
            return const ClipcardLoading();
          case CollectionClipsErrorState(:final failure):
            return Center(child: Text(failure.message));
          case CollectionClipsResultsState(:final results, :final hasMore):
            return ClipsProvider(
              clips: results,
              child: builder(
                context,
                results,
                hasMore,
                false,
                () => loadMore(context),
              ),
            );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isCollectionClips
        ? buildCollectionClips(context)
        : buildRoot(context);
  }
}
