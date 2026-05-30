import 'package:clipboard/base/bloc/clip_collection_cubit/clip_collection_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/data/services/notification_service.dart';
import 'package:clipboard/base/domain/model/clip_collection/clipcollection.dart';
import 'package:clipboard/base/domain/model/notification_message.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/sheets/emoji_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';

class ClipCollectionCreateEditForm extends StatefulWidget {
  final ClipCollection? collection;
  const ClipCollectionCreateEditForm({super.key, this.collection});

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
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    cubit = context.read<ClipCollectionCubit>();
    formKey = GlobalKey<FormState>();
    emojiController = TextEditingController(
      text: widget.collection?.emoji ?? "🏆",
    );
    nameController = TextEditingController(text: widget.collection?.title);
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
    setState(() => _isSaving = true);

    ClipCollection collection;
    final description = descriptionController.text.trim().isEmpty
        ? null
        : descriptionController.text.trim();
    if (widget.collection == null) {
      collection = ClipCollection(
        emoji: emojiController.text,
        title: nameController.text.trim(),
        description: description,
        created: systemTime(),
        modified: systemTime(),
      );
    } else {
      collection = widget.collection!.copyWith(
        emoji: emojiController.text,
        title: nameController.text.trim(),
        description: description,
      );
    }
    final error = await cubit.upsert(collection);
    if (mounted) {
      if (error != null) {
        setState(() => _isSaving = false);
        if (!context.mounted) return;
        {
          InAppNotificationService.i.notify(
            NotificationMessage.builder(
              builder: (context) => NotificationContent(body: error.message),
              id: 'collection-upsert-error',
            ),
          );
        }
      } else {
        if (context.mounted) {
          GoRouter.of(context).pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ClipCollectionCubit>();
    final allCollections =
        cubit.state.mapOrNull(loaded: (loaded) => loaded.collections) ?? [];

    final options = [
      TextButton(
        onPressed: _isSaving ? null : context.pop,
        child: Text(context.mlocale.cancelButtonLabel.title),
      ),
      FilledButton(
        onPressed: _isSaving ? null : submit,
        child: _isSaving
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(context.mlocale.saveButtonLabel.title),
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
            Text(
              context.locale.collections__label__emoji,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            height8,
            TextFormField(
              decoration: InputDecoration(
                labelText: context.locale.collections__input__name,
              ),
              controller: nameController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return context.locale.collections__validation__name_required;
                }
                if (value.length > 30) {
                  return context
                      .locale
                      .collections__validation__name_max_length;
                }

                final isDuplicate = allCollections.any((c) {
                  final isDifferentCollection =
                      widget.collection == null ||
                      c.id != widget.collection?.id;
                  return isDifferentCollection &&
                      c.emoji == emojiController.text &&
                      c.title.toLowerCase() == value.trim().toLowerCase();
                });

                if (isDuplicate) {
                  return context.locale.collections__validation__duplicate;
                }

                return null;
              },
              autofocus: true,
              textInputAction: TextInputAction.next,
              maxLength: 30,
            ),
            height12,
            TextFormField(
              decoration: InputDecoration(
                labelText: context.locale.collections__input__description,
              ),
              validator: ValidationBuilder(
                optional: true,
              ).maxLength(255).build(),
              controller: descriptionController,
              minLines: 2,
              maxLines: 6,
              maxLength: 255,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => submit(),
            ),
            height12,
            OverflowBar(
              spacing: 10,
              alignment: MainAxisAlignment.end,
              children: options,
            ),
          ],
        ),
      ),
    );
  }
}
