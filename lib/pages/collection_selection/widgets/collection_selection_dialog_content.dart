import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/pages/collection_selection/widgets/collection_selection_grid.dart';
import 'package:clipboard/widgets/scaffold_body.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(context.locale.select_collection__appbar__title),
        leading: CloseButton(onPressed: () => Navigator.of(context).maybePop()),
      ),
      body: ScaffoldBody(
        margin: const EdgeInsets.symmetric(horizontal: padding12),
        child: SafeArea(
          child: CollectionSelectionGrid(
            selectedCollectionId: selectedCollectionId,
            showCreateItem: true,
          ),
        ),
      ),
    );
  }
}
