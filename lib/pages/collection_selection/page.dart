import 'package:clipboard/widgets/clip_collection_grid_item.dart';
import 'package:clipboard/widgets/fabs/create_collection.dart';
import 'package:clipboard/widgets/local_user.dart';
import 'package:clipboard/widgets/no_collection.dart';
import 'package:clipboard/widgets/scaffold_body.dart';
import 'package:clipboard/base/bloc/clip_collection_cubit/clip_collection_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/base/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClipCollectionSelectionPage extends StatelessWidget {
  final int? selectedCollectionId;
  const ClipCollectionSelectionPage({
    super.key,
    this.selectedCollectionId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.locale.select_collection__appbar__title),
        actions: const [
          DisableForLocalUser(
            ifLocal: CreateCollectionButton(
              isFab: false,
              localMode: true,
            ),
            child: CreateCollectionButton(isFab: false),
          ),
          width10,
        ],
      ),
      body: ScaffoldBody(
        child: SafeArea(
          child: BlocBuilder<ClipCollectionCubit, ClipCollectionState>(
              builder: (context, state) {
            switch (state) {
              case ClipCollectionLoaded(loading: true):
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ClipCollectionLoaded(:final failure, :final collections):
                {
                  if (failure != null) {
                    return Center(
                      child: Text(failure.message),
                    );
                  }
                  if (collections.isEmpty) {
                    return const NoCollectionAvailable();
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(padding10),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 380,
                      childAspectRatio: 16 / 9,
                      mainAxisExtent: 100,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: collections.length,
                    itemBuilder: (context, index) {
                      final collection = collections[index];

                      return ClipCollectionGridItem(
                        collection: collection,
                        autoFocus: collection.id == selectedCollectionId ||
                            (index == 0 && isDesktopPlatform),
                        selectionOnly: true,
                        onTap: () => Navigator.pop(context, collection),
                      );
                    },
                  );
                }
            }
          }),
        ),
      ),
    );
  }
}
