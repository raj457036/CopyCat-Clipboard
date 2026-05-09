import 'package:clipboard/pages/collections/pages/create_edit/widgets/create_edit_form.dart';
import 'package:clipboard/base/domain/model/clip_collection/clipcollection.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';

class ClipCollectionCreateEditPage extends StatelessWidget {
  final ClipCollection? collection;

  const ClipCollectionCreateEditPage({super.key, this.collection});

  @override
  Widget build(BuildContext context) {
    final title = collection == null
        ? context.locale.collections__appbar__title__create
        : context.locale.collections__appbar__title__edit;

    final width = context.mq.size.width;
    final height = context.mq.size.height;

    // Responsive sizing: use 90% of screen on mobile, 80% on tablet, fixed on desktop
    final dialogWidth = context.mq.isMobile || context.mq.isTablet
        ? width * 0.9
        : width < 1200
        ? width * 0.5
        : 500.0;
    final dialogHeight = height < 700 ? height * 0.85 : 550.0;
    return ConstrainedBox(
      constraints: BoxConstraints.loose(
        Size(dialogWidth.clamp(280.0, 600.0), dialogHeight.clamp(400.0, 800.0)),
      ),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: context.mq.isMobile || context.mq.isTablet,
          title: FittedBox(child: Text(title)),
        ),
        body: SingleChildScrollView(
          child: ClipCollectionCreateEditForm(collection: collection),
        ),
      ),
    );
  }
}
