import 'package:clipboard/pages/collection_selection/widgets/collection_selection_grid.dart';
import 'package:flutter/material.dart';

/// Dialog / end-sheet version of the collection selection UI.
class CollectionSelectionDialogContent extends StatelessWidget {
  final int? selectedCollectionId;

  const CollectionSelectionDialogContent({
    super.key,
    this.selectedCollectionId,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CollectionSelectionGrid(
        selectedCollectionId: selectedCollectionId,
        showCreateItem: true,
      ),
    );
  }
}
