import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/pages/collection_selection/widgets/collection_selection_grid.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/fabs/create_collection.dart';
import 'package:clipboard/widgets/local_user.dart';
import 'package:clipboard/widgets/scaffold_body.dart';
import 'package:flutter/material.dart';

class ClipCollectionSelectionPage extends StatelessWidget {
  final int? selectedCollectionId;
  const ClipCollectionSelectionPage({super.key, this.selectedCollectionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: context.mq.isMobile || context.mq.isTablet,
        title: Text(context.locale.select_collection__appbar__title),
      ),
      floatingActionButton: const DisableForLocalUser(
        ifLocal: CreateCollectionButton(localMode: true),
        child: CreateCollectionButton(),
      ),
      body: ScaffoldBody(
        child: SafeArea(
          child: CollectionSelectionGrid(
            selectedCollectionId: selectedCollectionId,
          ),
        ),
      ),
    );
  }
}
