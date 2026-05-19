import 'package:clipboard/pages/collections/pages/create_edit/widgets/create_edit_form.dart';
import 'package:clipboard/base/domain/model/clip_collection/clipcollection.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:flutter/material.dart';

class ClipCollectionCreateEditPage extends StatelessWidget {
  final ClipCollection? collection;

  const ClipCollectionCreateEditPage({super.key, this.collection});

  @override
  Widget build(BuildContext context) {
    final title = collection == null
        ? context.locale.collections__appbar__title__create
        : context.locale.collections__appbar__title__edit;

    return Scaffold(
      appBar: AppBar(title: FittedBox(child: Text(title))),
      body: SingleChildScrollView(
        child: ClipCollectionCreateEditForm(collection: collection),
      ),
    );
  }
}
