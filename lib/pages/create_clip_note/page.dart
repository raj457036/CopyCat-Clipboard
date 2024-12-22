import 'package:clipboard/widgets/badges.dart';
import 'package:copycat_base/bloc/offline_persistance_cubit/offline_persistance_cubit.dart';
import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/db/clipboard_item/clipboard_item.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreateClipNotePage extends StatefulWidget {
  final ClipboardItem? item;

  const CreateClipNotePage({super.key, this.item});

  @override
  State<CreateClipNotePage> createState() => _CreateClipNotePageState();
}

class _CreateClipNotePageState extends State<CreateClipNotePage> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.item?.text);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> save() async {
    final note = controller.text;
    final cubit = context.read<OfflinePersistenceCubit>();
    context.pop();
    if (note.isNotEmpty && widget.item != null) {
      cubit.persist([widget.item!.copyWith(text: note)..applyId(widget.item!)]);
    }
  }

  Future<void> saveAsNew() async {
    final note = controller.text;
    final cubit = context.read<OfflinePersistenceCubit>();
    context.pop();
    if (note.isNotEmpty) {
      cubit.paste(note);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.item == null ? Text('New Clip') : Text("Edit Clip"),
            width10,
            TextBadge(message: "Experimental"),
          ],
        ),
        centerTitle: false,
        leading: CloseButton(),
        backgroundColor: colors.secondaryContainer,
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: saveAsNew,
            tooltip: "Save as new",
          ),
          if (widget.item != null)
            IconButton(
              icon: Icon(Icons.save_as_rounded),
              onPressed: save,
              tooltip: context.locale.save,
            ),
          width10,
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(padding10),
        child: TextField(
          scrollPadding: const EdgeInsets.all(padding10),
          maxLines: null,
          minLines: 100,
          controller: controller,
          autofocus: true,
          cursorColor: colors.primary,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter your clip note here',
          ),
        ),
      ),
    );
  }
}
