import 'package:clipboard/base/bloc/clip_collection_cubit/clip_collection_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/db/clip_collection/clipcollection.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/sheets/emoji_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_io/io.dart';

class ClipCollectionCreateEditForm extends StatefulWidget {
  final ClipCollection? collection;
  const ClipCollectionCreateEditForm({
    super.key,
    this.collection,
  });

  @override
  State<ClipCollectionCreateEditForm> createState() =>
      _ClipCollectionCreateEditFormState();
}

class _ClipCollectionCreateEditFormState
    extends State<ClipCollectionCreateEditForm> {
  late final ClipCollectionCubit cubit;
  late final GlobalKey<FormState> formKey;
  late final TextEditingController emojiController,
      nameController,
      descriptionController;

  @override
  void initState() {
    super.initState();
    cubit = context.read<ClipCollectionCubit>();
    formKey = GlobalKey<FormState>();
    emojiController = TextEditingController(
      text: widget.collection?.emoji ?? "🏆",
    );
    nameController = TextEditingController(
      text: widget.collection?.title,
    );
    descriptionController = TextEditingController(
      text: widget.collection?.description,
    );
  }

  @override
  void dispose() {
    emojiController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> selectEmoji() async {
    final result = await const EmojiSelectorSheet().open(context);
    if (result == null) return;
    emojiController.text = result.emoji;
    setState(() {});
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState?.save();
    ClipCollection collection;
    final description = descriptionController.text.trim().isEmpty
        ? null
        : descriptionController.text.trim();
    if (widget.collection == null) {
      collection = ClipCollection(
        emoji: emojiController.text,
        title: nameController.text.trim(),
        description: description,
        created: now(),
        modified: now(),
      );
    } else {
      collection = widget.collection!.copyWith(
        emoji: emojiController.text,
        title: nameController.text.trim(),
        description: description,
      )..applyId(widget.collection!);
    }
    cubit.upsert(collection);
    GoRouter.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final options = [
      TextButton(
        onPressed: context.pop,
        child: Text(context.mlocale.cancelButtonLabel.title),
      ),
      FilledButton(
        onPressed: submit,
        child: Text(context.mlocale.saveButtonLabel.title),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(padding16),
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 55,
              child: IconButton.filledTonal(
                style: IconButton.styleFrom(fixedSize: const Size.square(100)),
                onPressed: selectEmoji,
                icon: Text(
                  emojiController.text,
                  style: const TextStyle(fontSize: 55),
                ),
              ),
            ),
            height12,
            TextFormField(
              decoration: InputDecoration(
                labelText: context.locale.collections__input__name,
              ),
              controller: nameController,
              validator: ValidationBuilder().required().maxLength(100).build(),
              autofocus: true,
            ),
            height12,
            TextFormField(
              decoration: InputDecoration(
                labelText: context.locale.collections__input__description,
              ),
              validator:
                  ValidationBuilder(optional: true).maxLength(255).build(),
              controller: descriptionController,
              minLines: 2,
              maxLines: 6,
              maxLength: 255,
            ),
            height12,
            OverflowBar(
              spacing: 10,
              alignment: MainAxisAlignment.end,
              children:
                  Platform.isWindows ? options.reversed.toList() : options,
            )
          ],
        ),
      ),
    );
  }
}
