import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/clip_collection/clipcollection.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/pages/collections/pages/create_edit/widgets/create_edit_form.dart';
import 'package:clipboard/widgets/scaffold_body.dart';
import 'package:flutter/material.dart';

class ClipCollectionCreateEditDialogContent extends StatelessWidget {
  final ClipCollection? collection;

  const ClipCollectionCreateEditDialogContent({super.key, this.collection});

  @override
  Widget build(BuildContext context) {
    final title = collection == null
        ? context.locale.collections__appbar__title__create
        : context.locale.collections__appbar__title__edit;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: CloseButton(onPressed: () => Navigator.of(context).maybePop()),
      ),
      body: ScaffoldBody(
        margin: const EdgeInsets.symmetric(horizontal: padding12),
        child: SizedBox.expand(
          child: SingleChildScrollView(
            child: ClipCollectionCreateEditForm(collection: collection),
          ),
        ),
      ),
    );
  }
}
