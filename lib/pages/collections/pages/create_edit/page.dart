import 'package:clipboard/pages/collections/pages/create_edit/widgets/create_edit_form.dart';
import 'package:copycat_base/db/clip_collection/clipcollection.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:flutter/material.dart';

class ClipCollectionCreateEditPage extends StatelessWidget {
  final ClipCollection? collection;

  const ClipCollectionCreateEditPage({
    super.key,
    this.collection,
  });

  @override
  Widget build(BuildContext context) {
    final title = collection == null
        ? context.locale.createCollection
        : context.locale.editCollection;
    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size(320, 430)),
      child: Scaffold(
        appBar: AppBar(
          title: FittedBox(child: Text(title)),
        ),
        body: SingleChildScrollView(
            child: ClipCollectionCreateEditForm(collection: collection)),
      ),
    );
  }
}
